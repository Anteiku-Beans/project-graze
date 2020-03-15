extends KinematicBody2D

const _facing_RIGHT = 1
const _facing_LEFT = -1

var _facing = _facing_RIGHT

func _ready() -> void:
	Player.set_player(self)

# hack: override inbuilt is_on_floor to prevent state from
#       rapidly switching between move and fall during movement
func is_on_floor():
	return test_move(self.transform, Vector2.DOWN)

func update_facing(direction):
	var new_direction: int = 0
	
	if direction is Vector2:
		new_direction = sign(direction.x)
	elif direction is int or direction is float:
		new_direction = sign(direction)
	
#	Check if new direction is 0
	if new_direction == 0:
		return
	
	self._facing = new_direction


func get_facing_int():
	return _facing


func get_facing_vector2():
	return Vector2(_facing, 0)
