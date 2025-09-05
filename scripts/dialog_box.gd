extends Sprite2D

@onready var label: RichTextLabel = $RichTextLabel
@onready var next_button: TextureButton = $NextButton
@onready var char_sound: AudioStreamPlayer = $CharSoundPlayer

var dialog_data = []
var current_line = 0
var is_typing = false
var typing_speed = 0.05  # Sekunden pro Buchstabe
var language = "en"      # Sprache auswählen: "en", "de", "jp"

var scale_factor = 0.1

func _ready():
	label.bbcode_enabled = true
	label.text = ""
	label.scale = Vector2(scale_factor, scale_factor)
	next_button.scale = Vector2(scale_factor * 3.5, scale_factor * 3.5)
	label.size *= 1 / scale_factor
	hide()
	if next_button:
		next_button.pressed.connect(Callable(self, "_on_next_pressed"))

func start_dialog(name: String):
	var path = "res://assets/dialogs/%s.json" % name 
	var file = FileAccess.open(path, FileAccess.READ)
	if not file:
		push_error("Dialog file not found: %s" % path)
		return
	
	var json_text = file.get_as_text()
	var data = JSON.parse_string(json_text)
	
	if typeof(data) != TYPE_DICTIONARY:
		push_error("Failed to parse JSON: %s" % path)
		return
	
	dialog_data = data["dialog"]
	current_line = 0
	show()
	_play_next_line()

func _play_next_line():
	if current_line >= dialog_data.size():
		hide()
		dialog_data = []
		return
	
	var line_data = dialog_data[current_line]
	var speaker = line_data["speaker"]
	var text = line_data["lines"].get(language, line_data["lines"]["en"])  # Fallback
	
	label.text = "[b]%s:[/b]\n" % speaker
	is_typing = true
	_typewriter(text)

func _typewriter(text: String) -> void:
	var i = 0
	while i < text.length():
		if text[i] == "[":  # Beginn eines BBCode-Tags
			var end_tag = text.find("]", i)
			if end_tag != -1:
				# komplettes Tag auf einmal hinzufügen
				label.append_text(text.substr(i, end_tag - i + 1))
				i = end_tag + 1
				continue
		# normales Zeichen
		label.append_text(text[i])
		
		if text[i] != " ":
			char_sound.stop() 
			char_sound.play()
		
		i += 1
		await get_tree().create_timer(typing_speed).timeout
	is_typing = false

func _on_next_pressed():
	if not is_typing:
		current_line += 1
		_play_next_line()
