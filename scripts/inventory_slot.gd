
extends Control

var item = preload("res://scripts/item.gd")

onready var current_item = get_node("Item")
var empty = true


func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func set_item(item_instance):
	if item_instance extends item :
		current_item.replace_by(item_instance)
		print(current_item.get_name())
		empty = false

func set_hover(boolean):
	if boolean:
		get_node("Back").show()
	else:
		get_node("Back").hide()
		
func is_empty():
	return empty