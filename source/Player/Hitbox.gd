extends Area2D

const ON_HIT_PARTICLES = preload("res://assets/effects/on_hit_particles.tscn")

signal hit

func _ready():
	self.connect("area_entered", self, "_on_area_entered")

func _on_area_entered(area: Area2D):
	if area.is_in_group("Enemies") or area.is_in_group("EnemyProjectiles"):
		emit_signal("hit")
		on_hit_particles()

func on_hit_particles() -> void:
	var new_particles = ON_HIT_PARTICLES.instance()
	self.call_deferred("add_child", new_particles)
