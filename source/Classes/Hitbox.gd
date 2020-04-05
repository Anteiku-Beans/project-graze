extends Area2D

class_name Hitbox

enum TYPE {
	none = 1,
	enemy = 2,
	player = 4,
	environment = 8,
	projectile_enemy = 16,
	projectile_player = 32,
	mana_orb = 64,
}

export (TYPE) var _type: int = TYPE.none
export (TYPE, FLAGS) var _hit_mask = TYPE.none

signal hit


func set_type(type: int) -> void:
	assert(type in TYPE.values())
	_type = type


func get_type() -> int:
	return _type


func receive_hit(hit_info):
	emit_signal("hit", hit_info)


func get_position() -> Vector2:
	return self.global_position


func add_hit_mask(type: int) -> void:
	assert(type in TYPE.values())
	if not can_receive_from(type):
		_hit_mask += type


func remove_hit_mask(type: int) -> void:
	assert(type in TYPE.values())
	if can_receive_from(type):
		_hit_mask -= type


func can_receive_from(type: int) -> bool:
	assert(type in TYPE.values())
	return type & _hit_mask == type
