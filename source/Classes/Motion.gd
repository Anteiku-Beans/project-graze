extends Resource

class_name Motion

const ACCELERATION_DEFAULT = Vector2.ZERO
const DIRECTION_DEFAULT = Vector2.ZERO
const MAX_SPEED_DEFAULT = Vector2(999000, 999000)
const VELOCITY_DEFAULT = Vector2.ZERO
const DAMP_DEFAULT = Vector2.ZERO

var acceleration: Vector2 = ACCELERATION_DEFAULT
var damp: Vector2 = DAMP_DEFAULT
var direction: Vector2 = DIRECTION_DEFAULT
var max_speed: Vector2 = MAX_SPEED_DEFAULT
var velocity: Vector2 = VELOCITY_DEFAULT

func calculate_velocity(delta):
	var new_velocity: Vector2 = velocity
	
	new_velocity += direction * acceleration * delta
	new_velocity.x = clamp(new_velocity.x, -max_speed.x, max_speed.x)
	new_velocity.y = clamp(new_velocity.y, -max_speed.y, max_speed.y)

	return new_velocity

func calculate_damp(delta):
	var new_velocity: Vector2 = velocity
	
	new_velocity.x += -sign(velocity.x) * damp.x * delta
	new_velocity.y += -sign(velocity.y) * damp.y * delta
	
	if sign(velocity.x) != sign(new_velocity.x):
		new_velocity.x = 0
	
	if sign(velocity.y) != sign(new_velocity.y):
		new_velocity.y = 0

	return new_velocity
