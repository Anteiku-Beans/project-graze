extends State

const X_LEFT = -1
const X_RIGHT = 1

const FALL_MAX_SPEED_DEFAULT = Vector2(0, 50)
const FALL_MAX_SPEED_FAST = Vector2(0, 1000)
const FALL_ACCELERATION = Vector2(0, 1000)
const FALL_DIRECTION = Vector2.DOWN

var fall = Motion.new()

onready var sprite = owner.get_node("Sprite")
onready var wall_detector = owner.get_node("WallDetector")


func _ready():
	fall.acceleration = FALL_ACCELERATION
	fall.max_speed = FALL_MAX_SPEED_DEFAULT
	fall.direction = FALL_DIRECTION


func _on_wall_detector_body_exited(body: Node):
	_state_machine.transition_to("Free/Fall")


func enter(data: Dictionary = {}):
	sprite.request("wall_slide")
	wall_detector.connect("body_exited", self, "_on_wall_detector_body_exited")


func physics_process(delta):
	fall.velocity = fall.calculate_velocity(delta)
	owner.move_and_slide(fall.velocity, Vector2.UP)


func exit():
	wall_detector.disconnect("body_exited", self, "_on_wall_detector_body_exited")


func unhandled_input(event):
	if event.is_action_pressed("down"):
		_state_machine.transition_to("Free/Fall")
		return
