extends Node

var max_hp: int = 75
var current_hp: int

onready var hitbox = owner.get_node("Hitbox")

signal dead
signal hp_updated # for UI purposes


func _ready() -> void:
	current_hp = max_hp
	hitbox.connect("hit", self, "_on_hit")


func _on_hit(hit_info: HitInfo) -> void:
	take_damage(hit_info.damage)


func take_damage(amount: int) -> void:
	current_hp = max(0, current_hp - amount)
	if current_hp == 0:
		emit_signal("dead")


func heal(amount) -> void:
	current_hp = min(max_hp, current_hp + amount)
