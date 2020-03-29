extends State

const PARTICLES_OFFSET = Vector2(0, -9)
const PARTICLES_TEXTURE_LEFT = preload("res://assets/effects/wall_slide/wall_slide_particles_left.png")
const PARTICLES_TEXTURE_RIGHT = preload("res://assets/effects/wall_slide/wall_slide_particles_right.png")

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
onready var wall_slide_particles = owner.get_node("WallSlideParticles")


func _ready():
	fall.acceleration = FALL_ACCELERATION
	fall.max_speed = FALL_SPEED_MAX
	fall.direction = FALL_DIRECTION
	
	wall_slide_particles.emitting = false
	wall_slide_particles.position += PARTICLES_OFFSET


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
	
	if wall_direction_x == X_LEFT:
		wall_slide_particles.texture = PARTICLES_TEXTURE_LEFT
	else: 
		wall_slide_particles.texture = PARTICLES_TEXTURE_RIGHT
	wall_slide_particles.emitting = true

func physics_process(delta):
	fall.velocity = fall.calculate_velocity(delta)
	player.move_and_slide(fall.velocity, Vector2.UP)
	
	if wall_detector.is_on_floor():
		_state_machine.transition_to("Free/Idle")


func exit():
	wall_detector.disconnect("wall_exited", self, "_on_wall_exited")
	animation.play("default")
	wall_slide_particles.emitting = false


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
