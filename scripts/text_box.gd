
extends Panel

var active = false
var paragraphs = []
var current_paragraph = null
onready var text_label = get_node("RichTextLabel")

func _ready():
	deactivate()
	
func activate():
	print("activate")
	if !paragraphs.empty():
		active = true
		controler.is_interacting = true
		next()
		show()

func deactivate():
	print("deactivate")
	controler.is_interacting = false
	active = false
	clear()
	hide()

func next():
	print("next")
	if !paragraphs.empty():
		current_paragraph = paragraphs[0]
		paragraphs.pop_front()
		text_label.set_bbcode(current_paragraph)
		return true
	else :
		deactivate()
	return false

func add_paragraph(text):
	print("add", text)
	paragraphs.push_back(text)
		
func clear():
	print("clear")
	paragraphs.clear()
	current_paragraph = null