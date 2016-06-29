
extends KinematicBody2D

##########################################################################
## Variables                                                            ##
##########################################################################
###################
## Consts        ##
###################

const DIRECTION_UP = 0
const DIRECTION_DOWN = 1
const DIRECTION_LEFT = 2
const DIRECTION_RIGHT = 3

################################
## Exported Editor variables  ##
################################

export(float) var walk_speed = 120.0
export(float) var walk_animation_scale = 1.2
export(float) var movement_threshold = 0.8

################################
## Other                      ##
################################

var tree_player = AnimationTreePlayer

# States
var current_direction = DIRECTION_LEFT

##########################################################################
## Private Functions                                                    ##
##########################################################################

func _ready():
	tree_player = get_node("Sprite/AnimationTreePlayer")
	tree_player.transition_node_set_current("direction", current_direction)
	tree_player.set_active(true)
	set_process(true)

func update_animation():
	tree_player.transition_node_set_current("direction", current_direction)

func update_travel(travel):
	if(travel.length() > 0):
		var angle = travel.angle_to(Vector2(1,0))
		current_direction = get_direction_from_angle(angle)
	update_animation()

func get_direction_from_angle(angle):
	if(angle >= -((3 * PI) / 4) and angle < -(PI / 4)):
		return DIRECTION_UP
	elif(angle >= -(PI / 4) and angle < (PI / 4) ):
		return DIRECTION_RIGHT
	elif(angle >= (PI / 4) and angle < ((3 * PI) / 4)):
		return DIRECTION_DOWN
	return DIRECTION_LEFT

func path_follow_path(path_follow, delta):
	if(get_tree().is_paused()):
		return
		
	var old_offset = path_follow.get_offset()
	var standard_travel = walk_speed * delta

	path_follow.set_offset(path_follow.get_offset() + (walk_speed * delta))
	move_to(path_follow.get_pos())

	var travel = get_travel()
	if(travel.length() < movement_threshold * standard_travel):
		path_follow.set_offset(old_offset)
		set_pos(path_follow.get_pos())
		travel = Vector2(0,0)

	update_travel(travel)