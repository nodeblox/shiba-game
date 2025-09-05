extends TextureButton

var texture_normal_ = texture_normal

func _pressed():
	await get_tree().create_timer(0.2).timeout
	get_tree().change_scene_to_file("res://main.tscn")
	
	var BlendingRect = load("res://scripts/blending_rect.gd")
	var blending_rect = BlendingRect.new()

func _process(delta):
	if Input.is_action_just_pressed("button_a"):
		texture_normal = texture_pressed
		emit_signal("button_down")

	if Input.is_action_just_released("button_a"):
		texture_normal = texture_normal_
		emit_signal("button_up")
		_pressed()
