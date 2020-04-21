extends Node

signal finished

const DAMAGE_ZONE_FRAME = 0

onready var manji = owner
onready var sprite = owner.get_node("Sprite")
onready var fa = get_parent()
onready var damage_zone = owner.get_node("DamageZone")


func enter() -> void:
	sprite.play("flying_assaulter_land")
	sprite.connect("animation_finished", self, "_on_animation_finished")
	sprite.connect("frame_changed", self, "_on_frame_changed")
	if sprite.frame == DAMAGE_ZONE_FRAME:
		damage_zone.enable("FlyingAssaulter")


func _on_frame_changed() -> void:
	if sprite.frame == DAMAGE_ZONE_FRAME:
		damage_zone.enable("FlyingAssaulter")
	elif sprite.frame > DAMAGE_ZONE_FRAME:
		damage_zone.disable("FlyingAssaulter")
		sprite.disconnect("frame_changed", self, "_on_frame_changed")


func _on_animation_finished() -> void:
	fa.finish()


func physics_process(delta) -> void:
	pass


func exit() -> void:
	sprite.disconnect("animation_finished", self, "_on_animation_finished")
	sprite.disconnect("frame_changed", self, "_on_frame_changed")


