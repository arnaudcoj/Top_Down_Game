extends "res://scripts/interact_object.gd"

export var dialog = ["Your dialog here."]
export var final_dialog = "The final dialog here"

var dialog_finished = false

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func interact(player) :
	if player extends Player :
		get_node("SoundPlayer").play("bleep")
		if dialog_finished :
			controler.textBox.add_paragraph(final_dialog)
			controler.textBox.activate()
		else :
			for msg in dialog :
				controler.textBox.add_paragraph(msg)
			controler.textBox.activate()
			dialog_finished = true
