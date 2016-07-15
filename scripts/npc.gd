extends "res://scripts/interact_object.gd"

#Directions
const DIRECTION_UP = 0
const DIRECTION_DOWN = 1
const DIRECTION_LEFT = 2
const DIRECTION_RIGHT = 3

export var direction = DIRECTION_DOWN

export (String) var name = null
export var dialog = ["Your dialog here."]
export var final_dialog = "The final dialog here"

var dialog_finished = false

onready var animation_player = get_node("Sprite/AnimationPlayer")
onready var tree_player = get_node("Sprite/AnimationTreePlayer")

var pathFollow = null

func _ready():
		set_fixed_process(true)

func _fixed_process(delta):
	if pathFollow && !controler.is_interacting() :
		#move the monster and retrieve the old and new pos
		var old_pos = pathFollow.get_pos()
		pathFollow.set_offset(pathFollow.get_offset() + (50 * delta))		
		var pos = pathFollow.get_pos()
		
		#compute the angle with the old and new pos
		var travel = pos - old_pos
		
		if !test_move(travel):
			move(travel)
			var angle = travel.angle_to(Vector2(1,0))
			direction = get_direction_from_angle(angle)
			update_animation()
		else:
			pathFollow.set_offset(pathFollow.get_offset() - (50 * delta))
	
func update_animation():
	tree_player.transition_node_set_current("direction", direction)
	

func interact(player) :
	if player extends Player :
		get_node("SoundPlayer").play("bleep")
		
		if player.direction == DIRECTION_UP:
			animation_player.play("Down")
		elif player.direction == DIRECTION_DOWN:
			animation_player.play("Up")
		elif player.direction == DIRECTION_LEFT:
			animation_player.play("Right")
		elif player.direction == DIRECTION_RIGHT:
			animation_player.play("Left")
			
		if dialog_finished :
			controler.textBox.add_paragraph(final_dialog, name)
			controler.textBox.activate()
		else :
			for msg in dialog :
				controler.textBox.add_paragraph(msg, name)
			controler.textBox.activate()
			dialog_finished = true

	
func get_direction_from_angle(angle):
	if(angle >= -((3 * PI) / 4) and angle < -(PI / 4)):
		return DIRECTION_UP
	elif(angle >= -(PI / 4) and angle < (PI / 4) ):
		return DIRECTION_RIGHT
	elif(angle >= (PI / 4) and angle < ((3 * PI) / 4)):
		return DIRECTION_DOWN
	return DIRECTION_LEFT