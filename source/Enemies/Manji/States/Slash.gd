extends State

const DAMAGE_ZONE_NAME = "Slash"
const DAMAGE_ZONE_FRAME_START = 2

onready var manji = owner
onready var sprite = owner.get_node("Sprite")
onready var damage_zone = owner.get_node("DamageZone")


func enter(data: Dictionary = {}) -> void:
	assert("direction" in data.keys())
	sprite.flip(data["direction"])
	damage_zone.flip(data["direction"])
	sprite.play("slash")
	sprite.connect("animation_finished", self, "_on_animation_finished")
	sprite.connect("frame_changed", self, "_on_frame_changed")


func _on_animation_finished() -> void:
	_state_machine.transition_to("Assaulter", {"direction": Vector2.RIGHT})


func _on_frame_changed() -> void:
	if sprite.frame == DAMAGE_ZONE_FRAME_START:
		damage_zone.enable(DAMAGE_ZONE_NAME)
	elif sprite.frame > DAMAGE_ZONE_FRAME_START:
		damage_zone.disable(DAMAGE_ZONE_NAME)
		sprite.disconnect("frame_changed", self, "_on_frame_changed")


func exit() -> void:
	damage_zone.disable(DAMAGE_ZONE_NAME)
	sprite.disconnect("animation_finished", self, "_on_animation_finished")
	sprite.disconnect("frame_changed", self, "_on_frame_changed")
