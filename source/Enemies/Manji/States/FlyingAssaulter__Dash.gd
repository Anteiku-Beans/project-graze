extends Node

signal finished

const DASH_SPEED_INITIAL = 0.0
const DASH_SPEED_FINAL = 5000.0
const DASH_DURATION = 0.5
const DASH_TWEEN_TRANSITION = Tween.TRANS_QUART
const DASH_TWEEN_EASE = Tween.EASE_OUT

var direction: Vector2
var speed: float

onready var manji = owner
onready var sprite = owner.get_node("Sprite")
onready var fa = get_parent()
onready var tween = $SpeedTween


func enter() -> void:
	direction = (fa.direction + Vector2.DOWN).normalized()
	sprite.play("flying_assaulter_dash")
	tween.interpolate_property(self,
							   "speed",
							   DASH_SPEED_INITIAL,
							   DASH_SPEED_FINAL,
							   DASH_DURATION,
							   DASH_TWEEN_TRANSITION,
							   DASH_TWEEN_EASE)
	tween.start()


func physics_process(delta) -> void:
	var velocity = direction * speed
	manji.move_and_slide(velocity, Vector2.UP)
	if manji.is_on_floor():
		emit_signal("finished", "Land")


func exit() -> void:
	pass
