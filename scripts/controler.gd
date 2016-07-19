
extends Node

var debug = false

var root
var musicPlayer
var soundPlayer
var textBox
var inventory

func _ready():
	if debug : print("Controler init")
	root = get_tree().get_root().get_node("Root")
	if debug : print("found root: " + root.get_name())
	if not root :
		return
	
	musicPlayer = root.get_node("MusicPlayer")
	if debug : print("found musicPlayer : " + musicPlayer.get_name())
	
	soundPlayer = root.get_node("SoundPlayer")
	if debug : print("found soundPlayer: " + soundPlayer.get_name())
	
	textBox = root.get_node("TextBox")
	if debug : print("found text box: " + textBox.get_name())
	
	inventory = root.get_node("Inventory")
	if debug : print("found inventory: " + inventory.get_name())
	
func is_interacting():
	return textBox.active || inventory.active