extends Node

const GROUND = 0
const AIR = 1

const GROUND_DASH_ACCELERATION = Vector2(100000, 40000)
const GROUND_DASH_DAMP = Vector2(3000, 1200)
const GROUND_DASH_MAX_SPEED = Vector2(800, 320)
const AIR_DASH_MAX_SPEED = Vector2(300, 120)

var ground_dash = Motion.new()
var direction: Vector2
var _is_active := false
var _is_accelerating := false
var _is_damping := false
var _is_air := false

onready var player = get_parent()


func _ready():
	set_physics_process(false)
	ground_dash.damp = GROUND_DASH_DAMP
	ground_dash.acceleration = GROUND_DASH_ACCELERATION
	
	

func execute(type: int = GROUND) -> void:
	if not _is_active:
		_is_active = true
		_is_accelerating = true
		_is_damping = false
		ground_dash.direction = get_direction()
		set_physics_process(true)


func _end() -> void:
	if _is_active:
		_is_active = false
		_is_accelerating = false
		_is_damping = false
		_is_air = false
		set_physics_process(false)


func _physics_process(delta):
	if not player.is_on_floor():
		_is_air = true
	if _is_air:
		# Half max speed
		ground_dash.max_speed = AIR_DASH_MAX_SPEED
		ground_dash.velocity = ground_dash.calculate_velocity(delta)
		ground_dash.velocity = player.move_and_slide(ground_dash.velocity, Vector2.UP)
		if player.is_on_floor():
			_end()
	else:
		# Is on ground
		ground_dash.max_speed = GROUND_DASH_MAX_SPEED
		if _is_accelerating:
			ground_dash.velocity = ground_dash.calculate_velocity(delta)
			ground_dash.velocity = player.move_and_slide(ground_dash.velocity, Vector2.UP)
			if abs(ground_dash.velocity.x) == abs(ground_dash.max_speed.x):
				_is_accelerating = false
				_is_damping = true
			if player.is_on_wall():
				_end()
		if _is_damping:
			if player.is_on_floor():
				ground_dash.damp = GROUND_DASH_DAMP
				ground_dash.velocity = ground_dash.calculate_damp(delta)
				ground_dash.velocity = player.move_and_slide(ground_dash.velocity, Vector2.UP)
				if ground_dash.velocity == Vector2.ZERO:
					_end()


func get_direction() -> Vector2:
	var x_input = Input.get_action_strength("right") - Input.get_action_strength("left")
	var new_direction: Vector2
	
	if x_input != 0:
		new_direction = Vector2(x_input, 0)
	else:
		new_direction = player.get_facing_vector2()
	
	return new_direction
