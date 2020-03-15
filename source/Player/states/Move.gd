extends State

onready var free = get_parent()


func enter(data: Dictionary = {}):
	free.enter(data)


func physics_process(delta: float):
	free.physics_process(delta)
	owner.move_and_slide(free.move.velocity, Vector2.ZERO)
	
#	Transition to Idle
	if free.move.velocity == Vector2.ZERO:
		_state_machine.transition_to("Free/Idle")
		return
	
#	Transition to Fall
	if not owner.is_on_floor():
		_state_machine.transition_to("Free/Fall")
		return


func exit():
	free.exit()


func unhandled_input(event: InputEvent):
	if event.is_action_pressed('jump'):
		_state_machine.transition_to('Free/Jump')
		return
	free.unhandled_input(event)
