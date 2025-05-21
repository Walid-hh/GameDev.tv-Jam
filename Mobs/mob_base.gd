class_name Mob extends Node2D

@onready var mob_sprite: AnimatedSprite2D = %MobSprite
@onready var health_component: HealthComponent = %HealthComponent
@onready var stagger_health_component: StaggerHealthComponent = %StaggerHealthComponent
@onready var mob_stagger_bar: ProgressBar = %MobStaggerBar
@onready var health_point_container: HBoxContainer = %HealthPointContainer
@onready var die_smoke: AnimatedSprite2D = %DieSmoke
var health_point := preload("res://Mobs/mob_health_point.tscn")
var stagger_timer : Timer

@export_category("Base Stats")
@export var max_health : int = 3
@export var max_stagger_health : int = 20

@export_category("Debug Label")
@onready var debug_label: Label = %DebugLabel


var state_machine : Node
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.player_died.connect(func() -> void :
		state_machine.trigger_event(MobFSM.Events.PLAYER_DIED))
	stagger_timer = Timer.new()
	add_child(stagger_timer)
	stagger_timer.wait_time = 0.3
	stagger_timer.one_shot = true
	health_component.max_health = max_health
	stagger_health_component.hurt_box.took_hit.connect(func(hit_box : HitBox2D):
		mob_sprite.material.set_shader_parameter("is_flashing" , true)
		stagger_health_component.damage_stagger_health(hit_box)
		stagger_timer.start())
	stagger_timer.timeout.connect(func() -> void :
		mob_sprite.material.set_shader_parameter("is_flashing" , false))
	mob_stagger_bar.max_value = stagger_health_component.stagger_max_health
	for i in range(health_component.max_health):
		var point = health_point.instantiate()
		health_point_container.add_child(point)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	mob_stagger_bar.value = stagger_health_component.stagger_health

func setup_state_machine() -> void :
	pass
