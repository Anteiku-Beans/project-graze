extends State

# Tween constants
#const I_SPEED = 1000.0
#const F_SPEED = 120.0
const MOVE_SPEED_MULTIPLIER = 5
const DASH_TIME = 0.20
const T_TRANS = Tween.TRANS_SINE
const T_EASE = Tween.EASE_IN_OUT

var i_speed: float
var f_speed: float
var speed: float
var direction: = Vector2.ZERO

onready var cooldown = $Cooldown
onready var tween = $SpeedTween
onready var free_state = owner.get_node("StateMachine/Free")
onready var sprite = owner.get_node("Sprite")
onready var animation = owner.get_node("Animation")
onready var player = owner
onready var wall_detector = owner.get_node("WallDetector")


func _ready():
	i_speed = free_state.move_speed * MOVE_SPEED_MULTIPLIER
	f_speed = free_state.move_speed
	tween.connect("tween_completed", self, "_on_tween_completed")
	

func enter(data: Dictionary = {}) -> void:
	direction = data["direction"]
	tween.interpolate_property(self, "speed", i_speed, f_speed, DASH_TIME, T_TRANS, T_EASE)
	tween.start()
	cooldown.start()
	sprite.request("dash")
	animation.play("dash")


func physics_process(delta) -> void:
	owner.move_and_slide(direction * speed, Vector2.UP)


func exit() -> void:
	tween.reset_all()
	tween.stop_all()


func _on_tween_completed(object, key) -> void:
	if owner.is_on_floor():
		_state_machine.transition_to("Free/Move", {"motion":self.direction*speed})
	elif (player.is_on_wall() and
	wall_detector.is_colliding()):
		_state_machine.transition_to("WallSlide", {"wall_direction_x":wall_detector.get_wall_direction_x()})
	else:
		_state_machine.transition_to("Free/Fall", {"motion":self.direction*speed})


func is_on_cooldown() -> bool:
	return cooldown.time_left > 0


func get_x_input():
	return Input.get_action_strength("right") - Input.get_action_strength("left")
