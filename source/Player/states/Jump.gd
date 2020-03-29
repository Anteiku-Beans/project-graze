extends State

const JUMP_ACCELERATION = Vector2(0, 4000)
const JUMP_DAMP = Vector2(0, 2000)
const JUMP_DIRECTION = Vector2.UP
const JUMP_MAX_SPEED = Vector2(0, 300)

var jump := Motion.new()
var is_jumping: bool

onready var free = get_parent()
onready var timer = $MaxJumpTime
onready var sprite = owner.get_node("Sprite")
onready var player = owner
onready var wall_detector = owner.get_node("WallDetector")
onready var animation = owner.get_node("Animation")


func _ready():
	jump.acceleration = JUMP_ACCELERATION
	jump.damp = JUMP_DAMP
	jump.direction = JUMP_DIRECTION
	jump.max_speed = JUMP_MAX_SPEED
	
	timer.connect("timeout", self, "_on_timer_timeout")


func enter(data: Dictionary = {}):
	free.enter(data)
	timer.start()
	is_jumping = true
	sprite.request("jump")
	wall_detector.connect("floor_entered", self, "_on_floor_entered")
	wall_detector.connect("ceiling_entered", self, "_on_ceiling_entered")
	animation.play("jump")


func physics_process(delta: float):
	free.physics_process(delta)
	
#	Calculate velocity
	if is_jumping:
		jump.velocity = jump.calculate_velocity(delta)
	else:
		jump.velocity = jump.calculate_damp(delta)
		if jump.velocity == Vector2.ZERO:
			_state_machine.transition_to("Free/Fall")
	
#	Apply movement
	var total_velocity: Vector2 = jump.velocity + free.move.velocity
	player.move_and_slide(total_velocity, Vector2.UP)


#	Transition to landing state
func _on_floor_entered():
	if free.move.velocity == Vector2.ZERO:
		_state_machine.transition_to("Free/Idle")
	else:
		_state_machine.transition_to("Free/Move")


#	Transition to Fall if you hit the ceiling
func _on_ceiling_entered():
	_state_machine.transition_to("Free/Fall")


func _on_timer_timeout():
	is_jumping = false


func unhandled_input(event):
	if event.is_action_released("jump"):
		is_jumping = false
		return
	free.unhandled_input(event)


func exit():
	timer.stop()
	wall_detector.disconnect("floor_entered", self, "_on_floor_entered")
	wall_detector.disconnect("ceiling_entered", self, "_on_ceiling_entered")
	animation.play("default")
	free.exit()
