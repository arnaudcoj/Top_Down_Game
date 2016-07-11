
extends Area2D

var player = preload("res://scripts/player.gd")

export var damages = 1

func _ready(): 
	connect("body_enter", self, "_on_enter_body")

func _on_enter_body(body):
	if !(body extends player) :
		if body.has_method("lose_life"):
			body.lose_life(damages)
		destroy()
