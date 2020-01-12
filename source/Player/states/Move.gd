extends State

onready var free = get_parent()

func physics_process(delta: float) -> void:
	var move_direction = free.get_move_direction()
	free.velocity = free.calculate_velocity(
		free.velocity,
		free.max_speed,
		free.acceleration,
		delta,
		move_direction
	)
	free.velocity = owner.move_and_slide(free.velocity, Vector2.UP)
	
	# idle
	if free.get_move_direction().x == 0.0:
		_state_machine.transition_to("Free/Idle")
		return
	
	# fall
	if not owner.is_on_floor():
		_state_machine.transition_to("Free/Fall")
		return