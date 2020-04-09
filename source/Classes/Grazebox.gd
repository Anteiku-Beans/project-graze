extends Area2D

class_name Grazebox

export var MAX_MANA: int
var _current_mana: int

signal depleted
signal grazed


func _ready():
	replenish()


func replenish() -> void:
	_set_mana(MAX_MANA)


func graze(amount: int):
	_set_mana(_current_mana - amount)
	emit_signal("grazed", amount)


func _set_mana(value: int):
	_current_mana = clamp(value, 0, MAX_MANA)
	if _current_mana == 0:
		emit_signal("depleted")


func get_mana():
	return _current_mana
