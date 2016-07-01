
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
	
# Activates, prompts the text box and lock the character if contains paragraphs
func activate():
	if controler.debug : print("[textbox] activate")
	if !paragraphs.empty():
		active = true
		controler.is_interacting = true
		next()
		show()

# Deactivates the textbox, ie unlock the character, clears the textbox content and hides the text box
func deactivate():
	if controler.debug : print("[textbox] deactivate")
	controler.is_interacting = false
	active = false
	clear()
	hide()

# Shows the next paragraph
func next():
	if controler.debug : print("[textbox] next")
	if !paragraphs.empty():
		if !current_paragraph :
			# set the next paragraph as current
			current_paragraph = paragraphs[0]
			paragraphs.pop_front()
			
			# reset the cursors
			cursor = 0
			visible_cursor = 0
			
			# reset the text box 
			text_label.set_visible_characters(visible_cursor)
			text_label.clear()
			
			timer.start()
			return true
	else :
		deactivate()
	return false

# Add a paragraph to the paragraphs list
func add_paragraph(text):
	if controler.debug : print("[textbox] add ", text)
	paragraphs.push_back(text)

# Clears the text box, ie empties the paragaphs list, remove the current paragraph and resets the cursors
func clear():
	if controler.debug : print("[textbox] clear")
	paragraphs.clear()
	current_paragraph = null
	cursor = 0
	visible_cursor = 0


#Internal functions

# Add a character in the label.
# Features an auto word-wrap feature.
# ie Adds a word in the text label, but increases the visible characters by one until the word is completely displayed.
func _add_character():
	if current_paragraph :
		if visible_cursor >= cursor && cursor < current_paragraph.length():
			_add_word()
		visible_cursor += 1
		text_label.set_visible_characters(visible_cursor)
		
# Add the complete word, in order to get a nice auto wrapping
# Used in _add_character
func _add_word():
	while cursor < current_paragraph.length() && current_paragraph[cursor] != ' ' :
		text_label.add_text(current_paragraph[cursor])
		cursor += 1
	# add the last space
	if cursor < current_paragraph.length() && current_paragraph[cursor] == ' ' :
		text_label.add_text(current_paragraph[cursor])
		cursor += 1

# Adds a character each tick or breaks if the paragraph is completely displayed
func _on_Timer_timeout():
	if current_paragraph :
		if visible_cursor < current_paragraph.length() :
			_add_character()
			timer.start()
		else :
			current_paragraph = null