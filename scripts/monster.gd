
extends Area2D

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
## Other                      ##
################################

var tree_player = AnimationTreePlayer
var sword_hit = preload("res://scripts/sword_hit.gd")

# States
var current_direction = DIRECTION_LEFT

##########################################################################
## Private Functions                                                    ##
##########################################################################

func _ready():
	tree_player = get_node("Sprite/AnimationTreePlayer")
	tree_player.transition_node_set_current("direction", current_direction)
	tree_player.set_active(true)
	
	connect("area_enter", self, "_on_enter")
	
	set_process(true)
	set_fixed_process(true)

func _fixed_process(delta):
	var old_pos = get_parent().get_pos()
	get_parent().set_offset(get_parent().get_offset() + (50 * delta))
	var pos = get_parent().get_pos()
	var travel = pos - old_pos
	var angle = travel.angle_to(Vector2(1,0))
	current_direction = get_direction_from_angle(angle)
	update_animation()
	
func update_animation():
	tree_player.transition_node_set_current("direction", current_direction)
	
func get_direction_from_angle(angle):
	if(angle >= -((3 * PI) / 4) and angle < -(PI / 4)):
		return DIRECTION_UP
	elif(angle >= -(PI / 4) and angle < (PI / 4) ):
		return DIRECTION_RIGHT
	elif(angle >= (PI / 4) and angle < ((3 * PI) / 4)):
		return DIRECTION_DOWN
	return DIRECTION_LEFT
			
func _on_enter(area):
	if (area extends sword_hit):
		controler.soundPlayer.play("bat")
		queue_free()