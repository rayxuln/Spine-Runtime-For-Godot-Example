extends Node2D

var anim_player: AnimationPlayer

onready var spine_sprite: SpineSprite = $SpineSprite



func _ready() -> void:
	#test1()
	#test2()
	#test3()
	#test4()
	test5()
	pass
		
func test1() -> void:
	# expect to see brown hair. see brown hair
	spine_sprite.get_skeleton().set_skin_by_name("default")
	spine_sprite.get_skeleton().set_skin_by_name("hair/brown")
	spine_sprite.get_skeleton().set_to_setup_pose()
	

func test2() -> void:
	# expect to see brown hair. see brown hair
	spine_sprite.get_skeleton().set_skin_by_name("hair/brown")
	spine_sprite.get_skeleton().set_to_setup_pose()

func test3() -> void:
	# expect to see brown hair. see brown hair
	var custom_skin: SpineSkin = SpineSkin.new().init("my_custom_hair")
	var hair = spine_sprite.get_skeleton().get_data().find_skin("hair/brown")
	custom_skin.add_skin(hair)
	spine_sprite.get_skeleton().set_skin(custom_skin)
	spine_sprite.get_skeleton().set_to_setup_pose()

func test4() -> void:
	# expect to see brown hair. see brown hair
	# need to set a skin first otherwise get_skin() returns null
	spine_sprite.get_skeleton().set_skin_by_name("default")
	var custom_skin: SpineSkin = spine_sprite.get_skeleton().get_skin()
	var hair: SpineSkin = spine_sprite.get_skeleton().get_data().find_skin("hair/brown")
	custom_skin.add_skin(hair)
	spine_sprite.get_skeleton().set_skin(custom_skin)
	spine_sprite.get_skeleton().set_to_setup_pose()

func test5() -> void:
	var hair: SpineSkin = spine_sprite.get_skeleton().get_data().find_skin("hair/brown")
	var at = hair.get_attachments()
	while at.has_next():
		var at1 = at.next()
		print(at1.get_attachment().get_attachment_name())
	spine_sprite.get_skeleton().set_skin(hair)
