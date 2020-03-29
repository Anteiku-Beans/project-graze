extends State

const GROUND_PARTICLES = preload("res://source/Effects/MoveGroundParticles/MoveGroundParticles.tscn")
const GROUND_PARTICLES_OFFSET = Vector2(0, -8)

var current_ground_particles

onready var free = get_parent()
onready var sprite = owner.get_node("Sprite")
onready var wall_detector = owner.get_node("WallDetector")
onready var player = owner


func enter(data: Dictionary = {}):
	free.enter(data)
	sprite.request("move")
	summon_ground_particles()


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
	unsummon_ground_particles()
	free.exit()


func unhandled_input(event: InputEvent):
	if event.is_action_pressed('jump'):
		_state_machine.transition_to('Free/Jump')
		return
	free.unhandled_input(event)


func summon_ground_particles():
	current_ground_particles = GROUND_PARTICLES.instance()
	player.add_child(current_ground_particles)
	current_ground_particles.global_position = player.global_position
	current_ground_particles.position += GROUND_PARTICLES_OFFSET
	current_ground_particles.scale.x = player.get_facing_int()


func unsummon_ground_particles():
	if current_ground_particles != null:
		current_ground_particles.queue_free()
