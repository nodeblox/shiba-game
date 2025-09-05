extends TextureButton

var texture_normal_ = texture_normal

func _process(delta):	
	if Input.is_action_just_pressed("button_a"):
		texture_normal = texture_pressed
		emit_signal("button_down")

	if Input.is_action_just_released("button_a"):
		texture_normal = texture_normal_
		emit_signal("button_up")
		emit_signal("pressed")
