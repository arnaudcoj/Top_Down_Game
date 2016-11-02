
extends KinematicBody2D

##########################################################################
## Variables                                                           ##
##########################################################################
###################
## Consts        ##
###################

#Directions
const DIRECTION_UP = 0
const DIRECTION_DOWN = 1
const DIRECTION_LEFT = 2
const DIRECTION_RIGHT = 3

#Animations
const IDLE = 0
const WALK = 1

################################
## Exported Editor variables  ##
################################

export(float) var motion_speed = 60
export(float) var walk_animation_scale = 2

################################
## Other                      ##
################################

onready var tree_player = get_node("AnimationTreePlayer")
onready var effects = get_node("Effects")
onready var interaction_area = get_node("Actions/InteractionArea")

# States
var max_life = 3
var life = 3
export var vulnerable = true

var direction = DIRECTION_DOWN
var animation = IDLE
var velocity = Vector2(0, 1)

var is_moving = false
var is_attacking = false

var actions
var action_front

var monster = preload("res://scripts/monster.gd")
var sword_hit_lateral = preload("res://scenes/sword_hit_lateral.tscn")
var interact_object = preload("res://scripts/interact_object.gd")

# Equipment
onready var equipment_slots = get_node("Equipment")
onready var x_slot = equipment_slots.get_node("X_Slot")
onready var c_slot = equipment_slots.get_node("C_Slot")
onready var v_slot = equipment_slots.get_node("V_Slot")

##########################################################################
## Private Functions                                                   ##
##########################################################################
func _ready():
	set_fixed_process(true)
	
	tree_player.transition_node_set_current("animation", animation)
	tree_player.transition_node_set_current("idle_direction", direction)
	tree_player.timescale_node_set_scale("walk_scale", walk_animation_scale)	
	tree_player.set_active(true)
	
	actions = get_node("Actions")
	action_front = actions.get_node("ActionFront")
	
func on_interact_pressed():
	for body in interaction_area.get_overlapping_bodies() :
		if body extends interact_object :
			body.interact(self)
	
func on_equipment_X_pressed():
	if(!is_attacking):
		# Create an attack
		
		# to be improved. For now we just check if there is an item in the b slot
		if x_slot.get_child_count() >= 1:
			is_attacking = true
			fire(x_slot.get_child(0).fireball)
			
func on_equipment_C_pressed():
	if(!is_attacking):
		# Create an attack
		
		# to be improved. For now we just check if there is an item in the b slot
		if c_slot.get_child_count() >= 1:
			is_attacking = true
			fire(c_slot.get_child(0).fireball)
			
func on_equipment_V_pressed():
	if(!is_attacking):
		# Create an attack
		
		# to be improved. For now we just check if there is an item in the b slot
		if v_slot.get_child_count() >= 1 :
			is_attacking = true
			fire(v_slot.get_child(0).fireball)

func sword_hit():
	action_front.add_child(sword_hit_lateral.instance())

func fire(fireball): 
	var ball = fireball.instance()
	var ball_velocity = Vector2(0,0)
	if direction == DIRECTION_UP :
		ball_velocity.y -= 1
	elif direction == DIRECTION_DOWN :
		ball_velocity.y += 1
	elif direction == DIRECTION_LEFT :
		ball_velocity.x -= 1
	elif direction == DIRECTION_RIGHT :
		ball_velocity.x += 1
	ball.velocity = ball_velocity
	ball.set_global_transform(action_front.get_global_transform())
	get_parent().add_child(ball)
	is_attacking = false
	
func update_equipment():

	for slot in equipment_slots.get_children() :
		for item in slot.get_children() :
			slot.remove_child(item)
			
	if !controler.inventory.x_slot.is_empty() :
		x_slot.add_child(controler.inventory.x_slot.get_item().duplicate())
	if !controler.inventory.c_slot.is_empty() :
		c_slot.add_child(controler.inventory.c_slot.get_item().duplicate())
	if !controler.inventory.v_slot.is_empty() :
		v_slot.add_child(controler.inventory.v_slot.get_item().duplicate())

