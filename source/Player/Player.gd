extends KinematicBody2D

onready var agent = GSAISteeringAgent.new()

func _ready() -> void:
	Player.set_player(self)

# hack: override inbuilt is_on_floor to prevent state from
#       rapidly switching between move and fall during movement
func is_on_floor():
	return test_move(self.transform, Vector2.DOWN)

func _physics_process(delta):
	update_agent()

func update_agent() -> void:
	agent.position.x = global_position.x
	agent.position.y = global_position.y
