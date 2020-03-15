extends AnimatedSprite

const FACING_LEFT = -1
const FACING_RIGHT = 1

const ANIMATIONS_MAP = {
	"Idle": "idle",
	"Jump": "jump",
	"Fall": "fall",
	"Move": "move",
	"Dash": "dash",
	"Attack": "attack",
	"Stagger": "stagger",
}

onready var state_machine = get_parent().get_node("StateMachine")
onready var player = get_parent()
#onready var free_state = state_machine.get_node("Free")

func _ready():
	state_machine.connect("state_changed", self, "_on_state_changed")
#	free_state.connect("facing_direction_changed", self, "_on_facing_direction_changed")
	owner.connect("facing_updated", self, "_on_facing_updated")

func _on_state_changed(prev_state: String, new_state: String):
	if (new_state in ANIMATIONS_MAP):
		self.play(ANIMATIONS_MAP[new_state])

func _on_facing_updated():
	var player_direction = player.get_facing_int()
	if (player_direction == FACING_LEFT):
		self.flip_h = true
	elif (player_direction == FACING_RIGHT):
		self.flip_h = false
