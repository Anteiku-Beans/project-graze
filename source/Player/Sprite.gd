extends AnimatedSprite

const LEFT_2D = -1
const RIGHT_2D = 1

const ANIMATIONS_MAP = {
	"Idle": "idle",
	"Jump": "jump",
	"Fall": "fall",
	"Move": "move",
}

onready var state_machine = get_parent().get_node("StateMachine")
onready var free_state = state_machine.get_node("Free")

func _ready():
	state_machine.connect("state_changed", self, "_on_state_changed")
	free_state.connect("move_direction_changed", self, "_on_move_direction_changed")

func _on_state_changed(state: String):
	if (state in ANIMATIONS_MAP):
		self.play(ANIMATIONS_MAP[state])

func _on_move_direction_changed(direction: float):
	if (direction == LEFT_2D):
		self.flip_h = true
	elif (direction == RIGHT_2D):
		self.flip_h = false