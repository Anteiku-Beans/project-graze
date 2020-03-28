extends State

const JUMP_ACCELERATION = Vector2(0, 3000)
const JUMP_DAMP = Vector2(0, 2000)
const JUMP_DIRECTION = Vector2.UP
const JUMP_MAX_SPEED = Vector2(0, 350)

const REBOUND_VELOCITY_INITIAL = Vector2(1000, 0)
const REBOUND_DAMP = Vector2(8000, 0)

var jump := Motion.new()
var rebound := Motion.new()
var is_jumping: bool

onready var free = get_parent()
onready var timer = $MaxJumpTime
onready var sprite = owner.get_node("Sprite")
onready var player = owner
onready var wall_detector = owner.get_node("WallDetector")


func _ready():
	jump.acceleration = JUMP_ACCELERATION
	jump.damp = JUMP_DAMP
	jump.max_speed = JUMP_MAX_SPEED
	jump.direction = JUMP_DIRECTION
	
	rebound.damp = REBOUND_DAMP
	
	timer.connect("timeout", self, "_on_timer_timeout")


func enter(data: Dictionary = {}):
	free.enter(data)
	sprite.request("jump")
	
	assert("direction" in data.keys())
	rebound.direction = data["direction"]
	rebound.velocity = REBOUND_VELOCITY_INITIAL * rebound.direction
	
	jump.velocity = Vector2.ZERO
	
	is_jumping = true
	timer.start()
	
	
func physics_process(delta: float):
	free.physics_process(delta)
	
#	Calculate jump velocity
	if is_jumping:
		jump.velocity = jump.calculate_velocity(delta)
	else:
		jump.velocity = jump.calculate_damp(delta)
		if jump.velocity == Vector2.ZERO:
			_state_machine.transition_to("Free/Fall")
	
#	Calculate rebound velocity
	rebound.velocity = rebound.calculate_damp(delta)
	
#	Apply movement
	var total_velocity = jump.velocity + free.move.velocity + rebound.velocity
	owner.move_and_slide(total_velocity, Vector2.UP)
	
#	Transition to landing state
	if wall_detector.is_on_floor():
		if free.move.velocity == Vector2.ZERO:
			_state_machine.transition_to("Free/Idle")
		else:
			_state_machine.transition_to("Free/Move")


func _on_timer_timeout():
	is_jumping = false


func unhandled_input(event):
	if event.is_action_released("jump"):
		is_jumping = false
		return
	free.unhandled_input(event)


func exit():
	timer.stop()
	free.exit()
