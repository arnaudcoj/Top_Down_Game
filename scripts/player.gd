######################################################################################
# Example player controller                                                          #
######################################################################################
extends KinematicBody2D


##########################################################################
## Variables.                                                           ##
##########################################################################
###################
## Consts.       ##
###################

# The directions are used to store what direction the player is facing at.
# These are used to determine what animation to play when using an attack
# or other skill that requires certain animations.
const DIRECTION_NONE = 0
const DIRECTION_UP = 1
const DIRECTION_RIGHT = 2
const DIRECTION_DOWN = 3
const DIRECTION_LEFT = 4

################################
## Exported Editor variables. ##
################################
export(float) var motion_speed = 60		# The motion speed the character walks with.


################################
## Other.                     ##
################################
# Animation player node.
var node_animation_player = AnimationPlayer

onready var node_interaction_ray = get_node("Actions/InteractionRay")

# States.
var is_moving = false				# Stores whether the player is moving or not.
									# It can also be determined by velocity, but for simplicity we won't.
var direction = DIRECTION_DOWN		# Stores what direciton the player is facing at.
var velocity = Vector2(0, 0)		# Velocity the player is moving at.
var is_attacking = false
var is_interacting = false

var actions
var action_front

var sword_hit_lateral = preload("res://scenes/sword_hit_lateral.tscn")

##########################################################################
## Private Functions.                                                   ##
##########################################################################
func _ready():
	# Enable fixed, and, -processing.
	set_process(true)
	set_fixed_process(true)
	
	# Fetch nodes.
	node_animation_player = get_node("Sprite/AnimationPlayer")
	node_animation_player.connect("finished", self, "_animation_finished")
	
	actions = get_node("Actions")
	action_front = actions.get_node("ActionFront")
	
## _fixed_process - handle the fixed processing of the player controller. (Main physics logic)
func _fixed_process(delta):
	# Apply motion speed and delta.
	var motion = velocity.normalized() * motion_speed * delta

	# If we are in motion, process it.
	if (is_moving):
		# In case of a collision, calculate sliding motion.
		if (is_colliding()):
			# Fetch normal.
			var n = get_collision_normal()
			#get_groups().
			# Calculate slide motion.
			motion = n.slide(motion)
			#motion = motion.normalized() # I believe it is already normalized so doing this twice would be ridiculous.
			
			# Consume.
			move(motion)
		else:
			# Consume motion.
			move(motion)
	
## _process - handle the processing of the player controller. (Main game logic)
func _process(delta):
	# Process the input.
	_process_input()
	
	# Process the animation.
	_process_animation()

## _animation_finished - 
func _animation_finished():
	is_attacking = false
		
## _process_animation - 
func _process_animation():
	if (is_attacking):
		if (direction == DIRECTION_LEFT):
			if (node_animation_player.get_current_animation() != "sword_left"):
				node_animation_player.set_current_animation("sword_left")
		if (direction == DIRECTION_RIGHT):
			if (node_animation_player.get_current_animation() != "sword_right"):
				node_animation_player.set_current_animation("sword_right")
		if (direction == DIRECTION_UP):
			if (node_animation_player.get_current_animation() != "sword_up"):
				node_animation_player.set_current_animation("sword_up")
		if (direction == DIRECTION_DOWN):
			if (node_animation_player.get_current_animation() != "sword_down"):
				node_animation_player.set_current_animation("sword_down")
		
		if (!node_animation_player.is_playing()):
			node_animation_player.play()
			
	elif (is_moving):
		# Display animation depending on the direction.
		if (direction == DIRECTION_LEFT):
			if (node_animation_player.get_current_animation() != "move_left"):
				node_animation_player.set_current_animation("move_left")
		if (direction == DIRECTION_RIGHT):
			if (node_animation_player.get_current_animation() != "move_right"):
				node_animation_player.set_current_animation("move_right")
		if (direction == DIRECTION_UP):
			if (node_animation_player.get_current_animation() != "move_up"):
				node_animation_player.set_current_animation("move_up")
		if (direction == DIRECTION_DOWN):
			if (node_animation_player.get_current_animation() != "move_down"):
				node_animation_player.set_current_animation("move_down")
		if (!node_animation_player.is_playing()):
			node_animation_player.play()
			
	else:
		# If preferred, one can actually check the direction we're
		# heading forward to, and start playing an idle animation.
		#
		# Depending on the game, this may or may not be preferred..
		if (direction == DIRECTION_LEFT):
			if (node_animation_player.get_current_animation() != "idle_left"):
				node_animation_player.set_current_animation("idle_left")
		if (direction == DIRECTION_RIGHT):
			if (node_animation_player.get_current_animation() != "idle_right"):
				node_animation_player.set_current_animation("idle_right")
		if (direction == DIRECTION_UP):
			if (node_animation_player.get_current_animation() != "idle_up"):
				node_animation_player.set_current_animation("idle_up")
		if (direction == DIRECTION_DOWN):
			if (node_animation_player.get_current_animation() != "idle_down"):
				node_animation_player.set_current_animation("idle_down")
			
		if (!node_animation_player.is_playing()):
			node_animation_player.play()

