extends Area2D

const ORBS_PER_GRAZE = 3
const MANA_PER_ORB = 3
const MANA_ORB = preload("res://source/Effects/ManaOrb/ManaOrb.tscn")

var mana: Node

onready var player = owner

signal grazed

func _ready() -> void:
# warning-ignore:return_value_discarded
	self.connect("area_entered", self, "_on_area_entered")
	yield(player, "ready")
	mana = player.get_node("Mana")


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("mana_orb"):
		emit_signal("grazed", MANA_PER_ORB)
		area.consume()
		return
	if area is Grazebox:
		if area.is_grazeable():
			area.graze(ORBS_PER_GRAZE * MANA_PER_ORB)
			var hitbox_position = area.global_position
			emit_mana_orbs(ORBS_PER_GRAZE, hitbox_position)


func emit_mana_orb(hitbox_position: Vector2) -> void:
	var new_orb = MANA_ORB.instance()
	get_tree().get_root().call_deferred("add_child", new_orb)
	new_orb.set_deferred("global_position", hitbox_position)


func emit_mana_orbs(num: int, hitbox_position: Vector2) -> void:
	for x in range(num):
		emit_mana_orb(hitbox_position)
