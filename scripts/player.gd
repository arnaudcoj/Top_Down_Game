
extends KinematicBody2D

##########################################################################
## Variables                                                           ##
##########################################################################
###################
## Consts        ##
###################

const DIRECTION_UP = 0
const DIRECTION_DOWN = 1
const DIRECTION_LEFT = 2
const DIRECTION_RIGHT = 3

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

# Animation player node
var node_animation_player = AnimationPlayer
var tree_player = AnimationTreePlayer

onready var node_interaction_ray = get_node("Actions/InteractionRay")

# States
var is_moving = false
var animation = IDLE
var direction = DIRECTION_DOWN
var velocity = Vector2(0, 0)

var is_attacking = false

var actions
var action_front

var sword_hit_lateral = preload("res://scenes/sword_hit_lateral.tscn")
var monster = preload("res://scripts/monster.gd")

##########################################################################
## Private Functions                                                   ##
##########################################################################
func _ready():
	set_process(true)
	set_fixed_process(true)
	set_process_input(true)
	
	tree_player = get_node("Sprite/AnimationTreePlayer")
	tree_player.transition_node_set_current("animation", animation)
	tree_player.transition_node_set_current("idle_direction", direction)
	tree_player.timescale_node_set_scale("walk_scale", walk_animation_scale)	
	tree_player.set_active(true)
	
	actions = get_node("Actions")
	action_front = actions.get_node("ActionFront")
	
	get_node("HitBox").connect("area_enter", self, "_on_enter")
	
func _input(event):	
	#var is_attack_pressed = event.is_action_pressed("attack") && !event.is_echo()
	var is_interact_pressed = event.is_action_pressed("interact") && !event.is_echo()
	var is_attack_pressed = false
	
	# Interaction
	if(is_interact_pressed) :
		if !controler.is_interacting :
			# interact with front object
			if node_interaction_ray.is_colliding() :
				var body = node_interaction_ray.get_collider()
				if body.is_in_group("can_interact") :
					body.interact(self)
		elif controler.textBox.active :
			controler.textBox.next()

	if(!is_attacking  && is_attack_pressed):
		if controler.textBox.active :
			controler.textBox.deactivate()
		is_attacking = true
		# Create an attack
		action_front.add_child(sword_hit_lateral.instance())
	
	
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
func _process(delta):
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
	# provisoire, soon l'interaction se desactivera si on s'éloigne
	if controler.is_interacting :
		is_moving = false
		animation = IDLE
		return
		
	# Stores the directions pressed in this frame.
	var directions_pressed = 0

	# Fetches the current key states in this frame.
	var is_up_pressed = int(Input.is_action_pressed("move_up"))
	var is_left_pressed = int(Input.is_action_pressed("move_left"))
	var is_right_pressed = int(Input.is_action_pressed("move_right"))
	var is_down_pressed = int(Input.is_action_pressed("move_down"))
#	var is_attack_pressed = Input.is_action_pressed("attack")
#	var is_interact_pressed = Input.is_action_pressed("interact")
	
	var left_right_direction = is_right_pressed ^ is_left_pressed
	if (left_right_direction == 1):
		directions_pressed += left_right_direction
		
	var up_down_direction = is_up_pressed ^ is_down_pressed
	if (up_down_direction == 1):
		directions_pressed += up_down_direction
	
	if (directions_pressed > 0 && !is_attacking):
		
		velocity = Vector2(0, 0)

		if (left_right_direction):
			is_moving = true
			animation = WALK
			
			if (is_left_pressed):
				velocity.x -= 1
				set_direction(DIRECTION_LEFT)
			else:
				velocity.x += 1
				set_direction(DIRECTION_RIGHT)

		if (up_down_direction):
			is_moving = true
			animation = WALK

			if (is_up_pressed):
				velocity.y -= 1
				set_direction(DIRECTION_UP)
			else:
				velocity.y += 1
				set_direction(DIRECTION_DOWN)
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
	
func _on_enter(area):
	if (area extends monster):
		die()
		
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