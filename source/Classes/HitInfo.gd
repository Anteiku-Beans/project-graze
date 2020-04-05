extends Resource

class_name HitInfo

var _damage: int = 0 setget set_damage


func set_damage(value: int) -> void:
	_damage = value


func get_info() -> Dictionary:
	return {
		"damage": _damage,
	}
