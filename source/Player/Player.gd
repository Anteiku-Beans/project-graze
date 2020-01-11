extends KinematicBody2D

var move_speed = 50
var gravity = 0
var move_velocity_right = Vector2()
var move_velocity_left = Vector2()

func _physics_process(delta):
	move_and_slide(move_velocity_right + move_velocity_left, Global.UP)

func is_on_ground():
	#Returns true if a collision would occur.
	return test_move(transform, Global.DOWN)

func play_sprite(sprite_name):
	$Sprite.play(sprite_name)

func set_flip_sprite(value):
	$Sprite.flip_h = value