extends State

onready var free = get_parent()

func enter(data: Dictionary = {}) -> void:
	free.enter()

func physics_process(delta: float) -> void:
	var fall_direction = free.get_move_direction()
	free.acceleration.y = Global.GRAVITY
	
	free.velocity = free.calculate_velocity(
		free.velocity,
		free.max_speed,
		free.acceleration,
		delta,
		fall_direction
	)
	free.velocity = owner.move_and_slide(free.velocity, Vector2.UP)
	
	# land
	if (owner.is_on_floor()):
		if (free.get_move_direction().x != 0):
			_state_machine.transition_to("Free/Move")
			return
		else:
			_state_machine.transition_to("Free/Idle")

func exit():
	free.acceleration = free.acceleration_default
	free.exit()