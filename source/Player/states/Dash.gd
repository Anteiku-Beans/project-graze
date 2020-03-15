extends State

# Tween constants
const I_SPEED = 1000.0
const F_SPEED = 100.0
const DASH_TIME = 0.2
const T_TRANS = Tween.TRANS_EXPO
const T_EASE = Tween.EASE_IN_OUT

var speed: float
var direction: = Vector2.ZERO

onready var cooldown = $Cooldown
onready var tween = $SpeedTween
onready var sprite = owner.get_node("Sprite")

func _ready():
	tween.connect("tween_completed", self, "_on_tween_completed")

func enter(data: Dictionary = {}) -> void:
	direction = data["direction"]
	tween.interpolate_property(self, "speed", I_SPEED, F_SPEED, DASH_TIME, T_TRANS, T_EASE)
	tween.start()
	cooldown.start()
	sprite.request("dash")

func physics_process(delta) -> void:
	owner.move_and_slide(direction * speed, Vector2.UP)

func exit() -> void:
	tween.reset_all()
	tween.stop_all()

func _on_tween_completed(object, key) -> void:
	if owner.is_on_floor():
		_state_machine.transition_to("Free/Idle")
	else:
		_state_machine.transition_to("Free/Fall")

func is_on_cooldown() -> bool:
	return cooldown.time_left > 0
