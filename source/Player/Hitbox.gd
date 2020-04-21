extends Hitbox

signal on
signal off

const GOD_MODE_DURATION_DEFAULT = 20.0

var is_god_mode := false

onready var god_mode_timer = $GodModeTimer
onready var color_animation = owner.get_node("ColorAnimation")


func _ready():
	god_mode_timer.connect("timeout", self, "disable_god_mode")
	self.connect("hit", self, "_on_hit")


func _on_hit(hit_info: HitInfo) -> void:
	enable_god_mode()


func enable_god_mode(duration: float = GOD_MODE_DURATION_DEFAULT):
	set_deferred("monitorable", false)
	color_animation.play("blink")
	god_mode_timer.wait_time = duration
	god_mode_timer.start()
	is_god_mode = true
	emit_signal("on")


func disable_god_mode():
	if is_god_mode:
		set_deferred("monitorable", true)
		is_god_mode = false
		color_animation.play("default")
		emit_signal("off")
