extends Area2D

class_name Hitbox

enum TYPE {
	none,
	enemy,
	player,
	environment,
	projectile_enemy,
	projectile_player,
}

var _type: int = TYPE.none
var _hit_mask: Array = []

signal hit


func set_type(type: int) -> void:
	assert(type in TYPE.values())
	_type = type


func receive_hit(hit_info):
	emit_signal("hit", hit_info)


func get_position() -> Vector2:
	return self.global_position


func add_hit_mask(type: int) -> void:
	assert(type in TYPE.values())
	_hit_mask.append(_type)


func can_receive_from(type: int) -> bool:
	assert(type in TYPE.values())
	var is_in_hit_mask = _type in _hit_mask
	return is_in_hit_mask
