
extends Node2D

export (String) var music

var spawns 
var player

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func spawn_player(spawn_name):
	spawns = get_node("Spawns")
	player = get_node("Objects/Middle/Player")
	var spawn
	
	if spawn_name != null && spawns.has_node(spawn_name) :
		spawn = spawns.get_node(spawn_name) 
	else :
		spawn = spawns.get_child(0)
	
	if spawn != null :
		player.set_pos(spawn.get_pos())