extends KinematicBody2D

func _ready() -> void:
	Player.set_player(self)

# hack: override inbuilt is_on_floor to prevent state from
#       rapidly switching between move and fall during movement
func is_on_floor():
	return test_move(self.transform, Vector2.DOWN)