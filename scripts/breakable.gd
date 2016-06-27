extends Sprite

var attack = preload("res://scripts/attack.gd")

func _ready():
	get_node("Area2D").connect("area_enter", self, "_on_enter")

func _on_enter(area):
	print(area, " enters")
	if (area extends attack):
		queue_free()