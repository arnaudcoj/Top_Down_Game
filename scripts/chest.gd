
extends "res://scripts/interact_object.gd"

var fire_staff = preload("res://scenes/fire_staff.tscn")
var blue_fire_staff = preload("res://scenes/blue_fire_staff.tscn")
var opened = false

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func interact(player) :
	if player extends Player :
		if not opened :
			get_node("SoundPlayer").play("bleep")
			controler.textBox.add_paragraph("You found a fire staff inside the burning log.")
			controler.inventory.add_item(fire_staff.instance())
			controler.textBox.activate()
			opened = true
		else :
			get_node("SoundPlayer").play("bleep")
			controler.textBox.add_paragraph("This log is empty...")
			controler.textBox.add_paragraph("Wait... You found a blue fire staff inside the burning log !")
			controler.inventory.add_item(blue_fire_staff.instance())
			controler.textBox.activate()
