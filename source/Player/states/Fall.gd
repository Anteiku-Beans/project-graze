extends State

const FALL_ACCELERATION = Vector2(0, 900)
const FALL_DIRECTION = Vector2.DOWN
const FALL_MAX_SPEED = Vector2(0, 300)

var fall = Motion.new()

onready var free = get_parent()
onready var sprite = owner.get_node("Sprite")
onready var wall_detector = owner.get_node("WallDetector")
onready var player = owner


func _ready():
	fall.acceleration = FALL_ACCELERATION
	fall.direction = FALL_DIRECTION
	fall.max_speed = FALL_MAX_SPEED


func enter(data: Dictionary = {}):
	free.enter(data)
	fall.velocity = Vector2.ZERO
	sprite.request("fall")


func physics_process(delta):
	free.physics_process(delta)
	fall.velocity = fall.calculate_velocity(delta)
	
	var total_velocity = fall.velocity + free.move.velocity
	player.move_and_slide(total_velocity, Vector2.UP)
	
	# land
	if (player.is_on_floor()):
		if (free.get_move_direction().x != 0):
			_state_machine.transition_to("Free/Move")
			return
		else:
			_state_machine.transition_to("Free/Idle")
			return
	
#	Transition to wall slide
	if (player.is_on_wall() and
	wall_detector.is_colliding() and
	get_x_input() == wall_detector.get_wall_direction_x()):
		_state_machine.transition_to("WallSlide", {"wall_direction_x":wall_detector.get_wall_direction_x()})
		return


func exit():
	free.exit()


func unhandled_input(event):
	free.unhandled_input(event)


func get_x_input():
	return Input.get_action_strength("right") - Input.get_action_strength("left")
