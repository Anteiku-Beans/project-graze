extends State

const FALL_SPEED_MAX = Vector2(0, 200.0)
const FALL_ACCELERATION = Vector2(0, 500.0)
const FALL_DIRECTION = Vector2.DOWN

var fall_motion = Motion.new()

onready var manji = owner
onready var sprite = owner.get_node("Sprite")


func _ready():
	fall_motion.max_speed = FALL_SPEED_MAX
	fall_motion.acceleration = FALL_ACCELERATION
	fall_motion.direction = FALL_DIRECTION


func enter(data: Dictionary = {}) -> void:
	sprite.play("jump")


func physics_process(delta):
	fall_motion.velocity = fall_motion.calculate_velocity(delta)
	manji.move_and_slide(fall_motion.velocity, Vector2.UP)
	if manji.is_on_floor():
		_state_machine.transition_to("Idle")


func exit():
	fall_motion.velocity = Vector2.ZERO
