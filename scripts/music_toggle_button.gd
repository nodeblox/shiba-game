extends TextureButton

func _toggled(toggled_on: bool) -> void:
	if toggled_on:
		get_tree().current_scene.get_node("AudioStreamPlayer2D").autoplay = false
		get_tree().current_scene.get_node("AudioStreamPlayer2D").stop()
	else:
		get_tree().current_scene.get_node("AudioStreamPlayer2D").autoplay = true
		get_tree().current_scene.get_node("AudioStreamPlayer2D").play()
