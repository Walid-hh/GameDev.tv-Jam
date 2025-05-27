class_name SpearAtack extends Node2D

var direction : Vector2
@export var speed := 250.0
@export var max_distance := 500
@onready var audio_stream_player: AudioStreamPlayer = %AudioStreamPlayer
var traveled_distance := 0.0

func _ready() -> void:
	await get_tree().create_timer(1).timeout
	audio_stream_player.play()
	direction = global_position.direction_to(Global.player_position)
	global_rotation= direction.angle()
	print(Global.player_position)
func _physics_process(delta: float) -> void:
	global_position += direction * delta * speed
	traveled_distance += speed * delta
	if traveled_distance > max_distance :
		queue_free()
