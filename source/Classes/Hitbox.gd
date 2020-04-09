extends Area2D

class_name Hitbox

signal hit


func receive_hit(hit_info):
	emit_signal("hit", hit_info)


func get_position() -> Vector2:
	return self.global_position
