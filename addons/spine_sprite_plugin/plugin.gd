tool
extends EditorPlugin

var animate_button:ToolButton
var has_added_button

var current_sprite:SpineSprite

class SpineSpriteAnimate:
	extends Control
	
	var dialog:ConfirmationDialog
	var tree:Tree
	
	
	func _enter_tree() -> void:
		dialog = ConfirmationDialog.new()
		dialog.get_ok().text = 'Generate'
		dialog.add_button('Override', false, 'override')
		dialog.window_title = 'Animations Generator'
		dialog.resizable = true
		dialog.rect_min_size = Vector2(550, 400)
		dialog.dialog_hide_on_ok = false
		add_child(dialog)
		
		var vb = VBoxContainer.new()
		dialog.add_child(vb)
		
		var scroll = ScrollContainer.new()
		vb.add_child(scroll)
		
		tree = Tree.new()
		scroll.add_child(tree)
		scroll.size_flags_horizontal = scroll.SIZE_EXPAND_FILL
		scroll.size_flags_vertical = scroll.SIZE_EXPAND_FILL
		
		tree.columns = 3
		tree.create_item()
		
		tree.set_column_title(0, 'Animation')
		tree.set_column_title(1, 'Loop')
		tree.set_column_title(2, 'Track ID')
		tree.set_column_titles_visible(true)
		tree.hide_root = true
		tree.hide_folding = true
		
		tree.size_flags_horizontal = tree.SIZE_EXPAND_FILL
		tree.size_flags_vertical = tree.SIZE_EXPAND_FILL
		
		add_row('test1')
		add_row('test2')
		add_row('test13')
		
	
	
	func add_row(animation, loop=true, track_id=0):
		var item = tree.create_item()
		item.set_text(0, animation)
		
		item.set_cell_mode(1, TreeItem.CELL_MODE_CHECK)
		item.set_checked(1, loop)
		item.set_editable(1, true)
		
		item.set_cell_mode(2, TreeItem.CELL_MODE_RANGE)
		item.set_range(2, track_id)
		item.set_editable(2, true)
	
	func set_data(node):
		var sprite:SpineSprite = node
		
		clear_tree()
		
		if not sprite.get_animation_state():
			return
		
		if not sprite.get_skeleton():
			return
		
		for a in sprite.get_skeleton().get_data().get_animations():
			add_row(a.get_anim_name())
	
	func get_data():
		var res = {}
		
		var item = tree.get_root().get_children()
		while item:
			var a = {
				'loop': item.is_checked(1),
				'track_id': item.get_range(2)
			}
			res[item.get_text(0)] = a
			item = item.get_next()
		return res
	
	func clear_tree():
		tree.clear()
		tree.create_item()
	
	func _exit_tree() -> void:
		pass

var animate_dialog:SpineSpriteAnimate

func _enter_tree() -> void:
	animate_button = ToolButton.new()
	animate_button.text = 'Animate'
	has_added_button = false
	add_control_to_container(EditorPlugin.CONTAINER_CANVAS_EDITOR_MENU, animate_button)
	
	
	animate_button.connect('pressed', self, '_on_animate_button_pressed')
	
	animate_dialog = SpineSpriteAnimate.new()
	get_editor_interface().get_base_control().add_child(animate_dialog)
	
	animate_dialog.dialog.connect('custom_action', self, '_on_animate_dialog_action')
	animate_dialog.dialog.connect('confirmed', self, '_on_animate_dialog_action', ['confirmed'])
	
	current_sprite = null

func handles(object: Object) -> bool:
	return object is SpineSprite

func make_visible(visible: bool) -> void:
	animate_button.visible = visible
	if not visible:
		current_sprite = null

func _exit_tree() -> void:
	animate_button.queue_free()
	animate_dialog.queue_free()

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

func gen_animations(sprite:SpineSprite, anim:AnimationPlayer, config:Dictionary, minimun_duration=0.017):
	if not sprite or not anim:
		printerr('Null sprite or anim, stop.')
		return
	
	# clear all anims
#	for a in anim.get_animation_list():
#		anim.remove_animation(a)
	
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
		
		var cd = {}
		if config.has(spine_anime.get_anim_name()):
			cd = config[spine_anime.get_anim_name()]
		
		if not cd.has('loop'):
			cd.loop = true
		if not cd.has('track_id'):
			cd.track_id = 0
		
		var ca = gen_current_animation_data(spine_anime.get_anim_name(), cd.track_id, cd.loop)
		
		var animation = Animation.new()
		var track_index = animation.add_track(Animation.TYPE_VALUE)
		animation.length = max(minimun_duration, spine_anime.get_duration())
		animation.track_set_path(track_index, '%s:current_animations' % path_to_sprite)
		animation.track_insert_key(track_index, 0.0, [ca])
		animation.value_track_set_update_mode(track_index, Animation.UPDATE_DISCRETE)

		if anim.has_animation(spine_anime.get_anim_name()):
			anim.remove_animation(spine_anime.get_anim_name())
		anim.add_animation(spine_anime.get_anim_name(), animation)

	
	print("done.")
#----- Signals -----
func _on_animate_button_pressed():
	var select = get_editor_interface().get_selection()
	if select.get_selected_nodes().size() != 1:
		return
	
	var node = select.get_selected_nodes().front()
	if not node is SpineSprite:
		return
	
	current_sprite = node
	
	animate_dialog.set_data(node)
	animate_dialog.dialog.popup_centered()
	
	
func _on_animate_dialog_action(act):
	match act:
		'confirmed':
			if current_sprite == null:
				printerr('The spine sprite is null.')
				return
			
			if current_sprite.get_parent() == null:
				printerr('The spine sprite should have a parent.')
				return
			
			var p = current_sprite.get_parent()
			
			var anim_player = AnimationPlayer.new()
			anim_player.name = 'AnimationPlayer'
			p.add_child(anim_player)
			anim_player.root_node = anim_player.get_path_to(p)
			anim_player.owner = p.owner
			
			var config = animate_dialog.get_data()
			gen_animations(current_sprite, anim_player, config)
			
			print('Generate Done.')
		'override':
			print('o')
	
	
	
	
	








