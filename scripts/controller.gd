
extends Node

export var debug = 1

var root

func _ready():
	if debug :
		print("Controler init")
	root = get_tree().get_root().get_node("Root")
	print("found root: " + root.get_name())