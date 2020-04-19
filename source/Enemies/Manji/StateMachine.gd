extends StateMachine

var target: Node

onready var manji = owner

func _ready():
	if (Player.get_player() != null):
		target = Player.get_player()
	else:
		yield (Player, "player_set")
		target = Player.get_player()


func get_target_direction() -> Vector2:
	var direction_x = sign(target.global_position.x - manji.global_position.x)
	return Vector2(direction_x, 0)
