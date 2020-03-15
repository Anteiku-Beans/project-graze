extends State

const FACING_LEFT = -1
const FACING_RIGHT = 1

const MOVE_ACCELERATION = Vector2(1500, 0)
const MOVE_DAMP = Vector2(2500, 0)
const MOVE_MAX_SPEED = Vector2(120, 0)

var move = Motion.new()

onready var hitbox = owner.get_node("Hitbox")
onready var sprite = owner.get_node("Sprite")
onready var attack = owner.get_node("Attack")


func _ready():
	move.acceleration = MOVE_ACCELERATION
	move.damp = MOVE_DAMP
	move.max_speed = MOVE_MAX_SPEED

	hitbox.connect("hit", self, "_on_hit")

func physics_process(delta):
	update_move(delta)
	owner.update_facing(get_move_direction())


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
		var dash_direction = calculate_direction()
		_state_machine.transition_to("Dash", {"direction":dash_direction})
		return
	if event.is_action_pressed("attack"):
		attack.execute()


func _on_hit():
	_state_machine.transition_to("Stagger")


func calculate_direction():
	var new_direction
	var x_input = Input.get_action_strength("right") - Input.get_action_strength("left")
	
	if x_input != 0:
		new_direction = Vector2(x_input, 0)
	else:
		new_direction = owner.get_facing_vector2()
		
	return new_direction
