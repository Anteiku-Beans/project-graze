extends Node

export var max_mana: float = 100.0

var _current_mana: float = max_mana

signal depleted
signal maxed


func get_mana():
	return _current_mana


func add_mana(amount: float) -> void:
	_current_mana = min(max_mana, _current_mana + amount)
	if _current_mana == max_mana:
		emit_signal("maxed")


func remove_mana(amount: float) -> void:
	_current_mana = max(0.0, _current_mana - amount)
	if _current_mana == 0:
		emit_signal("depleted")
