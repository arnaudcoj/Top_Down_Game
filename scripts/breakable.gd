extends Sprite

var sword_hit = preload("res://scripts/sword_hit.gd")

func _ready():
	get_node("HitBox").connect("area_enter", self, "_on_enter")

func _on_enter(area):
	if (area extends sword_hit):
		sound_player.play("cut_bush")
		queue_free()