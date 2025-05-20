class_name Mob extends Node2D

@onready var mob_sprite: AnimatedSprite2D = %MobSprite
@onready var health_component: HealthComponent = %HealthComponent
@onready var stagger_health_component: StaggerHealthComponent = %StaggerHealthComponent
@onready var die_smoke: AnimatedSprite2D = %DieSmoke
var stagger_timer : Timer

@export_category("Base Stats")
@export var max_health := 5
@export var stagger_health := 20
@export var speed := 5

@export_category("Debug Label")
@onready var debug_label: Label = %DebugLabel


var state_machine : Node
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	stagger_timer = Timer.new()
	add_child(stagger_timer)
	stagger_timer.wait_time = 0.3
	stagger_timer.one_shot = true
	health_component.max_health = max_health
	stagger_health_component.stagger_max_health = stagger_health
	stagger_health_component.hurt_box.took_hit.connect(func(hit_box : HitBox2D):
		mob_sprite.material.set_shader_parameter("is_flashing" , true)
		stagger_timer.start())
	stagger_timer.timeout.connect(func() -> void :
		mob_sprite.material.set_shader_parameter("is_flashing" , false))

# Called every frame. 'delta' is the elapsed time since the previous frame.

func setup_state_machine() -> void :
	pass
