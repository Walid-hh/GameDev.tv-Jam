class_name FireArrow extends Node2D

var direction := Vector2.LEFT
@onready var fire_arrow_sprite: AnimatedSprite2D = %FireArrowSprite
@export var speed := 50.0
@export var max_distance := 200
var traveled_distance := 0.0


func _physics_process(delta: float) -> void:
	global_position += direction * delta * speed
	traveled_distance += speed * delta
	if traveled_distance > max_distance :
		queue_free()
