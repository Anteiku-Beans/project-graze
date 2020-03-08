extends Area2D

signal hit

func _ready():
	self.connect("area_entered", self, "_on_area_entered")

func _on_area_entered(area: Area2D):
	if area.is_in_group("Enemies") or area.is_in_group("EnemyProjectiles"):
		emit_signal("hit")


