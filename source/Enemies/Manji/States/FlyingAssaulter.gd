extends State

signal finished

onready var phases := {}

var current_phase: Node
var direction: Vector2

onready var manji = owner
onready var damage_zone = owner.get_node("DamageZone")
onready var sprite = owner.get_node("Sprite")


func _ready() -> void:
	for child in get_children():
		phases[child.name] = child
		child.connect("finished", self, "_on_phase_finished")


func enter(data: Dictionary = {}) -> void:
	assert("direction" in data.keys())
	direction = data["direction"]
	sprite.flip(direction)
	damage_zone.flip(direction)
	current_phase = phases["Crouch"]
	current_phase.enter()


func _on_phase_finished(next_phase: String) -> void:
	current_phase.exit()
	current_phase = phases[next_phase]
	current_phase.enter()


func physics_process(delta):
	current_phase.physics_process(delta)


func finish() -> void:
	current_phase.exit()
	emit_signal("finished")
