
extends Control

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func set_hover(boolean):
	if boolean:
		get_node("Back").show()
	else:
		get_node("Back").hide()
		
