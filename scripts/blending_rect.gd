# blending_rect.gd
extends ColorRect
var do_blend = false

func _ready() -> void:
	print("Blending Rect loaded")
	self.name = "BlendingRect"
	self.position = Vector2(-5000, -5000)
	self.size = Vector2(10000, 10000)
	self.color = Color(0,0,0,0)
	self.mouse_filter = Control.MOUSE_FILTER_IGNORE
	self.z_index = 9999
	
	do_blend = true

func _process(delta):
	if do_blend == true:
		self.color.a = move_toward(self.color.a, 1.0, 0.08)
		if self.color.a >= 0.9:
			await get_tree().create_timer(0.1).timeout
			self.do_blend = false
	else:
		self.color.a = move_toward(self.color.a, 0.01, 0.08)
		
		if self.color.a == 0.01:
			queue_free()
