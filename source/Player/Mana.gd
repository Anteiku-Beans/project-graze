extends Node

const INITIAL_MANA = 0.0

export var max_mana: float = 100.0

var mana: float = INITIAL_MANA

func add_mana(amount: float) -> void:
	mana = min(max_mana, mana + amount)

func remove_mana(amount: float) -> void:
	mana = max(0.0, mana - amount)