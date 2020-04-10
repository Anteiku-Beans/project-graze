extends State

const JUMP_ACCELERATION = Vector2(0, 8000)
const JUMP_DAMP = Vector2(0, 2000)
const JUMP_DIRECTION = Vector2.UP
const JUMP_MAX_SPEED = Vector2(0, 300)

var jump := Motion.new()
var is_jumping: bool
var is_jump_released: bool

onready var free = get_parent()
onready var sprite = owner.get_node("Sprite")
onready var player = owner
onready var wall_detector = owner.get_node("WallDetector")
onready var animation = owner.get_node("Animation")
onready var timer = $Timer


func _ready():
	jump.acceleration = JUMP_ACCELERATION
	jump.damp = JUMP_DAMP
	jump.direction = JUMP_DIRECTION
	jump.max_speed = JUMP_MAX_SPEED
	timer.connect("timeout", self, "_on_timer_timeout")


func enter(data: Dictionary = {}):
	free.enter(data)
	free.replenish_jump_stock()
	is_jumping = true
	is_jump_released = false
	wall_detector.connect("floor_entered", self, "_on_floor_entered")
	wall_detector.connect("ceiling_entered", self, "_on_ceiling_entered")
	sprite.request("poggo")
	timer.start()


func exit():
	wall_detector.disconnect("floor_entered", self, "_on_floor_entered")
	wall_detector.disconnect("ceiling_entered", self, "_on_ceiling_entered")
	timer.stop()
	free.exit()


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


func _on_timer_timeout():
	is_jumping = false


func _on_floor_entered():
	if free.move.velocity == Vector2.ZERO:
		_state_machine.transition_to("Free/Idle")
	else:
		_state_machine.transition_to("Free/Move")


func _on_ceiling_entered():
	_state_machine.transition_to("Free/Fall")


func unhandled_input(event):
	if event.is_action_pressed("jump") and free.jump_stock > 0:
		_state_machine.transition_to("Free/Jump")
		return
	free.unhandled_input(event)
