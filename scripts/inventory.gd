
extends Panel

var slot = preload("res://scenes/inventory_slot.tscn")
var fire_staff = preload("res://scenes/fire_staff.tscn")
var blue_fire_staff = preload("res://scenes/blue_fire_staff.tscn")
var selected_slot = null

onready var items = get_node("Items")
onready var equipment = get_node("Equipment")
onready var x_slot = equipment.get_node("X_Slot")
onready var c_slot = equipment.get_node("C_Slot")
onready var v_slot = equipment.get_node("V_Slot")

export var size = Vector2(3, 4)

var active = false
var cursor = -1

func _ready():
	init()
	deactivate()
	items.set_columns(size.y)
	

func init():
	for i in range(size.x):
		for j in range(size.y):
			var inst = slot.instance() 
			items.add_child(inst)
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
	controler.root.update_player_equipment()
	if selected_slot :
		selected_slot.set_select(false)
		selected_slot = null
	
func add_item(item_instance):
	for slot in items.get_children() :
		if slot.is_empty() :
			slot.set_item(item_instance)
			return true
	return false
	
func swap_items(slot1, slot2):
	var item1 = slot1.get_item()
	var item2 = slot2.get_item()
	slot1.remove_item()
	slot2.remove_item()
	slot1.set_item(item2)
	slot2.set_item(item1)
	
func move_cursor(child_nb):
	if cursor != -1 : get_current_item_slot().set_hover(false)
	cursor = child_nb
	get_current_item_slot().set_hover(true)
	
func get_current_item_slot():
	if cursor == 0 :
		return x_slot
	elif cursor == 1 :
		return c_slot
	elif cursor == 2 :
		return v_slot
	else :
		return items.get_child(cursor - 3)
	
func on_move_up_pressed():
	if cursor >= 3 && cursor < 3 + size.y :
		move_cursor(max(0, cursor - size.y + 1))
	else :
		move_cursor(max(0, cursor - size.y))
	
func on_move_down_pressed():
	if cursor < 3 :
		move_cursor(min(size.x * size.y + 2, cursor + size.y -1))
	else :
		move_cursor(min(size.x * size.y + 2, cursor + size.y))
	
func on_move_left_pressed():
	move_cursor(max(0, cursor - 1))
	
func on_move_right_pressed():
	move_cursor(min(size.x * size.y + 2, cursor + 1))


func on_interact_pressed():
	var slot = get_current_item_slot()
	# if a slot is already selected
	if selected_slot :
		# if the slot is different of the selected slot
		if selected_slot != slot :
			swap_items(selected_slot, slot)
		
		# if the slot is the same as the selected slot
		selected_slot.set_select(false)
		selected_slot = null
	# if no slot has been selected previously
	else :
		selected_slot = slot
		selected_slot.set_select(true)
		
	
func on_attack_pressed():
	if active :
		deactivate()
		
func on_inventory_pressed():
	if active :
		deactivate()
	else :
		activate()