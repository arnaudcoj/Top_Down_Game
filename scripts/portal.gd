
extends Node2D

export (String) var spawn_point
export (String) var target_level

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass



func _on_Area2D_body_enter( body ):
	if body.get_name() == "Player":
		if controler.debug : print("zwiup'd to ", target_level)
		controler.root.change_level(target_level, spawn_point)