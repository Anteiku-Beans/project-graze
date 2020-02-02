extends AnimatedSprite

const ANIMATIONS_MAP = {
	"Idle": "ss_idle",
	"Jump": "jump",
	"Fall": "fall",
	"Move": "ss_run",
}

onready var state_machine = get_parent().get_node("StateMachine")
onready var free_state = state_machine.get_node("Free")

func _ready():
	state_machine.connect("state_changed", self, "_on_state_changed")
	free_state.connect("facing_direction_changed", self, "_on_facing_direction_changed")

func _on_state_changed(state: String):
	if (state in ANIMATIONS_MAP):
		self.play(ANIMATIONS_MAP[state])

func _on_facing_direction_changed(new_direction: Vector2):
	if (new_direction == Vector2.LEFT):
		self.flip_h = true
	elif (new_direction == Vector2.RIGHT):
		self.flip_h = false
