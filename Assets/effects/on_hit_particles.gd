extends Position2D

func _ready():
	$right.emitting = true
	$left.emitting = true
	$timer.wait_time = $right.lifetime
	$timer.connect("timeout", self, "_on_timer_timeout")
	randomize_rotation()

func _on_timer_timeout():
	self.queue_free()

func randomize_rotation():
	self.rotation = (-deg2rad(10) + randf()*deg2rad(20))
