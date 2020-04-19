extends State

signal finished

const SPEED_INITIAL = 600.0
const SPEED_FINAL = 0.0
const DURATION = 0.4
const TRANSITION = Tween.TRANS_BACK
const EASE = Tween.EASE_IN

const SLASH_DAMAGE_ZONE_FRAME = 0
const DAMAGE_ZONE_NAME = "Slash"

var speed: float
var direction: Vector2
var velocity: Vector2

onready var manji = owner
onready var sprite = owner.get_node("Sprite")
onready var tween = $SpeedTween
onready var damage_zone = owner.get_node("DamageZone")


func enter(data: Dictionary = {}) -> void:
	assert("direction" in data.keys())
	direction = data["direction"]
	sprite.flip(direction)
	damage_zone.flip(direction)
	sprite.play("assaulter_start")
	tween.interpolate_property(self, "speed", SPEED_INITIAL, SPEED_FINAL, DURATION, TRANSITION, EASE)
	tween.start()
	tween.connect("tween_all_completed", self, "_on_tween_all_completed")


func _on_tween_all_completed() -> void:
	sprite.play("assaulter_slash")
	sprite.connect("animation_finished", self, "_on_animation_finished")
	sprite.connect("frame_changed", self, "_on_frame_changed")
	if sprite.frame == SLASH_DAMAGE_ZONE_FRAME:
		damage_zone.enable(DAMAGE_ZONE_NAME)


func _on_frame_changed() -> void:
	if sprite.frame == SLASH_DAMAGE_ZONE_FRAME:
		damage_zone.enable(DAMAGE_ZONE_NAME)
	elif sprite.frame > SLASH_DAMAGE_ZONE_FRAME:
		damage_zone.disable(DAMAGE_ZONE_NAME)
		sprite.disconnect("frame_changed", self, "_on_frame_changed")


func _on_animation_finished() -> void:
	emit_signal("finished")


func exit() -> void:
	tween.stop_all()
	tween.disconnect("tween_all_completed", self, "_on_tween_all_completed")
	sprite.disconnect("animation_finished", self, "_on_animation_finished")
	sprite.disconnect("frame_changed", self, "_on_frame_changed")


func physics_process(delta) -> void:
	velocity = manji.move_and_slide(speed * direction, Vector2.UP)
