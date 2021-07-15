tool
extends Node2D


export(NodePath) var sprite_path
export(NodePath) var anim_path

export(float) var minimun_duration = 0.017

var key_j_pressed = false

func _process(delta: float) -> void:
	if Engine.editor_hint:
		if Input.is_key_pressed(KEY_J):
			if key_j_pressed == false:
				gen_animations(get_node_or_null(sprite_path), get_node_or_null(anim_path))
			key_j_pressed = true
		else:
			key_j_pressed = false
			

#----- Methods -----
func gen_current_animation_data(animation, track_id=0, loop=true, clear=false, empty=false, empty_duration=0.3, delay=0):
	return {
		"animation": animation,
		"clear": clear,
		"empty": empty,
		"empty_animation_duration": empty_duration,
		"loop": loop,
		"track_id": track_id,
		"delay": delay,
	}

func gen_animations(sprite:SpineSprite, anim:AnimationPlayer):
	if not sprite or not anim:
		printerr('Null sprite or anim, stop.')
		return
	
	# clear all anims
	for a in anim.get_animation_list():
		anim.remove_animation(a)
	
	if not sprite.get_animation_state() or not sprite.get_skeleton():
		printerr('The sprite is not ready.')
		return
	
	if anim.get_node_or_null(anim.root_node) == null:
		printerr('The root node of animation player is not set.')
		return
	
	var path_to_sprite = anim.get_node(anim.root_node).get_path_to(sprite)
	print('path: %s' % [path_to_sprite])
	
	for sa in sprite.get_skeleton().get_data().get_animations():
		var spine_anime:SpineAnimation = sa
		var ca = gen_current_animation_data(spine_anime.get_anim_name())
		
		var animation = Animation.new()
		var track_index = animation.add_track(Animation.TYPE_VALUE)
		animation.length = max(minimun_duration, spine_anime.get_duration())
		animation.track_set_path(track_index, '%s:current_animations' % path_to_sprite)
		animation.track_insert_key(track_index, 0.0, [ca])
		animation.value_track_set_update_mode(track_index, Animation.UPDATE_DISCRETE)

		anim.add_animation(spine_anime.get_anim_name(), animation)

	
	print("done.")
