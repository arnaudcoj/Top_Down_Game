
extends Node

var debug = false

var root
var musicPlayer
var soundPlayer

func _ready():
	if debug : print("Controler init")
	root = get_tree().get_root().get_node("Root")
	if debug : print("found root: " + root.get_name())
	
	musicPlayer = root.get_node("MusicPlayer")
	if debug : print("found musicPlayer : " + musicPlayer.get_name())
	
	soundPlayer = root.get_node("SoundPlayer")
	if debug : print("found soundPlayer: " + soundPlayer.get_name())
	