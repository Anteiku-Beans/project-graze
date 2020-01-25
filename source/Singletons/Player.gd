extends Node

var player: Node

func set_player(player_reference: Node) -> void:
	player = player_reference

func get_player():
	return player