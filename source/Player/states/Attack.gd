extends State

const BULLET = preload("res://source/Player/Bullet.tscn")

func enter(data: Dictionary = {}):
	spawn_bullet()
	owner.get_node("Sprite").connect("animation_finished", self, "_on_animation_finished")

func exit():
	owner.get_node("Sprite").disconnect("animation_finished", self, "_on_animation_finished")

func spawn_bullet():
	var new_bullet = BULLET.instance()
	var bullet_direction: Vector2 = Vector2.RIGHT
	get_tree().get_root().call_deferred("add_child", new_bullet)
	new_bullet.set_deferred("global_position", owner.global_position) 
	new_bullet.call_deferred("set_direction", bullet_direction)

func _on_animation_finished():
	_state_machine.transition_to("Free/Idle")
