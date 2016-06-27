extends Area2D

func _ready():
	get_node("Timer").connect("timeout", self, "_on_timeout")
	get_node("Timer").start()

func _on_timeout():
	queue_free()
