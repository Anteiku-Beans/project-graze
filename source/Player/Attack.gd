extends Node2D

var _active: = false

onready var hitbox = $Hitbox
onready var sprite = owner.get_node("Sprite")
onready var state_machine = owner.get_node("StateMachine")
onready var player = owner

signal hit


func _ready():
	state_machine.connect("state_changed", self, "_on_state_changed")


func is_active():
	return _active


func execute() -> void:
	if _active:
		return
	_active = true
	
	sprite.request("attack", true)
	_set_hitbox_enabled(true)
	player.set_facing_locked(true)
	
	hitbox.connect("area_entered", self, "_on_hit")
	sprite.connect("animation_finished", self, "_end")


func _end() -> void:
	if not _active:
		return
	
	_active = false
	_set_hitbox_enabled(false)
	player.set_facing_locked(false)
	hitbox.disconnect("area_entered", self, "_on_hit")
	sprite.disconnect("animation_finished", self, "_end")


func _on_hit(area: Area2D):
	emit_signal("hit")
	if area.is_in_group("Enemies"):
		print("hit an enemy!")
	else:
		print("we hit something, but it wasn't an enemy...'")


func _on_state_changed(prev_state: String, new_state: String):
	if new_state == "Stagger":
		_end()


func _set_hitbox_enabled(enable: bool):
	if enable:
		var hitbox_direction: int = player.get_facing_int()
		_set_hitbox_direction(hitbox_direction)
		hitbox.set_deferred("monitoring", true)
	else:
		hitbox.set_deferred("monitoring", false)


func _set_hitbox_direction(direction: int):
	if sign(hitbox.position.x) != direction:
		hitbox.position.x *= -1
	if sign(hitbox.scale.x) != direction:
		hitbox.scale.x *= -1
