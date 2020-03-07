extends State

const MOVE_SPEED: = 14.0
const SHOOT_DISTANCE = 150.0
const OFFSET = Vector2(100, -75)

var direction: Vector2
var destination: Vector2
var offset: Vector2

onready var timer = $Timer

func _ready() -> void:
	timer.connect("timeout", self, "_on_timer_timeout")

func enter(data: Dictionary = {}) -> void:
	calculate_offset(owner.target.global_position)
	owner.get_node("Sprite").play("idle")
	timer.wait_time = randf()*2 + 1.0
	timer.start()

func physics_process(delta) -> void:
	destination = owner.target.global_position + offset
	direction = direction_to(destination)
	owner.move_and_slide(direction * MOVE_SPEED * delta, Vector2.UP)

func _on_timer_timeout() -> void:
	if distance_to(owner.target.global_position) <= SHOOT_DISTANCE:
		_state_machine.transition_to("Shoot")

func direction_to(target_position: Vector2) -> Vector2:
	var direction: Vector2 = target_position - owner.global_position
	return direction

func distance_to(target_position: Vector2) -> float:
	var distance: float = (target_position - owner.global_position).length()
	return distance

func calculate_offset(location: Vector2):
	offset = OFFSET
	if location.x - owner.global_position.x > 0:
		offset.x *= -1
