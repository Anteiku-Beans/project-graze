extends State

const GROUND_PARTICLES = preload("res://source/Effects/JumpDust/JumpDust.tscn")
const GROUND_PARTICLES_OFFSET = Vector2(0,-7)

const FACING_LEFT = -1
const FACING_RIGHT = 1

const DEFAULT_MOVE_SPEED = 180.0
const ACCELERATION_FACTOR = 12
const DAMP_FACTOR = 12

const JUMP_STOCK_MAX = 10

var move = Motion.new()
var move_speed := DEFAULT_MOVE_SPEED
var jump_stock := JUMP_STOCK_MAX

onready var sprite = owner.get_node("Sprite")
onready var attack = owner.get_node("Attack")
onready var player = owner
onready var fall = $Fall
onready var jump = $Jump
onready var ground_puff_cooldown = $GroundPuffCooldown


func _ready():
	move.acceleration = Vector2(move_speed * ACCELERATION_FACTOR, 0)
	move.damp = Vector2(move_speed * DAMP_FACTOR, 0)
	move.max_speed = Vector2(move_speed, 0)
	
	jump.connect("jump", self, "summon_ground_particles")
	fall.connect("land", self, "summon_ground_particles")


func enter(data: Dictionary = {}) -> void:
	if "motion" in data.keys():
		move.velocity = data["motion"]


func physics_process(delta):
	update_move(delta)
	player.update_facing(get_move_direction())


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
		return


func calculate_direction():
	var new_direction
	var x_input = Input.get_action_strength("right") - Input.get_action_strength("left")
	
	if x_input != 0:
		new_direction = Vector2(x_input, 0)
	else:
		new_direction = player.get_facing_vector2()
		
	return new_direction


func summon_ground_particles():
	if ground_puff_cooldown.is_stopped():
		var new_ground_particles = GROUND_PARTICLES.instance()
		get_tree().get_root().add_child(new_ground_particles)
		new_ground_particles.global_position = player.global_position
		new_ground_particles.global_position += GROUND_PARTICLES_OFFSET
		ground_puff_cooldown.start()


func use_jump_stock():
	jump_stock = max(jump_stock - 1, 0)


func replenish_jump_stock():
	jump_stock = JUMP_STOCK_MAX
