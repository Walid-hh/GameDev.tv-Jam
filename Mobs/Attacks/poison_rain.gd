class_name PoisonRain extends Node2D

var direction := Vector2.DOWN
@export var speed := 50.0
@export var max_distance := 200
var traveled_distance := 0.0
var tween : Tween
var x_offset := 16.0

func _ready() -> void:
	tween = create_tween()
	tween.tween_property(self , "global_position:x" , global_position.x + x_offset , 0.5)
	tween.tween_property(self , "global_position:x" , global_position.x - x_offset , 0.5)
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_loops()

func _physics_process(delta: float) -> void:
	global_position += direction * delta * speed
	traveled_distance += speed * delta
	if traveled_distance > max_distance :
		queue_free()
