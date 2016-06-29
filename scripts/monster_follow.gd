
extends Path2D

var bat
var follow

func _ready():
	bat = get_node("Follow/Bat")
	follow = get_node("Follow")
	#bat.set_pos(follow.get_pos())
	
	#set_process(true)
		
func _process(delta):
	bat.follow_path(follow, delta)