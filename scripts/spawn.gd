extends Position2D

# specifies the direction of the character at spawn (to get a more coherent area change)
# accepted values are "up", "down", "left", "right", "none"
export(String) var direction = "none"

func _ready():
	get_node("Label").hide()