extends Area2D

var first = true

func _ready():
	get_node("Timer").connect("timeout", self, "_on_timeout")
	get_node("Timer").start()
	
func _on_timeout():
	if(first):
		first = false
		get_node("HitBox").queue_free()
		get_node("SoundPlayer").play("sword")
		get_node("Timer").set_wait_time(0.5)
		get_node("Timer").start()
	else: 
		queue_free()
