class_name Weapon extends Node2D

@onready var anchor: Marker2D = %Anchor
@export var projectile_scene : PackedScene
@export_category("Projectile Stats")
@export var damage := 1
@export var speed : float = 50.0
@export var max_range : float  = 200.0

func _ready() -> void:
	visible = false

func _physics_process(delta: float) -> void :
	match Global.player_last_direction :
		Vector2.RIGHT : anchor.global_rotation = 0
		Vector2.LEFT : anchor.global_rotation = PI
		Vector2.UP : anchor.global_rotation = 3 * PI / 2
		Vector2.DOWN : anchor.global_rotation = PI / 2

func _shoot() -> void :
	
	var projectile := projectile_scene.instantiate()
	projectile.global_transform = global_transform
	projectile.damage = damage
	projectile.speed = speed
	projectile.max_range = max_range
	get_tree().root.add_child(projectile)
