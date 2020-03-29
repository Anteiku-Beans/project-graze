extends State

#const GROUND_PARTICLES = preload("res://source/Effects/MoveGroundParticles/MoveGroundParticles.tscn")
const GROUND_PARTICLES_OFFSET = Vector2(0, -8)
const GROUND_PARTICLES_TEXTURE_LEFT = preload("res://assets/effects/move/move_ground_particles_left.png")
const GROUND_PARTICLES_TEXTURE_RIGHT = preload("res://assets/effects/move/move_ground_particles_right.png")

const RIGHT_X = 1
const LEFT_X = -1


onready var free = get_parent()
onready var sprite = owner.get_node("Sprite")
onready var wall_detector = owner.get_node("WallDetector")
onready var player = owner
onready var ground_particles = owner.get_node("MoveGroundParticles")


func _ready():
	ground_particles.global_position = player.global_position
	ground_particles.position += GROUND_PARTICLES_OFFSET
	ground_particles.emitting = false

func enter(data: Dictionary = {}):
	free.enter(data)
	sprite.request("move")
	if player.get_facing_int() == RIGHT_X:
		ground_particles.texture = GROUND_PARTICLES_TEXTURE_RIGHT
	else: 
		ground_particles.texture = GROUND_PARTICLES_TEXTURE_LEFT
	ground_particles.emitting = true

func physics_process(delta: float):
	free.physics_process(delta)
	player.move_and_slide(free.move.velocity, Vector2.ZERO)
	
#	Transition to Idle
	if free.move.velocity == Vector2.ZERO:
		_state_machine.transition_to("Free/Idle")
		return
	
#	Transition to Fall
	if not wall_detector.is_on_floor():
		_state_machine.transition_to("Free/Fall")
		return


func exit():
	ground_particles.emitting = false
	free.exit()


func unhandled_input(event: InputEvent):
	if event.is_action_pressed('jump'):
		_state_machine.transition_to('Free/Jump')
		return
	free.unhandled_input(event)
