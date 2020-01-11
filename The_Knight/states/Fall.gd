extends "res://The_Knight/states/state.gd"

var fall_speed = 0
var fall_velocity = Vector2()

func enter():
	owner.play_sprite('fall')

func update(delta):
	if (owner.is_on_ground()):
		emit_signal("finished", 'idle')
		return
	
	fall_speed += Global.GRAVITY
	fall_velocity = fall_speed * Global.DOWN
	owner.move_and_slide(fall_velocity, Global.UP)

func exit():
	fall_speed = 0