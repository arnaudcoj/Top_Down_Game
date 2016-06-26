
extends Node2D

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	change_level("level1", "Spawn")
	
func change_level(level, spawn):
	if level == null :
		return
	var map = get_node("Map")
	
	for child in map.get_children() :
		child.queue_free()
	
	var level_scene = load("res://scenes/levels/" + level + ".tscn")
	var level_node = level_scene.instance()
	
	level_node.spawn_player(spawn)
	map.add_child(level_node)