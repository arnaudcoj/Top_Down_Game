extends Area2D

func _ready():
	get_node("Timer").connect("timeout", self, "_on_timeout")
	get_node("Timer").start()
	
func _on_timeout():
		get_node("HitBox").queue_free()
		get_node("SoundPlayer").play("sword")
		get_node("Timer").disconnect("timeout", self, "_on_timeout")
		get_node("Timer_2").connect("timeout", self, "_on_timeout_2")
		get_node("Timer_2").start()

func _on_timeout_2():
	queue_free()
