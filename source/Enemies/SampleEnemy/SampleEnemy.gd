extends KinematicBody2D

const MANA_ORB = preload("res://source/Effects/ManaOrb/ManaOrb.tscn")

func _ready():
	emit_mana_orbs(10)

func emit_mana_orb() -> void:
	var new_orb = MANA_ORB.instance()
	self.add_child(new_orb)

func emit_mana_orbs(num: int) -> void:
	for x in range(num):
		emit_mana_orb()