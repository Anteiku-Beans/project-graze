extends State

signal finished

const DURATION_DEFAULT = 2.0

var duration := DURATION_DEFAULT

onready var manji = owner
onready var sprite = owner.get_node("Sprite")
onready var timer = $Timer


func _ready() -> void:
	timer.connect("timeout", self, "_on_timer_timeout")


func _on_timer_timeout() -> void:
	emit_signal("finished")


func enter(data: Dictionary = {}) -> void:
	if "duration" in data.keys():
		duration = data["duration"]
	else:
		duration = DURATION_DEFAULT
	sprite.play("idle")
	timer.wait_time = duration
	timer.start()


func exit() -> void:
	timer.stop()
