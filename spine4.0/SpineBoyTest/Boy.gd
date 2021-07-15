extends KinematicBody2D

var aiming = false
var jumping = false

func _process(delta: float) -> void:
	var bone = $SpineSprite.get_skeleton().find_bone('crosshair')
	bone.set_x(get_local_mouse_position().x/0.25)
	bone.set_y(-get_local_mouse_position().y/0.25)

	if Input.is_action_just_pressed('fire_mode'):
		aiming = not aiming
		if aiming:
			$AnimationTree['parameters/Transition/current'] = 0
		else:
			$AnimationTree['parameters/Transition/current'] = 1
		
	if aiming:
		if Input.is_action_just_pressed('click'):
			$AnimationTree['parameters/OneShot/active'] = true
	
	if Input.is_action_just_pressed('jump'):
		$AnimationTree['parameters/MovementSM/playback'].travel('jump')
		jumping = true

func _physics_process(delta: float) -> void:
	var input_vec = Vector2.ZERO;
	input_vec.x = Input.get_action_strength('move_right') - Input.get_action_strength('move_left');
	input_vec.y = Input.get_action_strength('move_down') - Input.get_action_strength('move_up');
	
	if not jumping:
		if input_vec.length() >= 0.1:
			$AnimationTree['parameters/MovementSM/playback'].travel('walk')
		else:
			$AnimationTree['parameters/MovementSM/playback'].travel('idle')
	
	move_and_slide(input_vec * 150)

func print_a1():
	print('eeee')
#----- Methods -----
func reset_skeleton():
	$SpineSprite.get_skeleton().set_bones_to_setup_pose()
	$SpineSprite.get_skeleton().set_slots_to_setup_pose()


func _on_SpineSprite_animation_end(animation_state: Object, track_entry: SpineTrackEntry, event: SpineEvent) -> void:
#	print('anim %s end' % track_entry.get_animation().get_anim_name())
	if track_entry.get_animation().get_anim_name() == 'jump':
		jumping = false


func _on_SpineSprite_animation_start(animation_state: Object, track_entry: SpineTrackEntry, event: Object) -> void:
#	print('anim %s start' % track_entry.get_animation().get_anim_name())
	pass


func _on_SpineSprite_animation_complete(animation_state: Object, track_entry: SpineTrackEntry, event: Object) -> void:
#	print('anim %s complete' % track_entry.get_animation().get_anim_name())
	if track_entry.get_animation().get_anim_name() == 'jump':
		jumping = false
