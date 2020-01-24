extends Position2D

var speed = 120.0
var angular_v = 1.5*PI
var direction: = Vector2.UP
var velocity: Vector2
var target: Node

func _ready():
	target = get_target()
	direction = random_direction()
	
func _physics_process(delta) -> void:
	var rotate_amount = get_rotate_amount(delta)
	direction = direction.rotated(rotate_amount)
	velocity = direction * speed
	move(velocity, delta)

func get_target() -> Node:
	var target_node
	for node in get_tree().get_nodes_in_group("player"):
		if node.name == "Player":
			target_node = node
			break
	return target_node

func move(move_velocity: Vector2, delta) -> void:
	self.position = self.position + move_velocity * delta

func get_rotate_amount(delta) -> float:
	var target_direction = (target.global_position - self.global_position).normalized()
	var angle_to_target = direction.angle_to(target_direction)
	var rotate_dir = sign(angle_to_target)
	var rotate_amount = min(angular_v * delta, abs(angle_to_target)) * rotate_dir
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