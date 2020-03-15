extends State

const ON_HIT_PARTICLES = preload("res://assets/effects/on_hit_particles.tscn")

onready var timer = $Timer
onready var sprite = owner.get_node("Sprite")

func enter(data: Dictionary = {}) -> void:
	timer.connect("timeout", self, "_on_timer_timeout")
	timer.start()
	on_hit_particles()
	OS.call_deferred("delay_msec", 50)
	sprite.request("stagger")

func exit() -> void:
	timer.disconnect("timeout", self, "_on_timer_timeout")

func _on_timer_timeout() -> void:
	if owner.is_on_floor():
		_state_machine.transition_to("Free/Idle")
	else:
		_state_machine.transition_to("Free/Fall")

func on_hit_particles() -> void:
	var new_particles = ON_HIT_PARTICLES.instance()
	owner.call_deferred("add_child", new_particles)
