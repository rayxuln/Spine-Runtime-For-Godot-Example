extends Control


onready var tree = $ConfirmationDialog/VBoxContainer/ScrollContainer/Tree

func _ready() -> void:
	$ConfirmationDialog.popup_centered()
	
	tree.set_column_title(0, 'Animation')
	tree.set_column_titles_visible(true)
	tree.set_column_title(1, 'Loop')
	tree.set_column_title(2, 'Track ID')
	
	var root = tree.create_item()
	
	var item = tree.create_item()
	item.set_text(0, 'idle')
	item.set_cell_mode(1, TreeItem.CELL_MODE_CHECK)
	item.set_checked(1, false)
	item.set_editable(1, true)
	item.set_text(2, '0')
	item.set_cell_mode(2, TreeItem.CELL_MODE_RANGE)
	item.set_editable(2, true)
	
	item = tree.create_item()
	item.set_text(0, 'aim')
	item.set_cell_mode(1, TreeItem.CELL_MODE_CHECK)
	item.set_checked(1, true)
	item.set_editable(1, true)
	item.set_text(2, '1')
	item.set_cell_mode(2, TreeItem.CELL_MODE_RANGE)
	item.set_editable(2, true)
	
	item = tree.create_item()
	item.set_text(0, 'shoot')
	item.set_cell_mode(1, TreeItem.CELL_MODE_CHECK)
	item.set_checked(1, false)
	item.set_editable(1, true)
	item.set_text(2, '2')
	item.set_cell_mode(2, TreeItem.CELL_MODE_RANGE)
	item.set_editable(2, true)
	
	item = tree.create_item()
	item.set_text(0, 'idle')
	item.set_cell_mode(1, TreeItem.CELL_MODE_CHECK)
	item.set_checked(1, false)
	item.set_editable(1, true)
	item.set_text(2, '0')
	item.set_cell_mode(2, TreeItem.CELL_MODE_RANGE)
	item.set_editable(2, true)
	
	
