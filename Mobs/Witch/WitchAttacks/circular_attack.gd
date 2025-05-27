extends Node2D
@onready var animation_player: AnimationPlayer = %AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global_position = Global.player_position
	animation_player.animation_finished.connect(func(animation_name : String) : 
		queue_free())