## _fixed_process - Main physics logic
func _fixed_process(delta):
	# Apply motion speed and delta.
	var motion = velocity.normalized() * motion_speed * delta

	# If we are in motion, process it.
	if (is_moving):
		# In case of a collision, calculate sliding motion.
		if (is_colliding()):
			var n = get_collision_normal()
			motion = n.slide(motion)
			move(motion)
		else:
			move(motion)
	
## _process - Main game logic
func process_directions():
	# Process the input.
	_process_input()
	
	# Process the animation.
	_process_animation()

## _animation_finished
func _animation_finished():
	is_attacking = false
		
## _process_animation
func _process_animation():
	tree_player.transition_node_set_current("animation", animation)
	if (animation == IDLE):
		tree_player.transition_node_set_current("idle_direction", direction)
	else:
		tree_player.transition_node_set_current("walk_direction", direction)

## _process_input - handle the player input appropriately.
func _process_input():
	if controler.is_interacting():
		is_moving = false
		animation = IDLE
		_process_animation()
		return
	
	# Stores the directions pressed in this frame.
	var directions_pressed = 0

	# Fetches the current key states in this frame.
	var is_up_pressed = int(Input.is_action_pressed("move_up"))
	var is_left_pressed = int(Input.is_action_pressed("move_left"))
	var is_right_pressed = int(Input.is_action_pressed("move_right"))
	var is_down_pressed = int(Input.is_action_pressed("move_down"))
	
	var left_right_direction = is_right_pressed ^ is_left_pressed
	if (left_right_direction == 1):
		directions_pressed += left_right_direction
		
	var up_down_direction = is_up_pressed ^ is_down_pressed
	if (up_down_direction == 1):
		directions_pressed += up_down_direction
	
	if (directions_pressed > 0 && !is_attacking):
		var new_direction
		
		velocity = Vector2(0, 0)

		if (left_right_direction):
			is_moving = true
			animation = WALK
			
			if (is_left_pressed):
				new_direction = DIRECTION_LEFT
				velocity.x -= 1
			else:
				new_direction = DIRECTION_RIGHT
				velocity.x += 1

		if (up_down_direction):
			is_moving = true
			animation = WALK

			if (is_up_pressed):
				if direction != new_direction :
					new_direction = DIRECTION_UP
				velocity.y -= 1
			else:
				if direction != new_direction :
					new_direction = DIRECTION_DOWN
				velocity.y += 1
		
		set_direction(new_direction)
	else:
		is_moving = false
		animation = IDLE
		
func set_direction(new_direction):
	var rot = 0
	if new_direction == DIRECTION_UP :
		rot = 180
	if new_direction == DIRECTION_RIGHT :
		rot = 90
	if new_direction == DIRECTION_DOWN :
		rot = 0
	if new_direction == DIRECTION_LEFT :
		rot = -90
	
	actions.set_rotd(rot)
	
	direction = new_direction
	
func heal(value):
	life += value
	if life > max_life:
		life = max_life
	
func lose_life(damages):
	if vulnerable :
		life -= damages
		if life < 1 :
			die()
		else:
			vulnerable = false
			effects.play("hurt")
		
func die():
	controler.root.change_level("game_over", "Spawn")

func set_camera_limits(rect):
	var camera = get_node("Camera2D")
	camera.set_limit(MARGIN_LEFT, rect.pos.x)
	camera.set_limit(MARGIN_TOP, rect.pos.y)
	camera.set_limit(MARGIN_RIGHT, rect.pos.x + rect.size.x)
	camera.set_limit(MARGIN_BOTTOM, rect.pos.y + rect.size.y)
	if controler.debug : 
		print("MARGIN_LEFT", rect.pos.x)
		print("MARGIN_TOP", rect.pos.y)
		print("MARGIN_RIGHT", rect.pos.x + rect.size.x)
		print("MARGIN_BOTTOM", rect.pos.y + rect.size.y)