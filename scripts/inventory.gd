
extends Panel

var slot = preload("res://scenes/inventory_slot.tscn")

export var nb_rows = 3
export var nb_slots_by_row = 4

var active = false
var cursor = -1

func _ready():
	init()
	deactivate()

func init():
	for i in range(nb_rows):
		for j in range(nb_slots_by_row):
			var inst = slot.instance() 
			inst.set_pos(Vector2(20*j, 20*i))
			add_child(inst)
	move_cursor(0)

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
	
func move_cursor(child_nb):
	if cursor != -1 : get_child(cursor).set_hover(false)
	cursor = child_nb
	get_child(cursor).set_hover(true)
	
	
func on_move_up_pressed():
	move_cursor(max(0, cursor - nb_slots_by_row))
	
func on_move_down_pressed():
	move_cursor(min(nb_rows * nb_slots_by_row -1, cursor + nb_slots_by_row))
	
func on_move_left_pressed():
	move_cursor(max(0, cursor - 1))
	
func on_move_right_pressed():
	move_cursor(min(nb_rows * nb_slots_by_row -1, cursor + 1))


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