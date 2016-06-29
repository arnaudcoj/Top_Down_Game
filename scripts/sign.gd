
extends StaticBody2D

onready var interaction_ray = get_node("InteractionRay")
onready var Player = preload("res://scripts/player.gd")

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func interact(body) :
	if interaction_ray.is_colliding() && interaction_ray.get_collider() == body && body extends Player:
		print("yay")
	else :
		print("mets teu dvan oh carvaille")