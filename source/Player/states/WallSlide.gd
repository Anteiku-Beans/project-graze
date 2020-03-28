extends State

const X_LEFT = -1
const X_RIGHT = 1

const FALL_SPEED_MAX = Vector2(0, 50)
const FALL_ACCELERATION = Vector2(0, 300)
const FALL_DIRECTION = Vector2.DOWN

var fall = Motion.new()
var wall_direction_str: String
var wall_direction_opposite_str: String
var wall_direction_x: int

onready var player = owner
onready var sprite = owner.get_node("Sprite")
onready var wall_detector = owner.get_node("WallDetector")
onready var animation = owner.get_node("Animation")


func _ready():
	fall.acceleration = FALL_ACCELERATION
	fall.max_speed = FALL_SPEED_MAX
	fall.direction = FALL_DIRECTION


func _on_wall_exited(direction_x: int):
	_state_machine.transition_to("Free/Fall")


func enter(data: Dictionary = {}):
	assert("wall_direction_x" in data.keys())
	wall_direction_x = data["wall_direction_x"]
	wall_direction_str = "right" if wall_direction_x == 1 else "left"
	wall_direction_opposite_str = "right" if wall_direction_str == "left" else "left"
	sprite.request("wall_slide")
	wall_detector.connect("wall_exited", self, "_on_wall_exited")
	animation.play("wall_slide")


func physics_process(delta):
	fall.velocity = fall.calculate_velocity(delta)
	player.move_and_slide(fall.velocity, Vector2.UP)
	
	if wall_detector.is_on_floor():
		_state_machine.transition_to("Free/Idle")


func exit():
	wall_detector.disconnect("wall_exited", self, "_on_wall_exited")


func unhandled_input(event):
	if event.is_action_pressed("down"):
		_state_machine.transition_to("Free/Fall")
		return
	if event.is_action_pressed("jump"):
		var wall_jump_direction := Vector2(-wall_direction_x, 0)
		_state_machine.transition_to("Free/WallJump", {"direction":wall_jump_direction})
		return
	if event.is_action_pressed("dash"):
		var dash_direction = Vector2(-wall_direction_x, 0)
		_state_machine.transition_to("Dash", {"direction":dash_direction})
		return
	if event.is_action_pressed(wall_direction_opposite_str):
		_state_machine.transition_to("Free/Fall")
		return
