extends Node

var current_state = null
onready var states = {
	'idle': $Idle,
	'move': $Move,
	'jump': $Jump,
	'fall': $Fall,
	}

func _ready():
	current_state = states['idle']
	for state in states.values():
		state.connect('finished', self, '_on_state_finished')
	current_state.enter()

func _physics_process(delta):
	current_state.update(delta)

func _unhandled_input(event):
	current_state.handle_input(event)

func _on_state_finished(next_state):
	current_state.exit()
	current_state = states[next_state]
	current_state.enter()
	print('entering state: {state}'.format({'state':current_state.name}))