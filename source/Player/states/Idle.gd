extends State

onready var free = get_parent()

func enter(data: Dictionary = {}) -> void:
	free.enter()
	free.velocity = Vector2.ZERO

func physics_process(delta: float) -> void:
	# fall
	if (not owner.is_on_floor()):
		_state_machine.transition_to("Free/Fall")
		return
	
	# move
	if free.get_move_direction().x != 0.0:
		_state_machine.transition_to("Free/Move")
		return
	
func exit():
	free.exit()

func unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed('jump'):
		pass
	free.unhandled_input(event)