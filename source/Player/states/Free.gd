extends State

const MAX_JUMP_STOCK: int = 2
const RIGHT_2D = 1
const LEFT_2D = -1

export var move_speed: = 130.0

var facing_direction: = Vector2.RIGHT
var move_velocity: = Vector2.ZERO
var move_direction: Vector2
var jump_stock: int

signal facing_direction_changed

func enter(data: Dictionary = {}) -> void:
	if "landed" in data.keys():
		reset_jump_stock()

func unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("dash"):
		_state_machine.transition_to("Dash", {"direction":facing_direction})
		return
	if event.is_action_pressed("attack"):
		_state_machine.transition_to("Attack")
		return

func calculate_move_velocity() -> Vector2:
# warning-ignore:shadowed_variable
	var direction = get_move_direction()
	var velocity = direction * Vector2(move_speed, 0)
	return velocity

func get_move_direction() -> Vector2:
	var h_dir = Input.get_action_strength("right") - Input.get_action_strength("left")
	if h_dir != 0:
		facing_direction = Vector2(h_dir, 0)
		emit_signal("facing_direction_changed", facing_direction)
	return Vector2(h_dir, 0.0)

func reset_jump_stock() -> void:
	jump_stock = MAX_JUMP_STOCK

func use_jump_stock() -> void:
	jump_stock = int(max(jump_stock - 1, 0))

func has_jump_stock() -> bool:
	return jump_stock >= 1
