extends Area2D

onready var player = get_parent()


func _ready():
	player.connect("facing_updated", self, "_on_facing_updated")


func _on_facing_updated():
	scale.x = player.get_facing_int()
