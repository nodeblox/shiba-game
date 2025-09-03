extends CharacterBody2D


const ACCEL = 300.0
const DECEL = 50.0



func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var directionX := Input.get_axis("move_left", "move_right")
	var directionY := Input.get_axis("move_up", "move_down")
	if directionX:
		velocity.x = directionX * ACCEL
	else:
		velocity.x = move_toward(velocity.x, 0, DECEL)
		
	if directionY:
		velocity.y = directionY * ACCEL
	else:
		velocity.y = move_toward(velocity.y, 0, DECEL)

	move_and_slide()
