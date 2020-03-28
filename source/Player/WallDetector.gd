extends Node2D

const X_LEFT = -1
const X_RIGHT = 1
const X_NO_DIRECTION = 0

onready var player = get_parent()
onready var RightDetector = $WallDetectorRight
onready var LeftDetector = $WallDetectorLeft

signal body_entered
signal body_exited

func _ready():
	RightDetector.connect("body_entered", self, "_on_body_entered")
	LeftDetector.connect("body_entered", self, "_on_body_entered")
	RightDetector.connect("body_exited", self, "_on_body_exited")
	LeftDetector.connect("body_exited", self, "_on_body_exited")


func _on_body_entered(body: Node):
	print("body entered: ", get_wall_direction_x())
	emit_signal("body_entered", body)


func _on_body_exited(body: Node):
	print("body exited: ", get_wall_direction_x())
	emit_signal("body_exited", body)


func is_colliding() -> bool:
	var left_bodies = LeftDetector.get_overlapping_bodies()
	var right_bodies = RightDetector.get_overlapping_bodies()
	return len(left_bodies) + len(right_bodies) > 0


func get_wall_direction_x() -> int:
	var left_bodies = LeftDetector.get_overlapping_bodies()
	if len(left_bodies) > 0:
		return X_LEFT

	var right_bodies = RightDetector.get_overlapping_bodies()
	if len(right_bodies) > 0:
		return X_RIGHT
	
	return X_NO_DIRECTION


func get_wall_direction() -> Vector2:
	var left_bodies = LeftDetector.get_overlapping_bodies()
	if len(left_bodies) > 0:
		return Vector2.LEFT

	var right_bodies = RightDetector.get_overlapping_bodies()
	if len(right_bodies) > 0:
		return Vector2.RIGHT
	
	return Vector2.ZERO
