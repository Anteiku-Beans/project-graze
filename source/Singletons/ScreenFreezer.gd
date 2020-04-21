extends Node

const TIME_SCALE_MIN = 0.01
const TIME_SCALE_MAX = 1.0
const TIME_RECOVERY_RATE = 1.1


func freeze():
	Engine.time_scale = TIME_SCALE_MIN
	set_process(true)


func _ready():
	set_process(false)


func _process(delta):
	Engine.time_scale = min( Engine.time_scale * TIME_RECOVERY_RATE, TIME_SCALE_MAX)
	if Engine.time_scale == TIME_SCALE_MAX:
		set_process(false)
