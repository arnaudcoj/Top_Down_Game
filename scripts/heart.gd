
extends Area2D

var player = preload("res://scripts/player.gd")
var life = 1

func _ready():
	connect("body_enter", self, "_on_enter_body")

func _on_enter_body(body):
	if (body extends player) :
		body.heal(life)
		destroy()
		
func destroy():
	queue_free()