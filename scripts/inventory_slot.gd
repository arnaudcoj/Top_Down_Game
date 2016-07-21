
extends Control

var item = preload("res://scripts/item.gd")

onready var current_item = get_node("Item")
onready var hover = get_node("Hover")
onready var select = get_node("Select")


func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func set_item(item_instance):
	if item_instance && item_instance extends item :
		remove_item()
		current_item.add_child(item_instance)

func remove_item():
	for child in current_item.get_children():
		current_item.remove_child(child)

func get_item():
	if current_item.get_child_count() :
		return current_item.get_child(0)
	return null

func set_hover(boolean):
	if boolean:
		hover.show()
	else:
		hover.hide()

func set_select(boolean):
	if boolean:
		select.show()
	else:
		select.hide()

func is_selected():
	return !select.is_hidden()
		
func is_empty():
	return current_item.get_child_count() == 0