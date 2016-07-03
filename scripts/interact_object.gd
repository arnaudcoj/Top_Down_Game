
extends StaticBody2D

onready var interaction_ray = get_node("InteractionRay")
onready var Player = preload("res://scripts/player.gd")

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func interact(player) :
	if player extends Player :
		get_node("SoundPlayer").play("bleep")
		if interaction_ray.is_colliding() && interaction_ray.get_collider() == player:
			controler.textBox.add_paragraph("Interaction")
			controler.textBox.activate()
		else :
			controler.textBox.add_paragraph("Too far")
			controler.textBox.activate()
