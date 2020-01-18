extends State

export (float, 100.0, 5000.0, 0.5) var fall_acceleration: = 1000.0
export (float, 0.0, 2000.0, 0.5) var max_fall_speed: = 400.0

var fall_velocity: Vector2
var move_velocity: Vector2

onready var free = get_parent()

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