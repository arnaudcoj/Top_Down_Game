extends Area2D

func _ready():
	if not controler.debug : hide()
	get_node("Timer").connect("timeout", self, "_on_timeout")
	get_node("Timer").start()

func _on_timeout():
	queue_free()
