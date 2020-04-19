extends State

const DISTANCE_DEFAULT = 100.0
const MOVE_SPEED = 50.0

var distance := DISTANCE_DEFAULT
var move_velocity := Vector2.ZERO
var direction := Vector2.ZERO
var distance_travelled := 0.0

onready var manji = owner
onready var sprite = owner.get_node("Sprite")


func enter(data: Dictionary = {}) -> void:
	assert("direction" in data.keys())
	direction = data["direction"]
	if "distance" in data.keys():
		distance = data["distance"]
	sprite.play("walk")


func physics_process(delta) -> void:
	move_velocity = direction * MOVE_SPEED
	move_velocity = manji.move_and_slide(move_velocity, Vector2.UP)
	distance_travelled += MOVE_SPEED * delta
	if distance_travelled >= distance:
		_state_machine.transition_to("Slash")


func exit():
	distance_travelled = 0.0
