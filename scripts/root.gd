
extends Node2D

var current_music

onready var map = get_node("Map")
onready var animation = get_node("AnimationPlayer")
onready var animation_timer = animation.get_node("Timer")

export(bool) var playing_music = true
export(String) var level = "level1"
export(String) var spawn = "Spawn"

func _ready():
	_enter_level()
	
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
	map.add_child(level_node)
	
	animation.queue("enter_area")
	if controler.debug : print("entered level " + level)
	
func _on_Timer_timeout():
	_enter_level()