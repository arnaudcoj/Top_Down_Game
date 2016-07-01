
extends Panel

onready var text_label = get_node("RichTextLabel")
onready var timer = get_node("Timer")
onready var nb_rows = floor(text_label.get_size().height / text_label.get_font("normal_font").get_height())

var active = false
var cursor = 0
var visible_cursor = 0
var paragraphs = []
var current_paragraph = null

func _ready():
	text_label.set_scroll_active(false)
	text_label.set_scroll_follow(true)
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
		if !current_paragraph :
			current_paragraph = paragraphs[0]
			paragraphs.pop_front()
			cursor = 0
			visible_cursor = 0
			text_label.set_visible_characters(visible_cursor)
			text_label.clear()
			timer.start()
			return true
	else :
		deactivate()
	return false

func add_paragraph(text):
	if controler.debug : print("[textbox] add ", text)
	paragraphs.push_back(text)

func add_character():
	if current_paragraph :
		if visible_cursor >= cursor && cursor < current_paragraph.length():
			add_word()
		visible_cursor += 1
		text_label.set_visible_characters(visible_cursor)
		
func add_word():
	# add the complete word, in order to get a nice auto wrapping
	while cursor < current_paragraph.length() && current_paragraph[cursor] != ' ' :
		text_label.add_text(current_paragraph[cursor])
		cursor += 1
	# add the last space
	if cursor < current_paragraph.length() && current_paragraph[cursor] == ' ' :
		text_label.add_text(current_paragraph[cursor])
		cursor += 1

		

func clear():
	if controler.debug : print("[textbox] clear")
	paragraphs.clear()
	current_paragraph = null
	cursor = 0
	visible_cursor = 0

func _on_Timer_timeout():
	if current_paragraph :
		if visible_cursor < current_paragraph.length() :
			add_character()
			timer.start()
		else :
			current_paragraph = null
			