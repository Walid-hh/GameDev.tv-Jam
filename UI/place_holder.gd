extends Node
@onready var bgm: AudioStreamPlayer = %BGM
@onready var player: Player = %Player


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bgm.finished.connect(bgm.play)
	player.set_physics_process(false)
	player.state_machine.set_physics_process(false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
