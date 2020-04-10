extends KinematicBody2D

var target: Node


func _ready():
	$Hitbox.connect("hit", self, "_on_hit")
	
	if (Player.get_player() != null):
		target = Player.get_player()
	else:
		yield (Player, "player_set")
		target = Player.get_player()


func _on_hit(hit_info: HitInfo):
	print("Aspid: Got hit! ({damage})".format({damage=hit_info.damage}))
