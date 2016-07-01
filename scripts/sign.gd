
extends "res://scripts/interact_object.gd"

export var messages = ["Your message here."]

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func interact(player) :
	if player extends Player :
		get_node("SoundPlayer").play("bleep")
		if interaction_ray.is_colliding() && interaction_ray.get_collider() == player:
			for msg in messages :
				controler.textBox.add_paragraph(msg)
				controler.textBox.activate()
		else :
			controler.textBox.add_paragraph("You can't read this sign from here...")
			controler.textBox.activate()