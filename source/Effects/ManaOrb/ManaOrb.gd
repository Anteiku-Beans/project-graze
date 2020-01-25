extends Position2D

const INITIAL_SPEED = 170.0
const FINAL_SPEED = 100.0
const TWEEN_TIME = 0.2
const ANGULAR_V = 1.5*PI

var current_phase: int = 1
var speed: = INITIAL_SPEED
var direction: Vector2
var velocity: Vector2
var target: Node

onready var hitbox = $Hitbox
onready var tween = $Tween

func _ready():
	hitbox.set_deferred("monitorable", false)
	target = Player.get_player()
	direction = random_direction()
	tween.interpolate_property(self, "speed", INITIAL_SPEED, FINAL_SPEED, TWEEN_TIME, Tween.TRANS_QUART, Tween.EASE_IN)
	tween.start()
	tween.connect("tween_all_completed", self, "_on_tween_completed")

func _physics_process(delta) -> void:
	do_phase(current_phase, delta)

func do_phase(phase_number: int, delta: float) -> void:
	match(phase_number):
		1:
			velocity = direction * speed
			move(velocity, delta)
		2:
			var rotate_amount = get_rotate_amount(delta)
			direction = direction.rotated(rotate_amount)
			velocity = direction * speed
			move(velocity, delta)
		_:
			pass

func _on_tween_completed() -> void:
	current_phase += 1
	hitbox.set_deferred("monitorable", true)

func set_angle(angle: float) -> void:
	direction = Vector2.UP.rotated(angle)

func move(move_velocity: Vector2, delta) -> void:
	self.position = self.position + move_velocity * delta

func get_rotate_amount(delta) -> float:
	var target_direction = (target.global_position - self.global_position).normalized()
	var angle_to_target = direction.angle_to(target_direction)
	var rotate_dir = sign(angle_to_target)
	var rotate_amount = min(ANGULAR_V * delta, abs(angle_to_target)) * rotate_dir
	return rotate_amount

func random_sign() -> int:
	randomize()
	return int(sign(rand_range(-1, 1)))

func random_direction() -> Vector2:
	randomize()
	var random_angle = 2*PI * randf()
	var random_direction = Vector2.ONE.rotated(random_angle)
	return random_direction

func consume() -> void:
	self.queue_free()