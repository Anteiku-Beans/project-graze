extends GrazeableHitbox

var direction: Vector2
var move_speed: float = 100.0

func _ready():
	set_physics_process(false)
	self.connect("body_entered", self, "_on_body_entered")

func _physics_process(delta):
	self.global_position += direction * move_speed * delta

func set_direction(new_direction: Vector2) -> void:
	direction = new_direction
	set_physics_process(true)

func _on_body_entered(body):
	die()

func die():
	set_physics_process(false)
	self.monitoring = false
	self.monitorable = false
	$Sprite.play("die")
	$Sprite.connect("animation_finished", self, "_on_death_animation_finished")

func _on_death_animation_finished():
	queue_free()
