
extends Node

var current_music

onready var map = get_node("Map")
onready var animation = get_node("AnimationPlayer")
onready var animation_timer = animation.get_node("Timer")
onready var textbox = get_node("GUI/TextBox")
onready var inventory = get_node("GUI/Inventory")
var player

export(bool) var playing_music = true
var level = "../intro"
var spawn = null


func _ready():
	set_process(true)
	set_process_input(true)
	_enter_level()
	
func _process(delta):
	if player :
		player.process_directions()
	
func _input(event):
	if event.is_action_pressed("equipment_B"):
		on_equipment_B_pressed()
	elif event.is_action_pressed("equipment_X"):
		on_equipment_X_pressed()
	elif event.is_action_pressed("equipment_Y"):
		on_equipment_Y_pressed()
	elif event.is_action_pressed("interact"):
		on_interact_pressed()
	elif event.is_action_released("interact"):
		on_interact_released()
	elif event.is_action_pressed("inventory"):
		on_inventory_pressed()
	elif event.is_action_pressed("move_up"):
		on_move_up_pressed()
	elif event.is_action_pressed("move_down"):
		on_move_down_pressed()
	elif event.is_action_pressed("move_left"):
		on_move_left_pressed()
	elif event.is_action_pressed("move_right"):
		on_move_right_pressed()
	
func on_move_up_pressed():
	if inventory && inventory.active :
		inventory.on_move_up_pressed()
	
func on_move_down_pressed():
	if inventory && inventory.active :
		inventory.on_move_down_pressed()
	
func on_move_left_pressed():
	if inventory && inventory.active :
		inventory.on_move_left_pressed()
	
func on_move_right_pressed():
	if inventory && inventory.active :
		inventory.on_move_right_pressed()
	
func on_equipment_B_pressed():
	if textbox && textbox.active :
		textbox.on_attack_pressed()
	elif inventory && inventory.active :
		inventory.on_attack_pressed()
	elif player : 
		player.on_equipment_B_pressed()
		
func on_equipment_X_pressed():
	if textbox && textbox.active :
		textbox.on_attack_pressed()
	elif inventory && inventory.active :
		inventory.on_attack_pressed()
	elif player : 
		player.on_equipment_X_pressed()
		
func on_equipment_Y_pressed():
	if textbox && textbox.active :
		textbox.on_attack_pressed()
	elif inventory && inventory.active :
		inventory.on_attack_pressed()
	elif player : 
		player.on_equipment_Y_pressed()
		
func on_interact_pressed():
	if textbox && textbox.active :
		textbox.on_interact_pressed()
	elif inventory && inventory.active :
		inventory.on_interact_pressed()
	elif player : 
		player.on_interact_pressed()
	
func on_interact_released():
	if textbox && textbox.active : 
		textbox.on_interact_released()
	
func on_inventory_pressed():
	if textbox && textbox.active :
		textbox.on_interact_pressed()
	elif player && inventory : 
		inventory.on_inventory_pressed()

func update_player_equipment():
	if player :
		player.update_equipment()

func change_level(new_level, new_spawn):
	level = new_level
	spawn = new_spawn
	
	_exit_level()
	animation_timer.start()

func change_music(music_name, loop = true) :
	var music_player = get_node("MusicPlayer")
	
	if current_music != music_name :
		current_music = music_name
		music_name = "res://musics/" + music_name + ".ogg"
		var music_stream = load(music_name)
		music_player.set_stream(music_stream)
		music_player.set_loop(loop)
		music_player.play(0)
		if controler.debug : print("playing music " + music_name)

func _exit_level():
	if map.get_child_count() :
		animation.queue("exit_area")
		
func _enter_level():
	if level == null :
		return
		
	for child in map.get_children() :
		child.queue_free()
		
	var level_scene = load("res://scenes/levels/" + level + ".tscn")
	var level_node = level_scene.instance()
	if(playing_music):
		change_music(level_node.music, level_node.loop)
	
	level_node.spawn_player(spawn)
	player = level_node.get_player()
	map.add_child(level_node)
	update_player_equipment()
	
	animation.queue("enter_area")
	if controler.debug : print("entered level " + level)
	
func _on_Timer_timeout():
	_enter_level()