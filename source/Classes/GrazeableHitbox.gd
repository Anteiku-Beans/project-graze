extends Area2D

class_name GrazeableHitbox

const ORBS_PER_GRAZE = 3
const MANA_ORB = preload("res://source/Effects/ManaOrb/ManaOrb.tscn")

func graze():
	emit_mana_orbs(ORBS_PER_GRAZE)

func emit_mana_orb() -> void:
	var new_orb = MANA_ORB.instance()
	get_tree().get_root().call_deferred("add_child", new_orb)
	new_orb.set_deferred("global_position", self.global_position)

func emit_mana_orbs(num: int) -> void:
# warning-ignore:unused_variable
	for x in range(num):
		emit_mana_orb()
