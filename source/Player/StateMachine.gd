extends StateMachine

var _free_states := []


func _ready():
	for child in $Free.get_children():
		if child is State:
			_free_states.append(child.name)


func transition_to(target_state_path: String, data: Dictionary = {}) -> void:
	if target_state_path == "Dash" and $Dash.is_on_cooldown():
		return
	.transition_to(target_state_path, data)


func get_free_states() -> Array:
	return _free_states
