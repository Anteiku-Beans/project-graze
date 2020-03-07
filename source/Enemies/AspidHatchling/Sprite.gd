extends AnimatedSprite

const LEFT = -1
const RIGHT = 1
const TO_FLIP = {
	LEFT: false,
	RIGHT: true
}

func _physics_process(delta):
	var target_position = owner.target.global_position
	self.flip_h = TO_FLIP[get_direction_x_to(target_position)]

func get_direction_x_to(target_position: Vector2) -> int:
	var vector_to = target_position - owner.global_position
	if vector_to.x > 0:
		return RIGHT
	else:
		return LEFT
