extends Area2D

signal got_hit

func _ready():
	self.connect("area_entered", self, "_on_area_entered")

func _on_area_entered(area: Area2D):
	if area.is_in_group("EnemyHitbox") or area.is_in_group("EnemyProjectile"):
		emit_signal("got_hit")
