extends TextureButton

# Signal vom Button verbinden
func _pressed():
	# Szene laden
	var new_scene = preload("res://main.tscn").instantiate()
	get_tree().root.add_child(new_scene)
	# Optional: aktuelle Szene entfernen
	get_tree().current_scene.queue_free()
	get_tree().current_scene = new_scene

func _process(delta):
	if Input.is_action_just_pressed("button_a"):
		emit_signal("button_down")

	if Input.is_action_just_released("button_a"):
		emit_signal("button_up")
