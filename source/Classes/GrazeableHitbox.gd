extends Area2D

class_name GrazeableHitbox

var _is_grazed: = false

func is_grazed() -> bool:
	return _is_grazed

func graze() -> void:
	_is_grazed = true

func reset_grazed() -> void:
	_is_grazed = false