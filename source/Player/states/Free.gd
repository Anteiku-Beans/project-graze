extends State

const MAX_JUMP_STOCK = 2

export var move_speed: = 100.0

var velocity: = Vector2.ZERO
var move_direction: = Vector2.ZERO
var jump_stock: int

signal move_direction_changed

func enter(data: Dictionary = {}) -> void:
	if "landed" in data.keys():
		reset_jump_stock()

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

func reset_jump_stock() -> void:
	jump_stock = MAX_JUMP_STOCK

func use_jump_stock() -> void:
	jump_stock = max(jump_stock - 1, 0)

func has_jump_stock() -> bool:
	return jump_stock >= 1