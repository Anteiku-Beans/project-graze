extends Node2D

const LEFT_X = -1
const RIGHT_X = 1
const NO_DIRECTION_X = 0

onready var player = get_parent()
onready var wall_detector_right = $WallDetectorRight
onready var wall_detector_left = $WallDetectorLeft
onready var floor_detector = $FloorDetector
onready var ceiling_detector = $CeilingDetector

signal wall_entered
signal wall_exited
signal floor_entered
signal floor_exited
signal ceiling_entered
signal ceiling_exited


func _ready():
	wall_detector_right.connect("body_entered", self, "_on_wall_entered_right")
	wall_detector_left.connect("body_entered", self, "_on_wall_entered_left")
	wall_detector_right.connect("body_exited", self, "_on_wall_exited_right")
	wall_detector_left.connect("body_exited", self, "_on_wall_exited_left")
	floor_detector.connect("body_entered", self, "_on_floor_entered")
	floor_detector.connect("body_exited", self, "_on_floor_exited")
	ceiling_detector.connect("body_entered", self, "_on_ceiling_entered")
	ceiling_detector.connect("body_exited", self, "_on_ceiling_exited")


func _on_wall_entered_right(body: Node):
	emit_signal("wall_entered", RIGHT_X)


func _on_wall_entered_left(body: Node):
	emit_signal("wall_entered", LEFT_X)


func _on_wall_exited_right(body: Node):
	emit_signal("wall_exited", RIGHT_X)


func _on_wall_exited_left(body: Node):
	emit_signal("wall_exited", LEFT_X)
	

func _on_floor_entered(body: Node):
	emit_signal("floor_entered")


func _on_floor_exited(body: Node):
	emit_signal("floor_exited")


func _on_ceiling_entered(body: Node):
	emit_signal("ceiling_entered")


func _on_ceiling_exited(body: Node):
	emit_signal("ceiling_exited")


func is_on_wall() -> bool:
	var left_bodies = wall_detector_left.get_overlapping_bodies()
	var right_bodies = wall_detector_right.get_overlapping_bodies()
	return len(left_bodies) + len(right_bodies) > 0


func is_on_floor() -> bool:
	var floor_bodies = floor_detector.get_overlapping_bodies()
	return len(floor_bodies) > 0


func is_on_ceiling() -> bool:
	var ceiling_bodies = ceiling_detector.get_overlapping_bodies()
	return len(ceiling_bodies) > 0


func get_wall_direction_x() -> int:
	var left_bodies = wall_detector_left.get_overlapping_bodies()
	if len(left_bodies) > 0:
		return LEFT_X

	var right_bodies = wall_detector_right.get_overlapping_bodies()
	if len(right_bodies) > 0:
		return RIGHT_X
	
	return NO_DIRECTION_X


func get_wall_direction() -> Vector2:
	var left_bodies = wall_detector_left.get_overlapping_bodies()
	if len(left_bodies) > 0:
		return Vector2.LEFT

	var right_bodies = wall_detector_right.get_overlapping_bodies()
	if len(right_bodies) > 0:
		return Vector2.RIGHT
	
	return Vector2.ZERO
