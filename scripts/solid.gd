extends Area2D

var sword_hit = preload("res://scripts/sword_hit.gd")

func _ready():
	connect("area_enter", self, "_on_enter")

func _on_enter(area):
	if (area extends sword_hit):
		controler.soundPlayer.play("sword_solid")