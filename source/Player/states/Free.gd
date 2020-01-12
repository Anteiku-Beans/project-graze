extends State

var velocity: = Vector2.ZERO
var is_on_floor: bool

func _ready():
	yield(owner, "ready")
	is_on_floor = owner.is_on_floor()

func physics_process(delta: float) -> void:
	is_on_floor = owner.is_on_floor()
	owner.move_and_slide(velocity, Vector2.UP)