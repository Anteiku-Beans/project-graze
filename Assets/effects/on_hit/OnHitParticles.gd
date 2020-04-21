extends Position2D

const MIN_ANGLE = 20
const MAX_ANGLE = 45


func _ready():
	$right.emitting = true
	$left.emitting = true
	$timer.wait_time = $right.lifetime
	$timer.connect("timeout", self, "_on_timer_timeout")
	randomize_rotation()


func _on_timer_timeout():
	self.queue_free()


func randomize_rotation():
	self.rotation = random_sign() * random_angle_rad(MIN_ANGLE, MAX_ANGLE)


func random_sign() -> int:
	return int(sign(rand_range(-1,1)))


func random_angle_rad(min_angle, max_angle) -> float:
	return deg2rad(rand_range(min_angle, max_angle))
