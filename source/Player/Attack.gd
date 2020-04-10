extends Node2D

const HITBOX_START_FRAME = 1
const HITBOX_END_FRAME = 3

const DAMAGE = 1

enum ATTACK {NONE, GROUND, AIR, DOWN}

var _active: = false
var current_attack: int
var hit_info: HitInfo

var anim_names = {
	ATTACK.NONE: "",
	ATTACK.GROUND: "attack",
	ATTACK.AIR: "attack_air",
	ATTACK.DOWN: "attack_down",
}

onready var shapes = {
	ATTACK.NONE: null,
	ATTACK.GROUND: $Hitbox/ShapeGround,
	ATTACK.AIR: $Hitbox/ShapeAir,
	ATTACK.DOWN: $Hitbox/ShapeDown
}

onready var sprite = owner.get_node("Sprite")
onready var state_machine = owner.get_node("StateMachine")
onready var player = owner
onready var wall_detector = owner.get_node("WallDetector")
onready var hitbox = $Hitbox

signal hit
signal finished
signal interrupted


func _ready():
	hit_info = HitInfo.new()
	hit_info.set_damage(DAMAGE)


func is_active():
	return _active


func execute() -> void:
	if _active:
		return
	_active = true
	
#	Choose which attack to execute
	if wall_detector.is_on_floor():
		current_attack = ATTACK.GROUND
	elif Input.is_action_pressed("down"):
		current_attack = ATTACK.DOWN
	else:
		current_attack = ATTACK.AIR
	
	sprite.request(anim_names[current_attack], true)
	player.set_facing_locked(true)
	
	state_machine.connect("state_changed", self, "_on_state_changed")
	hitbox.connect("area_entered", self, "_on_hit")
	sprite.connect("animation_finished", self, "_end")
	sprite.connect("frame_changed", self, "_on_sprite_frame_changed")


func interrupt():
	_set_hitbox_enabled(false)
	sprite.clear_priority_anim(anim_names[current_attack])
	_end()
	emit_signal("interrupted")


func _end() -> void:
	if not _active:
		return
	
	player.set_facing_locked(false)
	state_machine.disconnect("state_changed", self, "_on_state_changed")
	hitbox.disconnect("area_entered", self, "_on_hit")
	sprite.disconnect("animation_finished", self, "_end")
	sprite.disconnect("frame_changed", self, "_on_sprite_frame_changed")
	
	current_attack = ATTACK.NONE
	_active = false	
	emit_signal("finished")


func _on_sprite_frame_changed():
	if sprite.frame == HITBOX_START_FRAME:
		_set_hitbox_enabled(true)
	elif sprite.frame == HITBOX_END_FRAME:
		_set_hitbox_enabled(false)


func _on_hit(area: Area2D):
	emit_signal("hit")
	if area is Hitbox:
		area.receive_hit(hit_info)


func _on_state_changed(prev_state: String, new_state: String):
	if not new_state in state_machine.get_free_states():
		interrupt()


func _set_hitbox_enabled(enable: bool):
	if enable:
		var hitbox_direction: int = player.get_facing_int()
		_set_hitbox_direction(hitbox_direction)
		hitbox.set_deferred("monitoring", true)
		if shapes[current_attack] != null:
			shapes[current_attack].disabled = false
			shapes[current_attack].visible = true
	else:
		hitbox.set_deferred("monitoring", false)
		if shapes[current_attack] != null:
			shapes[current_attack].disabled = true
			shapes[current_attack].visible = false


func _set_hitbox_direction(direction: int):
	if sign(hitbox.position.x) != direction:
		hitbox.position.x *= -1
	if sign(hitbox.scale.x) != direction:
		hitbox.scale.x *= -1
