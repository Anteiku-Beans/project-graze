extends Node2D

const HITBOX_START_FRAME = 1
const HITBOX_END_FRAME = 2

var _active: = false

onready var hitbox = $Hitbox
onready var sprite = owner.get_node("Sprite")
onready var state_machine = owner.get_node("StateMachine")
onready var player = owner

signal hit


func is_active():
	return _active


func execute() -> void:
	if _active:
		return
	_active = true
	
	sprite.request("attack", true)
#	_set_hitbox_enabled(true)
	player.set_facing_locked(true)
	
	state_machine.connect("state_changed", self, "_on_state_changed")
	hitbox.connect("area_entered", self, "_on_hit")
	sprite.connect("animation_finished", self, "_end")
	sprite.connect("frame_changed", self, "_on_sprite_frame_changed")


func interrupt():
	_set_hitbox_enabled(false)
	sprite.clear_priority_anim("attack")
	_end()


func _end() -> void:
	if not _active:
		return
	
	_active = false
	player.set_facing_locked(false)
	state_machine.disconnect("state_changed", self, "_on_state_changed")
	hitbox.disconnect("area_entered", self, "_on_hit")
	sprite.disconnect("animation_finished", self, "_end")
	sprite.disconnect("frame_changed", self, "_on_sprite_frame_changed")


func _on_sprite_frame_changed():
	if sprite.frame == HITBOX_START_FRAME:
		_set_hitbox_enabled(true)
	elif sprite.frame == HITBOX_END_FRAME:
		_set_hitbox_enabled(false)


func _on_hit(area: Area2D):
	emit_signal("hit")
	if area.is_in_group("Enemies"):
		print("hit an enemy!")
	else:
		print("we hit something, but it wasn't an enemy...'")


func _on_state_changed(prev_state: String, new_state: String):
	if not new_state in state_machine.get_free_states():
		interrupt()


func _set_hitbox_enabled(enable: bool):
	if enable:
		var hitbox_direction: int = player.get_facing_int()
		_set_hitbox_direction(hitbox_direction)
		hitbox.set_deferred("monitoring", true)
		hitbox.set_deferred("visible", true)
	else:
		hitbox.set_deferred("monitoring", false)
		hitbox.set_deferred("visible", false)


func _set_hitbox_direction(direction: int):
	if sign(hitbox.position.x) != direction:
		hitbox.position.x *= -1
	if sign(hitbox.scale.x) != direction:
		hitbox.scale.x *= -1
