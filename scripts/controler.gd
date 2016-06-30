
extends Node

var debug = true

var root
var musicPlayer
var soundPlayer
var textBox

#to be moved in a global player state
var is_interacting = false

func _ready():
	if debug : print("Controler init")
	root = get_tree().get_root().get_node("Root")
	if debug : print("found root: " + root.get_name())
	
	musicPlayer = root.get_node("MusicPlayer")
	if debug : print("found musicPlayer : " + musicPlayer.get_name())
	
	soundPlayer = root.get_node("SoundPlayer")
	if debug : print("found soundPlayer: " + soundPlayer.get_name())
	
	textBox = root.get_node("TextBox")
	if debug : print("found text box: " + textBox.get_name())
	