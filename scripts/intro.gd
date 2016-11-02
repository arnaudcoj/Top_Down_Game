
extends Node2D

var music = "level1"
var loop = true

func _ready():
	set_process_input(true)
	
func _input(event):
	if event.is_action_released("interact"):
		controler.root.change_level("level2", "Spawn")

func spawn_player(spawn_name):
	pass
	
func get_player():
	return null