extends State

# Tween constants
const I_SPEED = 1000.0
const F_SPEED = 0.0
const DASH_TIME = 0.5
const T_TRANS = Tween.TRANS_EXPO
const T_EASE = Tween.EASE_OUT

var speed: float
var direction: = Vector2.ZERO

onready var tween = $SpeedTween

func enter(data: Dictionary = {}) -> void:
	direction = data["direction"]
	tween.interpolate_property(self, "speed", I_SPEED, F_SPEED, DASH_TIME, T_TRANS, T_EASE)
	tween.start()
	tween.connect("tween_all_completed", self, "_on_tween_completed")

func physics_process(delta) -> void:
	owner.move_and_slide(direction * speed, Vector2.UP)

func _on_tween_completed() -> void:
	if owner.is_on_floor():
		_state_machine.transition_to("Free/Idle")
	else:
		_state_machine.transition_to("Free/Fall")