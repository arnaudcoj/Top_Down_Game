
extends "res://scripts/attack.gd"

var player = preload("res://scripts/player.gd")

export var motion_speed = 80
var velocity = Vector2(0, 0)

func _ready():
	connect("body_enter", self, "_on_enter_body")
	get_node("Timer").connect("timeout", self, "_on_timeout")
	set_fixed_process(true)
	
## _fixed_process - Main physics logic
func _fixed_process(delta):
	# Apply motion speed and delta.
	var motion = velocity * motion_speed * delta
	set_pos(get_pos() + motion)
	
func _on_enter_body(body):
	if !(body extends player) :
		destroy()
		
func destroy():
	set_fixed_process(false)
	get_node("CollisionBox").queue_free()
	get_node("Particles").queue_free()
	get_node("Sprite").queue_free()
	get_node("DestructionParticles").set_emitting(true)
	get_node("Timer").start()
		
func _on_timeout():
	queue_free()