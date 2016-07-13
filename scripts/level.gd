extends ReferenceFrame

var spawns
var player

export (String) var music
export var loop = true

func _ready():
	player.set_camera_limits(get_rect())
	
	if has_node("Paths") :
		var paths = get_node("Paths")
		var middle = get_node("Objects/Middle")
	
		for path in paths.get_children() :
			if controler.debug :
				print("given the path to " + path.get_name())
			middle.get_node(path.get_name()).pathFollow = path.get_child(0)

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
		if spawn.direction == "up":
			player.direction = player.DIRECTION_UP
		elif spawn.direction == "right":
			player.direction = player.DIRECTION_RIGHT
		elif spawn.direction == "down":
			player.direction = player.DIRECTION_DOWN
		elif spawn.direction == "left":
			player.direction = player.DIRECTION_LEFT
		elif spawn.direction == "none":
			player.direction = player.DIRECTION_NONE

func get_player():
	return get_node("Objects/Middle/Player")