extends KinematicBody2D

const _facing_RIGHT = 1
const _facing_LEFT = -1

var _facing = _facing_RIGHT
var _facing_locked := false

signal facing_updated


func _ready() -> void:
	Player.set_player(self)


func update_facing(direction):
	if _facing_locked:
		return
	var new_direction: int = 0
	
	if direction is Vector2:
		new_direction = sign(direction.x)
	elif direction is int or direction is float:
		new_direction = sign(direction)
	
#	Check if new direction is 0
	if new_direction == 0:
		return
	
	self._facing = new_direction
	emit_signal("facing_updated")


func flip_facing():
	if _facing_locked:
		return
	_facing *= -1
	emit_signal("facing_updated")


func get_facing_int():
	return _facing


func get_facing_vector2():
	return Vector2(_facing, 0)


func set_facing_locked(value: bool) -> void:
	_facing_locked = value
