extends State

onready var free = get_parent()
onready var sprite = owner.get_node("Sprite")
onready var wall_detector = owner.get_node("WallDetector")

func enter(data: Dictionary = {}):
	free.enter(data)
	free.replenish_jump_stock()
	sprite.request("idle")


func physics_process(delta: float):
	free.physics_process(delta)
	if not wall_detector.is_on_floor():
		_state_machine.transition_to("Free/Fall")
		return
	if free.get_move_direction() != Vector2.ZERO:
		_state_machine.transition_to("Free/Move")
		return


func exit():
	free.exit()


func unhandled_input(event: InputEvent):
	if event.is_action_pressed('jump'):
		_state_machine.transition_to('Free/Jump')
		return
	free.unhandled_input(event)
