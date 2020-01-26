extends State

onready var free = get_parent()

func enter(data: Dictionary = {}) -> void:
	free.enter(data)
	free.reset_jump_stock()

func physics_process(delta: float) -> void:
	free.velocity = free.calculate_move_velocity()
	owner.move_and_slide(free.velocity, Vector2.UP)
	
	# idle
	if free.get_move_direction().x == 0.0:
		_state_machine.transition_to("Free/Idle")
		return
	
	# fall
	if not owner.is_on_floor():
		_state_machine.transition_to("Free/Fall")
		return

func exit() -> void:
	free.exit()

func unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed('jump'):
		_state_machine.transition_to('Free/Jump')
	free.unhandled_input(event)