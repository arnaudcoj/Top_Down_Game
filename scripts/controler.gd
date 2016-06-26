
extends Node

var debug = 0

var root

func _ready():
	if debug : print("Controler init")
	root = get_tree().get_root().get_node("Root")
	if debug : print("found root: " + root.get_name())