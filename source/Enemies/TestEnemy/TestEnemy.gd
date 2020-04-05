extends KinematicBody2D

onready var hitbox = $Hitbox


func _ready():
	hitbox.set_type(Hitbox.TYPE.enemy)
	hitbox.add_hit_mask(Hitbox.TYPE.player)
	hitbox.connect("hit", self, "_on_hit")


func _on_hit(hit_info):
	print("TestEnemy: I've been hit!'")
	print("TestEnemy: Hit info: ", hit_info.get_info())
