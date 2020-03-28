extends Area2D

const MANA_PER_GRAZE = 3

var mana: Node

onready var player = owner

func _ready() -> void:
# warning-ignore:return_value_discarded
	self.connect("area_entered", self, "_on_area_entered")
	yield(player, "ready")
	mana = player.get_node("Mana")

func _on_area_entered(hitbox: Area2D) -> void:
	if hitbox is ManaOrbHitbox:
		hitbox.consume()
		mana.add_mana(MANA_PER_GRAZE)
		return
	if hitbox is GrazeableHitbox:
		hitbox.graze()
