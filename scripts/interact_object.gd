
extends Node2D

onready var Player = preload("res://scripts/player.gd")

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func interact(player) :
	if player extends Player :
		get_node("SoundPlayer").play("bleep")
		controler.textBox.add_paragraph("Interaction")
		controler.textBox.activate()
