extends KinematicBody2D

# Maximum possible linear velocity
export var speed_max := 80.0
# Maximum change in linear velocity
export var acceleration_max := 50.0
# Maximum rotation velocity represented in degrees
export var angular_speed_max := 240
# Maximum change in rotation velocity represented in degrees
export var angular_acceleration_max := 40

export var health_max := 100
export var flee_health_threshold := 20

var velocity := Vector2.ZERO
var angular_velocity := 0.0
var linear_drag := 0.1
var angular_drag := 0.1

# Holds the linear and angular components calculated by our steering behaviors.
var acceleration := GSAITargetAcceleration.new()

# GSAISteeringAgent holds our agent's position, orientation, maximum speed and acceleration.
onready var agent := GSAISteeringAgent.new()

onready var player: Node = get_tree().get_nodes_in_group("Player")[0]
# This assumes that our player class will keep its own agent updated.
onready var player_agent: GSAISteeringAgent = player.agent

# Proximities represent an area with which an agent can identify where neighbors in its relevant
# group are. In our case, the group will feature the player, which will be used to avoid a
# collision with them. We use a radius proximity so the player is only relevant inside 100 pixels
onready var proximity := GSAIRadiusProximity.new(agent, [agent, player_agent], 900)

# GSAIPriority will be the main steering behavior we use. It holds sub-behaviors and will pick the  
# first one that returns non-zero acceleration, ignoring any afterwards.
onready var priority := GSAIPriority.new(agent)

func _ready() -> void:
	# ---------- Configuration for our agent ----------
	agent.linear_speed_max = speed_max
	agent.linear_acceleration_max = acceleration_max
	agent.angular_speed_max = deg2rad(angular_speed_max)
	agent.angular_acceleration_max = deg2rad(angular_acceleration_max)
	agent.bounding_radius = calculate_radius($CollisionPolygon2D.polygon)
	update_agent()

	# ---------- Configuration for our behaviors ----------
	# Pursue will happen while the player is in good health. It produces acceleration that takes
	# the agent on an intercept course with the target, predicting its position in the future.
	var pursue := GSAIPursue.new(agent, player_agent)
	pursue.predict_time_max = 99
	
	# AvoidCollision tries to keep the agent from running into any of the neighbors found in its
	# proximity group. In our case, this will be the player if they are close enough.
	var avoid := GSAIAvoidCollisions.new(agent, proximity)
	
	# Adding our final behaviors to the main priority behavior. The order does matter here.
	# We want to avoid collision with the player first, flee from the player second when enabled,
	# and pursue the player last when enabled.
	priority.add(avoid)
	priority.add(pursue)

func _physics_process(delta: float) -> void:
	# Make sure any change in position and speed has been recorded.
	update_agent()

	# Calculate the desired acceleration.
	priority.calculate_steering(acceleration)
	
	# We add the discovered acceleration to our linear velocity. The toolkit does not limit
	# velocity, just acceleration, so we clamp the result ourselves here.
	velocity = (velocity + Vector2(
		acceleration.linear.x, acceleration.linear.y)
	).clamped(agent.linear_speed_max)

	# This applies drag on the agent's motion, helping it to slow down naturally.
	velocity = velocity.linear_interpolate(Vector2.ZERO, linear_drag)
	
	# And since we're using a KinematicBody2D, we use Godot's excellent move_and_slide to actually
	# apply the final movement, and record any change in velocity the physics engine discovered.
	velocity = move_and_slide(velocity)

# In order to support both 2D and 3D, the toolkit uses Vector3, so the conversion is required
# when using 2D nodes. The Z component can be left to 0 safely.
func update_agent() -> void:
	agent.position.x = global_position.x
	agent.position.y = global_position.y
	agent.orientation = rotation
	agent.linear_velocity.x = velocity.x
	agent.linear_velocity.y = velocity.y
	agent.angular_velocity = angular_velocity


# We calculate the radius from the collision shape - this will approximate the agent's size in the
# game world, to avoid collisions with the player.
func calculate_radius(polygon: PoolVector2Array) -> float:
	var furthest_point := Vector2(-INF, -INF)
	for p in polygon:
		if abs(p.x) > furthest_point.x:
			furthest_point.x = p.x
		if abs(p.y) > furthest_point.y:
			furthest_point.y = p.y
	return furthest_point.length()
