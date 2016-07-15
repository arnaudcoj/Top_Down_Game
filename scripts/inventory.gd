
extends Panel

var active = false

func _ready():
	deactivate()

# Activates, prompts the inventory and lock the character if contains paragraphs
func activate():
	if controler.debug : print("[inventory] activate")
	active = true
	show()

# Deactivates the inventory, ie unlock the character, clears the inventory content and hides it
func deactivate():
	if controler.debug : print("[inventory] deactivate")
	active = false
	hide()

func on_interact_pressed():
	pass
	
func on_attack_pressed():
	if active :
		deactivate()
		
func on_inventory_pressed():
	if active :
		deactivate()
	else :
		activate()