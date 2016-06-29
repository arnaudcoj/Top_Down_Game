extends StaticBody2D

var sword_hit = preload("res://scripts/sword_hit.gd")

func _ready():
	get_node("HitBox").connect("area_enter", self, "_on_enter")
	get_node("Timer").connect("timeout", self, "_on_timeout")

func _on_enter(area):
	if (area extends sword_hit):
		get_node("Sprite").queue_free()
		get_node("HitBox").queue_free()
		get_node("SoundPlayer").play("cut_bush")
		get_node("Particles").set_emitting(true)
		get_node("Timer").start()
		
func _on_timeout():
	queue_free()