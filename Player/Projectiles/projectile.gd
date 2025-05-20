class_name Projectile extends Node2D

@onready var hit_box: HitBox2D = %HitBox2D
var _initial_position : Vector2
var direction : Vector2 
var damage := 1
var speed : float = 50.0
var max_range : float  = 200.0

func _ready() -> void:
	_initial_position = position
	hit_box.damage = damage
	hit_box.hit_hurt_box.connect(func(hurt_box : HurtBox2D) :
		queue_free())

func _physics_process(delta: float) -> void:
	var velocity := direction * speed
	position += velocity * delta
	var distance_traveled := _initial_position.distance_to(position)
	if distance_traveled > max_range :
		_destroy()

func _destroy() -> void :
		queue_free()
