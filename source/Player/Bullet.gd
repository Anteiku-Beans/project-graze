extends GrazeableHitbox

var direction: Vector2
var move_speed: float = 200.0

func _ready():
	set_physics_process(false)

func _physics_process(delta):
	self.global_position += direction * move_speed * delta

func set_direction(new_direction: Vector2) -> void:
	direction = new_direction
	set_physics_process(true)
