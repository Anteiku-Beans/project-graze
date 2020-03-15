extends AnimatedSprite

const FACING_LEFT = -1
const FACING_RIGHT = 1
const DEFAULT_ANIMATION = "idle"
const NO_ANIMATION = ""

var _base_animation: String = DEFAULT_ANIMATION
var _priority_animation: String = NO_ANIMATION

onready var player = get_parent()


func _ready():
	owner.connect("facing_updated", self, "_on_facing_updated")


func request(anim_name: String, priority: bool = false):
	if priority:
		_priority_animation = anim_name
		play(_priority_animation)
		self.connect("animation_finished", self, "_on_animation_finished")
	elif _priority_animation == NO_ANIMATION:
		_base_animation = anim_name
		play(_base_animation)
	else:
		_base_animation = anim_name


func _on_animation_finished():
	if _priority_animation == NO_ANIMATION:
		return
	else:
		_priority_animation = NO_ANIMATION
		play(_base_animation)
		self.disconnect("animation_finished", self, "_on_animation_finished")


func _on_facing_updated():
	var player_direction = player.get_facing_int()
	if (player_direction == FACING_LEFT):
		self.flip_h = true
	elif (player_direction == FACING_RIGHT):
		self.flip_h = false
