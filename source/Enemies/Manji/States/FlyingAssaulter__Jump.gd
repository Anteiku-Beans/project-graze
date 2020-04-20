extends Node

signal finished

const JUMP_SPEED_INITIAL = 300.0
const JUMP_SPEED_FINAL = 0.0
const JUMP_TRANSITION = Tween.TRANS_BACK
const JUMP_EASE = Tween.EASE_IN

onready var manji = owner
onready var sprite = owner.get_node("Sprite")
onready var fa = get_parent()
onready var tween = $SpeedTween

var jump_duration: float
var jump_speed := 0.0

func _ready():
	jump_duration = sprite.get_anim_duration("flying_assaulter_jump")


func enter() -> void:
	sprite.play("flying_assaulter_jump")
	sprite.connect("animation_finished", self, "_on_animation_finished")
	tween.interpolate_property( self,
									"jump_speed",
									JUMP_SPEED_INITIAL,
									JUMP_SPEED_FINAL,
									jump_duration,
									JUMP_TRANSITION,
									JUMP_EASE)
	tween.start()


func physics_process(delta) -> void:
	var jump_velocity = jump_speed * Vector2.UP
	manji.move_and_slide(jump_velocity, Vector2.UP)


func _on_animation_finished() -> void:
	emit_signal("finished", "Dash")


func exit() -> void:
	sprite.disconnect("animation_finished", self, "_on_animation_finished")


