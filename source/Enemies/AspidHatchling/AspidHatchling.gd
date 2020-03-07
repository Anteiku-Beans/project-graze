extends KinematicBody2D

var target: Node

func _ready():
	if (Player.get_player() != null):
		target = Player.get_player()
	else:
		yield (Player, "player_set")
		target = Player.get_player()
