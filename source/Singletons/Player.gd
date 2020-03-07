extends Node

var player: Node

signal player_set

func set_player(player_reference: Node) -> void:
	player = player_reference
	emit_signal("player_set")

func get_player():
	return player
