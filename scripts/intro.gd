
extends Node2D

var music = "Peace Returns"
var loop = true

func _ready():
	set_process_input(true)
	
func _input(event):
	if event.is_action_released("equipment_B") or event.is_action_released("equipment_X") or event.is_action_released("equipment_Y") :
		controler.root.change_level("level2", "Spawn")

func spawn_player(spawn_name):
	pass
	
func get_player():
	return null