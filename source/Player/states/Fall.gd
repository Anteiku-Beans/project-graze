extends State

onready var free = get_parent()

func enter(data: Dictionary = {}) -> void:
	free.enter()

func physics_process(delta: float) -> void:
	free.velocity.y += Global.GRAVITY
	free.physics_process(delta)
	
	if (owner.is_on_floor()):
		_state_machine.transition_to("Free/Idle")
		return

func exit():
	free.velocity.y = 0
	free.exit()