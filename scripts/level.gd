extends ReferenceFrame

var spawns
var player

export (String) var music
export var loop = true

func _ready():
	player.set_camera_limits(get_rect())

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