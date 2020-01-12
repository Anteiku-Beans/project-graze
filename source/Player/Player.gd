extends KinematicBody2D

func play_sprite(sprite_name):
	$Sprite.play(sprite_name)

func set_flip_sprite(value):
	$Sprite.flip_h = value