extends Resource

class_name HitInfo

var damage: int = 0 setget set_damage


func set_damage(value: int) -> void:
	damage = value


func get_info() -> Dictionary:
	return {
		"damage": damage,
	}
