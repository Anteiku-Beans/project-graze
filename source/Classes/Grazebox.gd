extends Area2D

class_name Grazebox

export var MAX_MANA: int
var _current_mana: int setget _set_mana, get_mana
var _is_grazeable: bool = true setget _set_grazeable,is_grazeable

signal depleted
signal grazed


func _ready():
	replenish()


func replenish() -> void:
	_set_mana(MAX_MANA)
	_set_grazeable(true)


func graze(amount: int):
	_set_mana(_current_mana - amount)
	emit_signal("grazed", amount)


func _set_mana(value: int):
	_current_mana = clamp(value, 0, MAX_MANA)
	if _current_mana == 0:
		_set_grazeable(false)
		emit_signal("depleted")


func get_mana():
	return _current_mana


func _set_grazeable(value: bool):
	_is_grazeable = value
	self.set_deferred("monitorable", value)


func is_grazeable() -> bool:
	return _is_grazeable
