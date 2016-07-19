
extends Panel

var slot = preload("res://scenes/inventory_slot.tscn")
var fire_staff = preload("res://scenes/fire_staff.tscn")
var blue_fire_staff = preload("res://scenes/blue_fire_staff.tscn")

onready var items = get_node("Items")

export var size = Vector2(3, 4)

onready var slot_size = Vector2(items.get_size().width / (size.y), items.get_size().height / (size.x))
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
	
func add_item(item_instance):
	for slot in items.get_children() :
		if slot.is_empty() :
			print("mdr")
			slot.set_item(item_instance)
			return true
	return false
	
func move_cursor(child_nb):
	if cursor != -1 : items.get_child(cursor).set_hover(false)
	cursor = child_nb
	items.get_child(cursor).set_hover(true)
	
func get_current_item_slot():
	return items.get_child(cursor)
	
func on_move_up_pressed():
	move_cursor(max(0, cursor - size.y))
	
func on_move_down_pressed():
	move_cursor(min(size.x * size.y -1, cursor + size.y))
	
func on_move_left_pressed():
	move_cursor(max(0, cursor - 1))
	
func on_move_right_pressed():
	move_cursor(min(size.x * size.y -1, cursor + 1))


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