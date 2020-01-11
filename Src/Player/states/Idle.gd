extends "res://The_Knight/states/state.gd"

func enter():
	owner.play_sprite('idle')

func update(delta):
	if not owner.is_on_ground():
		emit_signal("finished", 'fall')
		return
	if (Input.is_action_pressed('left')):
		emit_signal('finished', 'move')
		return
	if (Input.is_action_pressed('right')):
		emit_signal('finished', 'move')
		return

func handle_input(event):
	if event.is_action_pressed('jump'):
		emit_signal('finished', 'jump')
		return