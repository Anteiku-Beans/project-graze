extends KinematicBody2D

func play_sprite(sprite_name):
	$Sprite.play(sprite_name)

func set_flip_sprite(value):
	$Sprite.flip_h = value

# hack: override inbuilt is_on_floor to prevent state from
#       rapidly switching between move and fall during movement
func is_on_floor():
	return test_move(self.transform, Vector2.DOWN)