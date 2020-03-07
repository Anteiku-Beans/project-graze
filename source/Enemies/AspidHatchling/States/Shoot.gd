extends State

const BULLET = preload("res://source/Enemies/AspidHatchling/Bullet.tscn")

func enter(data: Dictionary = {}) -> void:
	owner.get_node("Sprite").play("shoot")
	owner.get_node("Sprite").connect("animation_finished", self, "_on_animation_finished")

func exit() -> void:
	owner.get_node("Sprite").disconnect("animation_finished", self, "_on_animation_finished")

func _on_animation_finished() -> void:
	spawn_bullet()
	_state_machine.transition_to("Approach")

func spawn_bullet() -> void:
	var new_bullet = BULLET.instance()
	var bullet_direction: Vector2 = (owner.target.global_position - owner.global_position).normalized()
	get_tree().get_root().call_deferred("add_child", new_bullet)
	new_bullet.set_deferred("global_position", owner.global_position) 
	new_bullet.call_deferred("set_direction", bullet_direction)