## _process_input - handle the player input appropriately.
func _process_input():
	# Stores the directions pressed in this frame.
	var directions_pressed = 0

	# Fetches the current key states in this frame.
	var is_up_pressed = int(Input.is_action_pressed("move_up"))
	var is_left_pressed = int(Input.is_action_pressed("move_left"))
	var is_right_pressed = int(Input.is_action_pressed("move_right"))
	var is_down_pressed = int(Input.is_action_pressed("move_down"))
	var is_attack_pressed = Input.is_action_pressed("attack")
	var is_interact_pressed = Input.is_action_pressed("interact")
	
	if(!is_attacking && is_attack_pressed):
		is_attacking = true
		# Create attack
		action_front.add_child(sword_hit_lateral.instance())
	
	if(!is_interacting && is_interact_pressed):
#		is_interacting = true
		if node_interaction_ray.is_colliding() :
			var body = node_interaction_ray.get_collider()
			if body.is_in_group("can_interact") :
				body.interact(self)

	# Determine whether left/right are pressed, if so, add the bits to directions_pressed.
	var left_right_direction = is_right_pressed ^ is_left_pressed
	if (left_right_direction == 1):
		directions_pressed += left_right_direction
		
	# Determine whether up/down are pressed, if so, add the bits to directions_pressed.
	var up_down_direction = is_up_pressed ^ is_down_pressed
	if (up_down_direction == 1):
		directions_pressed += up_down_direction
	
	# Identify whether movement keys have been pressed.
	if (directions_pressed > 0 && !is_attacking):
		# We now start checking for directions to execute logic for.
		# We give left and right a priority, which means that while moving
		# left or right, the movement will be intercepted and replaced with
		# the up/down key in case it was pressed. Once the up/down key is 
		# released(unpressed), it will continue moving left/right.
		#
		# If one wishes to reverse the priorities, it is as simple as shifting
		# the if statements around.
		
		velocity = Vector2(0, 0)
		
		# Check for left_right_direction movement.
		if (left_right_direction):
			# Setup is_moving state.
			is_moving = true
			
			# Determine which direction to execute.
			if (is_left_pressed):
				# Setup velocity.
				velocity.x -= 1
				
				# Setup direction state.
				set_direction(DIRECTION_LEFT)
			else:
				# Setup velocity.
				velocity.x += 1
				
				# Setup direction state.
				set_direction(DIRECTION_RIGHT)
		
		# Check for up_down_direction movement.
		if (up_down_direction):
			is_moving = true
			
			# Determine which direction to execute.
			if (is_up_pressed):
				# Setup velocity.
				velocity.y -= 1
				
				# Setup direction state.
				set_direction(DIRECTION_UP)
			else:
				# Setup velocity.
				velocity.y += 1
				
				# Setup direction state.
				set_direction(DIRECTION_DOWN)
	else:
		# Stop movement, nothing is pressed.
		is_moving = false
		
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
