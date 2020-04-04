extends Node2D

const HITBOX_START_FRAME = 1
const HITBOX_END_FRAME = 2

const NO_HITOX = null

const ATTACK_GROUND_STR = "attack"
const ATTACK_AIR_STR = "attack_air"
const ATTACK_DOWN_STR = "attack_down"
const NO_ANIM_STRING = ""

var _active: = false
var hitbox: Node = NO_HITOX
var anim_string: String = NO_ANIM_STRING

onready var sprite = owner.get_node("Sprite")
onready var state_machine = owner.get_node("StateMachine")
onready var player = owner
onready var wall_detector = owner.get_node("WallDetector")

signal hit


func is_active():
	return _active


func execute() -> void:
	if _active:
		return
	_active = true
	
#	Choose which attack to execute
	if wall_detector.is_on_floor():
		anim_string = ATTACK_GROUND_STR
		hitbox = $HitboxGround
	elif Input.is_action_pressed("down"):
		anim_string = ATTACK_DOWN_STR
		hitbox = $HitboxDown
	else:
		anim_string = ATTACK_AIR_STR
		hitbox = $HitboxAir
	
	sprite.request(anim_string, true)
#	_set_hitbox_enabled(true)
	player.set_facing_locked(true)
	
	state_machine.connect("state_changed", self, "_on_state_changed")
	hitbox.connect("area_entered", self, "_on_hit")
	sprite.connect("animation_finished", self, "_end")
	sprite.connect("frame_changed", self, "_on_sprite_frame_changed")


func interrupt():
	_set_hitbox_enabled(false)
	sprite.clear_priority_anim(anim_string)
	_end()


func _end() -> void:
	if not _active:
		return
	
	player.set_facing_locked(false)
	state_machine.disconnect("state_changed", self, "_on_state_changed")
	hitbox.disconnect("area_entered", self, "_on_hit")
	sprite.disconnect("animation_finished", self, "_end")
	sprite.disconnect("frame_changed", self, "_on_sprite_frame_changed")
	hitbox = NO_HITOX
	anim_string = NO_ANIM_STRING
	_active = false


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
