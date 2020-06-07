extends KinematicBody2D


onready var spine = $SpineSprite
onready var anim_tree = $AnimationTree
onready var anim_tree2 = $AnimationTree2
onready var anim_playback = anim_tree["parameters/playback"]
onready var anim_playback2 = anim_tree2["parameters/playback"]

var last_state = "idle"
var current_state = "idle" setget set_current_state

var velocity = Vector2.ZERO
var run_speed = 250

func _process(delta):
	var bone:SpineBone = spine.get_skeleton().find_slot("crosshair").get_bone()
	var pos = spine.get_local_mouse_position()
	if pos.x > 0:
		bone.set_x(pos.x)
		bone.set_y(-pos.y)
		
		anim_playback2.travel("aim")
	else:
		anim_playback2.travel("not_aim")
	
	if Input.is_action_just_pressed("click"):
		play_attack_animation()
	
	if Input.is_action_just_pressed("jump"):
		play_jump_animation()
	

func _physics_process(delta):
	
	move_and_slide(velocity)
	
	if current_state == "jump":
		return
		
	var input_vec = Vector2.ZERO
	input_vec.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vec.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	input_vec = input_vec.normalized()
	
	var temp_velocity = input_vec * run_speed
	velocity = velocity.linear_interpolate(temp_velocity, 0.23)
	
	if velocity.length() > 10 :
		anim_playback.travel("run")
		
		# flip
		if abs(velocity.x) > 0:
			spine.scale.x = abs(spine.scale.x) * sign(velocity.x)
		self.current_state = "run"
	else:
		anim_playback.travel("idle")
		self.current_state = "idle"

func play_attack_animation():
	spine.get_animation_state().set_animation("shoot", false, 2)
	
func play_jump_animation():
	if current_state == "jump":
		return
	self.current_state = "jump"
	spine.get_animation_state().set_animation("jump", false)
	spine.get_animation_state().add_animation("idle" if last_state == "idle" else "run", 0, true)


func _on_SpineSprite_animation_complete(animation_state, track_entry, event):
	track_entry = track_entry as SpineTrackEntry
	if track_entry.get_animation().get_anim_name() == "jump":
		self.current_state = last_state

func set_current_state(v):
	last_state = current_state
	current_state = v
