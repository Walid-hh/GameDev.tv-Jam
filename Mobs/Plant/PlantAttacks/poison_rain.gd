class_name PoisonRain extends Node2D

var direction := Vector2.DOWN
@export var speed := 50.0
@export var max_distance := 200
var traveled_distance := 0.0
@export var x_offset := 26.0
var original_x: float

func _ready() -> void:
	await get_tree().process_frame
	original_x = global_position.x
	var tween := create_tween()
	tween.tween_method(_update_x_position, 0.0, x_offset, 0.5)
	tween.tween_method(_update_x_position, x_offset, -x_offset, 0.5)
	tween.tween_method(_update_x_position, -x_offset, 0.0, 0.5)
	#tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_loops()

func _update_x_position(offset: float) -> void:
	global_position.x = original_x + offset

func _physics_process(delta: float) -> void:
	global_position += direction * delta * speed
	traveled_distance += speed * delta
	if traveled_distance > max_distance :
		queue_free()
