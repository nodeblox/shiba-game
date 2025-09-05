extends Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Player/Camera/DialogBox.start_dialog("intro")
