extends State

var move_speed: = 120.0
var velocity: Vector2

func calculate_move_velocity() -> Vector2:
	var move_direction: = get_move_direction()
	var move_velocity: = move_direction * Vector2(move_speed, 0)
	return move_velocity

func get_move_direction() -> Vector2:
	var h_dir = Input.get_action_strength("right") - Input.get_action_strength("left")
	var v_dir = 1.0
	return Vector2(h_dir, v_dir)