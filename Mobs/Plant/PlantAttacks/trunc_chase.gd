extends Node2D

## The top speed that the runner can achieve
@export var max_speed := 70.0
## How much speed is added per second when moving toward target
@export var acceleration := 120.0

var velocity := Vector2.ZERO

func _ready() -> void:
	var timer := Timer.new()
	add_child(timer)
	timer.wait_time = 3.0
	timer.one_shot = true
	timer.start()
	timer.timeout.connect(queue_free)

func _physics_process(delta: float) -> void:
	if Global.player_position != null:
		var direction := global_position.direction_to(Global.player_position)
		var distance := global_position.distance_to(Global.player_position)
		var speed := max_speed
		var desired_velocity := direction * speed
		velocity = velocity.move_toward(desired_velocity, acceleration * delta)
		if velocity.length() > 0.1:
			rotation = velocity.angle()
		# Move the node manually since we don't have move_and_slide()
		position += velocity * delta
