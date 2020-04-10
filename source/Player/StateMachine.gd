extends StateMachine

var _free_states := []

onready var hitbox = get_parent().get_node("Hitbox")

func _ready():
	for child in $Free.get_children():
		if child is State:
			_free_states.append(child.name)
	hitbox.connect("hit", self, "_on_hit")


func _on_hit(hit_info: HitInfo) -> void:
	if hit_info.damage > 0:
		transition_to("Stagger")


func transition_to(target_state_path: String, data: Dictionary = {}) -> void:
	if target_state_path == "Dash" and $Dash.is_on_cooldown():
		return
	.transition_to(target_state_path, data)


func get_free_states() -> Array:
	return _free_states
