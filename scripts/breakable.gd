extends StaticBody2D

var attack = preload("res://scripts/attack.gd")
var heart = preload("res://scenes/heart.tscn")

func _ready():
	get_node("HitBox").connect("area_enter", self, "_on_enter")
	get_node("Timer").connect("timeout", self, "_on_timeout")

func drop():
	var drop = heart.instance()
	drop.set_global_pos(self.get_global_pos())
	get_parent().add_child(drop)

func _on_enter(area):
	if (area extends attack):
		get_node("CollisionBox").set_trigger(true) 
		get_node("Sprite").queue_free()
		get_node("HitBox").queue_free()
		get_node("SoundPlayer").play("cut_bush")
		get_node("Particles").set_emitting(true)
		drop()
		get_node("Timer").start()
		
func _on_timeout():
	queue_free()