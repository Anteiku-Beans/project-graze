extends Area2D

signal flipped

const DAMAGE = 1

const DEFAULT_SHAPES = [
	"Body",
]

var damage_zones := {}
var hit_info = HitInfo.new()


func _ready() -> void:
	hit_info.damage = DAMAGE
	self.connect("area_entered", self, "_on_area_entered")
	
	for shape in self.get_children():
		damage_zones[shape.name] = shape
		shape.visible = false
		shape.disabled = true
	
	for shape in DEFAULT_SHAPES:
		damage_zones[shape].disabled = false
		damage_zones[shape].visible = true


func _on_area_entered(area: Area2D):
	if area is Hitbox:
		area.receive_hit(hit_info)


func enable(zone_name: String) -> void:
	assert(zone_name in damage_zones)
	damage_zones[zone_name].disabled = false
	damage_zones[zone_name].visible = true


func disable(zone_name: String) -> void:
	assert(zone_name in damage_zones)
	damage_zones[zone_name].disabled = true
	damage_zones[zone_name].visible = false


func flip(direction) -> void:
	var old_scale_x = scale.x
	
	if direction is Vector2:
		scale.x = sign(direction.x)
	elif direction is int:
		scale.x = direction
	
	if old_scale_x != scale.x:
		emit_signal("flipped")
