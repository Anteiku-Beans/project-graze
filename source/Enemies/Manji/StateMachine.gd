extends StateMachine

const STATE_KEY_INITIAL = -1

var target: Node

var state_cycle = [
	"idle",
	"walk_towards",
	"slash",
	"walk_away",
	"assaulter",
	"assaulter",
	"assaulter",
	"jump_back",
	"flying_assaulter",
]

var current_state_key := STATE_KEY_INITIAL

onready var manji = owner

func _ready():
	if (Player.get_player() != null):
		target = Player.get_player()
	else:
		yield (Player, "player_set")
		target = Player.get_player()
	
	for node in get_children():
		if node is State:
			node.connect("finished", self, "_on_state_finished")


func _on_state_finished():
	current_state_key = (current_state_key + 1) % len(state_cycle)
	self.call(state_cycle[current_state_key])


func idle():
	var data = {
		"duration": 1.0
	}
	transition_to("Idle", data)


func flying_assaulter() -> void:
	var data = {
		"direction": get_target_direction()
	}
	transition_to("FlyingAssaulter", data)


func walk_towards() -> void:
	var data = {
		"direction": get_target_direction()
	}
	transition_to("Walk", data)


func walk_away() -> void:
	var data = {
		"direction": -get_target_direction(),
		"backwards": true
	}
	transition_to("Walk", data)


func slash() -> void:
	var data = {
		"direction": get_target_direction()
	}
	transition_to("Slash", data)


func assaulter() -> void:
	var data = {
		"direction": get_target_direction()
	}
	transition_to("Assaulter", data)


func jump_back() -> void:
	var data = {
		"direction": -get_target_direction()
	}
	transition_to("JumpBack", data)


func get_target_direction() -> Vector2:
	var direction_x = sign(target.global_position.x - manji.global_position.x)
	return Vector2(direction_x, 0)
