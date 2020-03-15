extends Node2D

var _active: = false

onready var hitbox = $Hitbox
onready var sprite = owner.get_node("Sprite")

signal hit


func is_active():
	return _active


func execute() -> void:
	if not _active:
		_active = true
		
		_set_hitbox_enabled(true)
		hitbox.connect("area_entered", self, "_on_hit")
		
		sprite.request("attack", true)
		sprite.connect("animation_finished", self, "_end")


func _end() -> void:
	if _active:
		_active = false
		_set_hitbox_enabled(false)
		hitbox.disconnect("area_entered", self, "_on_hit")
		sprite.disconnect("animation_finished", self, "_end")


func _on_hit(area: Area2D):
	emit_signal("hit")
	if area.is_in_group("Enemies"):
		print("hit an enemy!")
	else:
		print("we hit something, but it wasn't an enemy...'")


func _set_hitbox_enabled(enable: bool):
	if enable:
		var hitbox_direction: int = owner.get_facing_int()
		_set_hitbox_direction(hitbox_direction)
		hitbox.set_deferred("monitoring", true)
	else:
		hitbox.set_deferred("monitoring", false)


func _set_hitbox_direction(direction: int):
	if sign(hitbox.position.x) != direction:
		hitbox.position.x *= -1
	if sign(hitbox.scale.x) != direction:
		hitbox.scale.x *= -1
