extends State

onready var free = get_parent()

func enter(data: Dictionary = {}) -> void:
	free.enter()

func physics_process(delta: float) -> void:
	if (not owner.is_on_floor()):
		_state_machine.transition_to("Free/Fall")
	get_parent().physics_process(delta)

func exit():
	free.exit()