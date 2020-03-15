extends State

const MOVE_ACCELERATION = Vector2(1500, 0)
const MOVE_DAMP = Vector2(2500, 0)
const MOVE_MAX_SPEED = Vector2(120, 0)

var move = Motion.new()

onready var hitbox = owner.get_node("Hitbox")

func _ready():
	move.acceleration = MOVE_ACCELERATION
	move.damp = MOVE_DAMP
	move.max_speed = MOVE_MAX_SPEED

	hitbox.connect("hit", self, "_on_hit")

func physics_process(delta):
	update_move(delta)


func update_move(delta) -> void:
	move.direction = get_move_direction()
	if move.direction == Vector2.ZERO:
		move.velocity = move.calculate_damp(delta)
	else:
		move.velocity = move.calculate_velocity(delta)


func get_move_direction() -> Vector2:
	var x_input = Input.get_action_strength("right") - Input.get_action_strength("left")
	return Vector2(x_input, 0)


func unhandled_input(event):
	if event.is_action_pressed("dash"):
		_state_machine.transition_to("Dash", {"direction":Vector2.RIGHT})


func _on_hit():
	_state_machine.transition_to("Stagger")
