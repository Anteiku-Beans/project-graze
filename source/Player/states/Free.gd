extends State

export var move_speed: = 100.0
var velocity: = Vector2.ZERO
var move_direction: = Vector2.ZERO

signal move_direction_changed

func calculate_move_velocity() -> Vector2:
# warning-ignore:shadowed_variable
	var move_direction: = get_move_direction()
	var move_velocity: = move_direction * Vector2(move_speed, 0)
	return move_velocity

func get_move_direction() -> Vector2:
	var h_dir = Input.get_action_strength("right") - Input.get_action_strength("left")
	var v_dir = 1.0
	
	if (h_dir != move_direction.x):
		emit_signal("move_direction_changed", h_dir)
	
	move_direction = Vector2(h_dir, v_dir)
	return move_direction