
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

#Equipments
const NO_OBJECT = 0
const SWORD = 1
const FIREBALL = 2

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
onready var node_interaction_ray = get_node("Actions/InteractionRay")

# States
var max_life = 3
var life = 3
export var vulnerable = true

var direction = DIRECTION_DOWN
var animation = IDLE
var velocity = Vector2(0, 1)

var is_moving = false
var is_attacking = false

var equipment = FIREBALL

var actions
var action_front

var monster = preload("res://scripts/monster.gd")
var sword_hit_lateral = preload("res://scenes/sword_hit_lateral.tscn")
var fireball = preload("res://scenes/fireball.tscn")
var interact_object = preload("res://scripts/interact_object.gd")

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
	# Interaction
	if !controler.is_interacting() :
		# interact with front object
		if node_interaction_ray.is_colliding() :
			var body = node_interaction_ray.get_collider()
			if body extends interact_object :
				body.interact(self)
				is_moving = false
				animation = IDLE
				_process_animation()
	
func on_attack_pressed():
	if(!is_attacking):
		is_attacking = true
		# Create an attack
		if equipment == SWORD :
			sword_hit()
		elif equipment == FIREBALL :
			fire()

func sword_hit():
	action_front.add_child(sword_hit_lateral.instance())

func fire():
	var ball = fireball.instance()
	ball.velocity = velocity
	ball.set_global_transform(action_front.get_global_transform())
	get_parent().add_child(ball)
	is_attacking = false
	
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