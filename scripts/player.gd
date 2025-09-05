extends CharacterBody2D

const ACCEL = 30.0
const DECEL = 10.0

var collision_map
var collision_texture
var collision_image

func _ready() -> void:
	# Wait for CollisionMap to be loaded
	await get_tree().process_frame
	collision_map = get_node("/root/Node/CollisionMap")
	collision_texture = collision_map.texture
	collision_image = collision_texture.get_image()

func _process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var directionX := Input.get_axis("move_left", "move_right")
	var directionY := Input.get_axis("move_up", "move_down")
	
	var pos
	if collision_map:
		pos = position - collision_map.position + (collision_map.texture.get_size() / 2)
	
	# X Axis movement
	if directionX:
		velocity.x = directionX * ACCEL
	else:
		velocity.x = move_toward(velocity.x, 0, DECEL)
		
	if collision_map && collision_image.get_pixel(int(pos.x + (velocity.x * delta)), int(pos.y)).r < 0.5:
		velocity.x = 0
		
	# Y Axis movement
	if directionY:
		velocity.y = directionY * ACCEL
	else:
		velocity.y = move_toward(velocity.y, 0, DECEL)
		
	if collision_map && collision_image.get_pixel(int(pos.x), int(pos.y + (velocity.y * delta))).r < 0.5:
		velocity.y = 0
		
	# Prevent faster diagonal movement
	if directionX && directionY:
		velocity.x *= 0.75
		velocity.y *= 0.75

	if velocity.y > 0 && velocity.x == 0:
		$AnimationPlayer.play("walk_down")
	if velocity.y < 0 && velocity.x == 0:
		$AnimationPlayer.play("walk_up")
	if velocity.x > 0:
		$AnimationPlayer.play("walk_right")
	if velocity.x < 0:
		$AnimationPlayer.play("walk_left")
	if velocity.x == 0 && velocity.y == 0:
		$AnimationPlayer.stop()
	else:
		if $AudioStreamPlayer.has_stream_playback() == false:
			$AudioStreamPlayer.play()
	
	move_and_slide()
	
	
	# Camera movement
	var cam = $Camera
	
	cam.position += -velocity * Vector2(delta, delta)
	
	if cam.position.x > 40 or cam.position.x < -40:
		cam.position.x = move_toward(cam.position.x, 0, ACCEL * delta)
		
	if cam.position.y > 20 or cam.position.y < -20:
		cam.position.y = move_toward(cam.position.y, 0, ACCEL * delta)
