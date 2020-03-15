extends AnimatedSprite

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
#onready var free_state = state_machine.get_node("Free")

func _ready():
	state_machine.connect("state_changed", self, "_on_state_changed")
#	free_state.connect("facing_direction_changed", self, "_on_facing_direction_changed")

func _on_state_changed(prev_state: String, new_state: String):
	if (new_state in ANIMATIONS_MAP):
		self.play(ANIMATIONS_MAP[new_state])

func _on_facing_direction_changed(new_direction: Vector2):
	if (new_direction == Vector2.LEFT):
		self.flip_h = true
	elif (new_direction == Vector2.RIGHT):
		self.flip_h = false
