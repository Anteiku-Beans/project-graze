extends State

export var max_speed_default: = Vector2(70.0, 350.0)
export var acceleration_default: = Vector2(1000000.0, 0)

var acceleration: = acceleration_default
var max_speed: = max_speed_default
var velocity: = Vector2.ZERO

func calculate_velocity(
		old_velocity: Vector2,
		max_speed: Vector2,
		acceleration: Vector2,
		delta: float,
		move_direction: Vector2
	) -> Vector2:
	var new_velocity: = old_velocity

	new_velocity += move_direction * acceleration * delta
	new_velocity.x = clamp(new_velocity.x, -max_speed.x, max_speed.x)
	new_velocity.y = clamp(new_velocity.y, -max_speed.y, max_speed.y)

	return new_velocity

func get_move_direction() -> Vector2:
	var h_dir = Input.get_action_strength("right") - Input.get_action_strength("left")
	var v_dir = 1.0
	return Vector2(h_dir, v_dir)