extends State

# Tween export variables
export(float) var t_initial = 1000.0
export(float) var t_final = 0.0
export(float, 0.0, 1.0, 0.02) var t_duration = 0.3
export(int, "TRANS_LINEAR", "TRANS_SINE", "TRANS_QUINT", "TRANS_QUART", "TRANS_QUAD", "TRANS_EXPO", "TRANS_ELASTIC", "TRANS_CUBIC", "TRANS_CIRC", "TRANS_BOUNCE", "TRANS_BACK") var t_trans
export(int, "EASE_IN", "EASE_OUT", "EASE_IN_OUT", "EASE_OUT_IN") var t_ease

var jump_speed: = 0.0
var jump_velocity: = Vector2.ZERO
var move_velocity: = Vector2.ZERO
var tween_complete: = false

onready var free = get_parent()
onready var tween = $jumpSpeedTween
onready var timer = $holdTimer

func _ready():
	tween.connect("tween_completed", self, '_on_tween_completed')
	timer.connect("timeout", self, "_on_timer_timeout")

func enter(data: Dictionary = {}) -> void:
	free.enter()
	tween.interpolate_property(self, 'jump_speed', t_initial, t_final,
							   t_duration, t_trans, t_ease)
	tween.start()

func physics_process(delta: float) -> void:
	jump_velocity = Vector2.UP * jump_speed
	move_velocity = free.calculate_move_velocity()
	free.velocity = jump_velocity + move_velocity
	owner.move_and_slide(free.velocity, Vector2.UP)
	
	
func exit():
	tween.reset_all()
	tween_complete = false
	timer.stop()
	free.exit()

func unhandled_input(event: InputEvent) -> void:
	# handle input
	free.unhandled_input(event)

func _on_tween_completed(object: Object, key: NodePath) -> void:
	print('tween completed')
	tween_complete = true
	timer.start()

func _on_timer_timeout() -> void:
	print('timer compelted')
	_state_machine.transition_to('Free/Fall')