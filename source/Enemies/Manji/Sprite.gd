extends AnimatedSprite

signal flipped

const X_RIGHT = 1
const X_LEFT = -1

const NO_ANIM_FOUND = 0.0


func get_anim_duration(anim_name: String) -> float:
	if not frames.has_animation(anim_name):
		return NO_ANIM_FOUND
	
	var num_frames := frames.get_frame_count(anim_name)
	var fps := frames.get_animation_speed(anim_name)
	return num_frames / fps


func flip(direction) -> void:
	var old_flip_h = flip_h
	
	if direction is Vector2:
		flip_h = sign(direction.x) == X_LEFT
	elif direction is int:
		flip_h = direction == X_LEFT
	
	if old_flip_h != flip_h:
		emit_signal("flipped")
