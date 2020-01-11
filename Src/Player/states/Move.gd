extends "res://The_Knight/states/state.gd"

var move_velocity = Vector2()

func enter():
	owner.play_sprite('move')

func update(delta):
	move_velocity = calc_move_velocity()
	maybe_flip_sprite(move_velocity)
	owner.move_and_slide(move_velocity, Global.UP)
	
	if (move_velocity == Vector2()):
		emit_signal('finished', 'idle')
		return


func handle_input(event):
	if event.is_action_pressed('jump'):
		emit_signal('finished', 'jump')
		return

func calc_move_velocity():
	var velocity = Vector2()
	var move_left = int(Input.is_action_pressed("left"))
	var move_right = int(Input.is_action_pressed("right"))
	velocity = owner.move_speed * (move_left*Global.LEFT + move_right*Global.RIGHT)
	return velocity

func maybe_flip_sprite(velocity):
	if (velocity.x > 0): # moving to the right
		owner.set_flip_sprite(false)
	elif (velocity.x < 0): # moving to the left
		owner.set_flip_sprite(true)
	else: # not moving
		pass
