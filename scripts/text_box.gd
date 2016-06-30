
extends Panel

onready var text_label = get_node("RichTextLabel")
onready var timer = get_node("Timer")
var active = false
var paragraphs = []
var current_paragraph = null
#var nb_rows = floor(text_label.get_size().height / text_label.get_font("normal_font").get_height())

func _ready():
	deactivate()
	text_label.set_scroll_active(false)
		
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
		if current_paragraph == null || text_label.get_visible_characters() >= current_paragraph.length() :
			current_paragraph = paragraphs[0]
			paragraphs.pop_front()
			text_label.set_bbcode(current_paragraph)
			text_label.set_visible_characters(0)
			timer.start()
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

func _on_Timer_timeout():
	text_label.set_visible_characters(text_label.get_visible_characters() + 1)
	timer.start()
