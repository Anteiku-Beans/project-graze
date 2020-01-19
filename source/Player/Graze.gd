extends Area2D

const MANA_PER_GRAZE = 3

var mana: Node

func _ready() -> void:
# warning-ignore:return_value_discarded
	self.connect("area_entered", self, "_on_area_entered")
	yield(owner, "ready")
	mana = owner.get_node("Mana")

func _on_area_entered(hitbox: Area2D) -> void:
	if hitbox.has_method('is_grazed'):
		if not hitbox.is_grazed():
			hitbox.graze()
			mana.add_mana(MANA_PER_GRAZE)