extends State

onready var free = get_parent()

func enter(data: Dictionary = {}) -> void:
	free.enter(data)
	free.reset_jump_stock()

func physics_process(delta: float) -> void:
	free.move_velocity = free.calculate_move_velocity()
	owner.move_and_slide(free.move_velocity, Vector2.UP)
	
	# idle
	if free.calculate_move_velocity() == Vector2.ZERO:
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