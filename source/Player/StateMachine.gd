extends StateMachine

func transition_to(target_state_path: String, data: Dictionary = {}) -> void:
	if target_state_path == "Dash" and $Dash.is_on_cooldown():
		return
	.transition_to(target_state_path, data)
	print("New state: ", target_state_path)
