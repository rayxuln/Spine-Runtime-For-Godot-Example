extends Node2D

func _ready():
	$SpineSprite.get_animation_state().set_animation("idle")
	$SpineSprite.get_animation_state().set_empty_animation(2, 0.5)
	$SpineSprite.get_animation_state().set_empty_animation(3, 0.5)
	
	var anims = $SpineSprite.animation_state_data_res.skeleton.get_animations()
	for a in anims:
		a = a as SpineAnimation
		print(a.get_anim_name())

func _process(delta):
	if Input.is_action_just_pressed("click"):
		$SpineSprite.get_animation_state().clear_track(1)
		$SpineSprite.get_animation_state().set_animation("blink", false, 1)

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		var dir = event.position - global_position
		var dir_n = dir.normalized()
		var entry:SpineTrackEntry = null

		var r = 150
		entry = $SpineSprite.get_animation_state().get_current(2)
		if dir.x > r and entry and entry.get_animation().get_anim_name() != "left":
			entry = $SpineSprite.get_animation_state().set_animation("left", false, 2)
			entry.set_alpha(abs(dir_n.x))
		elif dir.x < -r and entry and entry.get_animation().get_anim_name() != "right":
			entry = $SpineSprite.get_animation_state().set_animation("right", false, 2)
			entry.set_alpha(abs(dir_n.x))
		
		entry = $SpineSprite.get_animation_state().get_current(3)
		if dir.y > r and entry and entry.get_animation().get_anim_name() != "down":
			entry = $SpineSprite.get_animation_state().set_animation("down", false, 3)
			entry.set_alpha(abs(dir_n.y))
		elif dir.y < -r and entry and entry.get_animation().get_anim_name() != "up":
			entry = $SpineSprite.get_animation_state().set_animation("up", false, 3)
			entry.set_alpha(abs(dir_n.y))
		
		if abs(dir.x) < r:
			$SpineSprite.get_animation_state().set_empty_animation(2, 0.5)
		if abs(dir.y) < r:
			$SpineSprite.get_animation_state().set_empty_animation(3, 0.5)


func _on_SpineSprite_animation_complete(animation_state, track_entry, event):
	track_entry = track_entry as SpineTrackEntry
#	if track_entry.get_animation().get_anim_name() == "blink":
#		animation_state.clear_track(1)
