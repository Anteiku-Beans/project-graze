extends Node

signal finished

onready var manji = owner
onready var sprite = owner.get_node("Sprite")
onready var fa = get_parent()


func enter() -> void:
	sprite.play("flying_assaulter_land")
	sprite.connect("animation_finished", self, "_on_animation_finished")


func _on_animation_finished() -> void:
	fa.finish()


func physics_process(delta) -> void:
	pass


func exit() -> void:
	sprite.disconnect("animation_finished", self, "_on_animation_finished")


