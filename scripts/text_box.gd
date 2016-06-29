
extends Panel

var active = false
var paragraphs = []
var current_paragraph = null
onready var text_label = get_node("RichTextLabel")

func _ready():
	deactivate()
	
func activate():
	if controler.debug : print("[textbox] activate")
	if !paragraphs.empty():
		active = true
		controler.is_interacting = true
		next()
		show()

func deactivate():
	if controler.debug : print("[textbox] deactivate")
	controler.is_interacting = false
	active = false
	clear()
	hide()

func next():
	if controler.debug : print("[textbox] next")
	if !paragraphs.empty():
		current_paragraph = paragraphs[0]
		paragraphs.pop_front()
		text_label.set_bbcode(current_paragraph)
		return true
	else :
		deactivate()
	return false

func add_paragraph(text):
	if controler.debug : print("[textbox] add ", text)
	paragraphs.push_back(text)
		
func clear():
	if controler.debug : print("[textbox] clear")
	paragraphs.clear()
	current_paragraph = null