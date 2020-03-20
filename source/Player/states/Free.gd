extends State

const FACING_LEFT = -1
const FACING_RIGHT = 1

const DEFAULT_MOVE_SPEED = 180.0
const ACCELERATION_FACTOR = 12
const DAMP_FACTOR = 12

var move = Motion.new()
var move_speed: float = DEFAULT_MOVE_SPEED

onready var hitbox = owner.get_node("Hitbox")
onready var sprite = owner.get_node("Sprite")
onready var attack = owner.get_node("Attack")


func _ready():
	move.acceleration = Vector2(move_speed * ACCELERATION_FACTOR, 0)
	move.damp = Vector2(move_speed * DAMP_FACTOR, 0)
	move.max_speed = Vector2(move_speed, 0)

	hitbox.connect("hit", self, "_on_hit")


func enter(data: Dictionary = {}) -> void:
	if "motion" in data.keys():
		move.velocity = data["motion"]


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
