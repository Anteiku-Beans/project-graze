extends Area2D

signal flipped

const DEFAULT_SHAPE = "Body"

var damage_zones := {}


func _ready() -> void:
	for shape in self.get_children():
		damage_zones[shape.name] = shape
	
	for damage_zone in damage_zones.values():
		if damage_zone.name != DEFAULT_SHAPE:
			damage_zone.disabled = true
			damage_zone.visible = false


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
