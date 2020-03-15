extends State

onready var free: = get_parent()

func physics_process(delta):
	free.physics_process(delta)
