extends Node

export var max_mana: float = 100.0

var _current_mana: float = 0.0

onready var grazer = get_parent().get_node("Grazer")

signal depleted
signal maxed


func _ready():
	grazer.connect("grazed", self, "_on_grazed")


func _on_grazed(amount):
	recover_mana(amount)


func get_mana():
	return _current_mana


func recover_mana(amount: float) -> void:
	_current_mana = min(max_mana, _current_mana + amount)
	if _current_mana == max_mana:
		emit_signal("maxed")


func remove_mana(amount: float) -> void:
	_current_mana = max(0.0, _current_mana - amount)
	if _current_mana == 0:
		emit_signal("depleted")
