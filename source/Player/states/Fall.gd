extends State

# Tween export variables
export(float) var t_initial = 0.0
export(float) var t_final = 1000.0
export(float, 0.0, 1.0, 0.02) var t_duration = 0.3
export(int, "TRANS_LINEAR", "TRANS_SINE", "TRANS_QUINT", "TRANS_QUART", "TRANS_QUAD", "TRANS_EXPO", "TRANS_ELASTIC", "TRANS_CUBIC", "TRANS_CIRC", "TRANS_BOUNCE", "TRANS_BACK") var t_trans
export(int, "EASE_IN", "EASE_OUT", "EASE_IN_OUT", "EASE_OUT_IN") var t_ease

onready var free = get_parent()
var fall_acceleration: = 800.0
var fall_velocity: Vector2
var max_fall_speed: = 400.0
var move_velocity: Vector2

func enter(data: Dictionary = {}) -> void:
	free.enter()
	fall_velocity = Vector2.ZERO

func physics_process(delta: float) -> void:
	# Calculate velocities
	fall_velocity.y += fall_acceleration * delta
	fall_velocity.y = min(fall_velocity.y, max_fall_speed)
	move_velocity = free.calculate_move_velocity()
	
	free.velocity = fall_velocity + move_velocity
	owner.move_and_slide(free.velocity, Vector2.UP)
	
	# land
	if (owner.is_on_floor()):
		if (free.get_move_direction().x != 0):
			_state_machine.transition_to("Free/Move")
			return
		else:
			_state_machine.transition_to("Free/Idle")
			return

func exit():
	free.exit()

func unhandled_input(event: InputEvent) -> void:
	free.unhandled_input(event)