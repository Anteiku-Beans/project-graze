extends State

const JUMP_SPEED_INITIAL = 300.0
const JUMP_SPEED_FINAL = 0.0
const JUMP_TRANSITION = Tween.TRANS_BACK
const JUMP_EASE = Tween.EASE_IN

onready var manji = owner
onready var sprite = owner.get_node("Sprite")
onready var tween = $SpeedTween

var jump_duration: float
var jump_speed := 0.0
var direction: Vector2


func _ready():
	jump_duration = sprite.get_anim_duration("flying_assaulter_jump")


func enter(data: Dictionary = {}) -> void:
	assert("direction" in  data.keys())
	direction = data["direction"]
	sprite.flip(direction)
	sprite.play("flying_assaulter_start")
	sprite.connect("animation_finished", self, "_on_animation_finished")
	jump_speed = 0.0


func _on_animation_finished() -> void:
	if sprite.animation == "flying_assaulter_start":
		sprite.play("flying_assaulter_jump")
		tween.interpolate_property( self,
									"jump_speed",
									JUMP_SPEED_INITIAL,
									JUMP_SPEED_FINAL,
									jump_duration,
									JUMP_TRANSITION,
									JUMP_EASE)
		tween.start()
	elif sprite.animation == "flying_assaulter_jump":
		var data = {
			"direction": self.direction,
		}
		_state_machine.transition_to("FlyingAssaulterDash", {"direction": direction})


func physics_process(delta):
	var jump_velocity = jump_speed * Vector2.UP
	manji.move_and_slide(jump_velocity, Vector2.UP)


func exit() -> void:
	tween.stop_all()
	sprite.disconnect("animation_finished", self, "_on_animation_finished")
