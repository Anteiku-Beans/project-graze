extends AnimationPlayer

#const ANIMATIONS_MAP = {
#	"Idle": "stop",
#	"Jump": "jump",
#	"Fall": "fall",
#	"Move": "move",
#}
#
#onready var state_machine = get_parent().get_node("StateMachine")
#onready var free_state = state_machine.get_node("Free")
#
#func _ready():
#	state_machine.connect("state_changed", self, "_on_state_changed")
#
#func _on_state_changed(prev_state: String, new_state: String):
#	if (new_state in ANIMATIONS_MAP):
#		self.play(ANIMATIONS_MAP[new_state])
