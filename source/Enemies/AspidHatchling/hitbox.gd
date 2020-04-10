extends Hitbox

const DAMAGE = 1
var hit_info := HitInfo.new()


func _ready():
	hit_info.damage = DAMAGE
	self.connect("area_entered", self, "_on_area_entered")


func _on_area_entered(area: Area2D):
	if area is Hitbox:
		area.receive_hit(hit_info)
