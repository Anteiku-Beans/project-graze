extends State

const DASH_SPEED_MAX = Vector2(500, 500)
const DASH_ACCELERATION = Vector2(2000, 2000)
const DAMAGE_ZONE_FRAME = 0
const DAMAGE_ZONE_NAME = "FlyingAssaulter"

var dash = Motion.new()
var is_landed: bool

onready var manji = owner
onready var sprite = owner.get_node("Sprite")
onready var damage_zone = owner.get_node("DamageZone")
onready var tween = $SpeedTween

signal landed


func _ready():
	dash.max_speed = DASH_SPEED_MAX
	dash.acceleration = DASH_ACCELERATION
	self.connect("landed", self, "_on_landed")


func enter(data: Dictionary = {}):
	assert("direction" in data.keys())
	is_landed = false
	dash.direction = calculate_dash_direction(data["direction"])
	sprite.play("flying_assaulter_dash")


func physics_process(delta) -> void:
	if not is_landed:
		dash.velocity = dash.calculate_velocity(delta)
		manji.move_and_slide(dash.velocity, Vector2.UP)
		if manji.is_on_floor():
			emit_signal("landed")


func _on_landed() -> void:
	is_landed = true
	sprite.play("flying_assaulter_land")
	sprite.connect("frame_changed", self, "_on_frame_changed")
	sprite.connect("animation_finished", self, "_on_animation_finished")
	if sprite.frame == DAMAGE_ZONE_FRAME:
		damage_zone.enable(DAMAGE_ZONE_NAME)


func _on_frame_changed() -> void:
	if sprite.frame == DAMAGE_ZONE_FRAME:
		damage_zone.enable(DAMAGE_ZONE_NAME)
	elif sprite.frame > DAMAGE_ZONE_FRAME:
		damage_zone.disable(DAMAGE_ZONE_NAME)


func _on_animation_finished() -> void:
	if sprite.animation == "flying_assaulter_land":
		_state_machine.transition_to("Walk", {"direction": Vector2.RIGHT})


func exit() -> void:
	sprite.disconnect("frame_changed", self, "_on_frame_changed")
	sprite.connect("animation_finished", self, "_on_animation_finished")


func calculate_dash_direction(direction: Vector2) -> Vector2:
	return (direction + Vector2.DOWN).normalized()
