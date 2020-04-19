extends AnimatedSprite

const NO_ANIM_FOUND = 0.0


func get_anim_duration(anim_name: String) -> float:
	if not frames.has_animation(anim_name):
		return NO_ANIM_FOUND
	
	var num_frames := frames.get_frame_count(anim_name)
	var fps := frames.get_animation_speed(anim_name)
	return num_frames / fps
