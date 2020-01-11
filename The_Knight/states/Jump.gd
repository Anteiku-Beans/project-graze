extends "res://The_Knight/states/state.gd"

const INITIAL_SPEED = 300
const FINAL_SPEED = 0
const DURATION = 0.3
const TRANSITION = Tween.TRANS_SINE
const EASE = Tween.EASE_IN_OUT

var jump_speed = 0
var jump_velocity = Vector2()

onready var tween = $Tween

func _ready():
	tween.connect('tween_completed', self, '_on_tween_completed')

func enter():
	tween.interpolate_property(self, 'jump_speed', INITIAL_SPEED, FINAL_SPEED, DURATION, TRANSITION, EASE)
	tween.start()
	
func update(delta):
	jump_velocity = jump_speed * Global.UP
	owner.move_and_slide(jump_velocity, Global.UP)

func exit():
	tween.reset_all()

func _on_tween_completed(object, key):
	emit_signal('finished', 'fall')
	return
	