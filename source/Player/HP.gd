extends Node

var max_hp: int = 5
var current_hp: int setget set_health

signal dead
signal hp_updated # for UI purposes

func _ready() -> void:
	current_hp = max_hp

func take_damage(amount: int) -> void:
	current_hp = max(0, current_hp - amount)

func heal(amount) -> void:
	current_hp = min(max_hp, current_hp + amount)

func set_health(value) -> void:
	current_hp = value
	emit_signal("hp_updated")
	if current_hp == 0:
		emit_signal("dead")
