extends State

signal finished

enum States {
	CROUCH,
	JUMP,
	LAND,
}

const Y_DIRECTION_DOWN = 1
const Y_DIRECTION_UP = -1

const VELOCITY_INITIAL = Vector2.ZERO
const JUMP_SPEED = 500.0
const GRAVITY_ACCELERATION = 1500
const MOVE_SPEED = 100.0

var velocity: Vector2
var direction_x: int
var current_state: int #see enum states

onready var manji = owner
onready var sprite = owner.get_node("Sprite")


func _ready():
	velocity = VELOCITY_INITIAL


func enter(data: Dictionary = {}) -> void:
	assert("direction" in data.keys())
	direction_x = data["direction"].x
	sprite.flip(-direction_x)
	velocity.x = direction_x * MOVE_SPEED
	velocity.y = -JUMP_SPEED
	current_state = States.CROUCH
	sprite.play("jump_crouch")
	sprite.connect("animation_finished", self, "_on_animation_finished")


func exit() -> void:
	sprite.disconnect("animation_finished", self, "_on_animation_finished")


func physics_process(delta) -> void:
	match current_state:
		States.CROUCH:
			crouch(delta)
		States.JUMP:
			jump(delta)
		States.LAND:
			land(delta)


func crouch(delta) -> void:
	pass


func jump(delta) -> void:
	velocity.y += GRAVITY_ACCELERATION * delta
	manji.move_and_slide(velocity, Vector2.UP)
	if sign(velocity.y) == Y_DIRECTION_DOWN and manji.is_on_floor():
		current_state = States.LAND
		sprite.play("jump_land")


func land(delta) -> void:
	pass


func _on_animation_finished() -> void:
	if sprite.animation == "jump_crouch":
		current_state = States.JUMP
		sprite.play("jump")
	elif sprite.animation == "jump_land":
		emit_signal("finished")
