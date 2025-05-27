extends Node
signal combat_start
signal mob_staggered
signal mob_stagger_fininsh
signal stun
signal crit_landed
signal player_died
signal mob_died

var player_level = 1
var player_position : Vector2
var player_last_direction : Vector2
var main_menu := preload("res://UI/place_holder.tscn")

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	mob_died.connect(SceneManager.transition_to_packed_scene.bind(main_menu))
	player_died.connect(SceneManager.transition_to_packed_scene.bind(main_menu))
