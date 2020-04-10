extends Grazebox

const DAMAGE = 1

var direction: Vector2
var move_speed: float = 100.0
var hit_info := HitInfo.new()

onready var sprite = $Sprite

func _ready():
	set_physics_process(false)
	self.connect("area_entered", self, "_on_area_entered")
	self.add_to_group("EnemyProjectiles")
	hit_info.damage = DAMAGE


func _physics_process(delta):
	self.global_position += direction * move_speed * delta


func set_direction(new_direction: Vector2) -> void:
	direction = new_direction
	set_physics_process(true)


func _on_area_entered(area: Area2D):
	if area is Hitbox:
		area.receive_hit(hit_info)
		die()


func die():
	set_physics_process(false)
	self.set_deferred("monitoring", false)
	self.set_deferred("monitorable", false)
	sprite.play("die")
	sprite.connect("animation_finished", self, "_on_death_animation_finished")


func _on_death_animation_finished():
	queue_free()
