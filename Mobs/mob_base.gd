class_name Mob extends CharacterBody2D

@onready var mob_sprite: AnimatedSprite2D = %MobSprite
@onready var health_component: HealthComponent = %HealthComponent
@onready var die_smoke: AnimatedSprite2D = %DieSmoke

@export_category("Base Stats")
@export var max_health := 5
@export var stagger_health := 20
@export var speed := 5

@export_category("Debug Label")
@onready var debug_label: Label = %DebugLabel


var state_machine : Node
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health_component.max_health = stagger_health
	state_machine = MobFSM.StateMachine.new()
	add_child(state_machine)

	var idle := MobFSM.StateIdle.new(self)

	var stagger := MobFSM.StateStagger.new(self)

	var die := MobFSM.StateDie.new(self)

	state_machine.transitions ={
		idle :{
			MobFSM.Events.HEALTH_DEPLETED : die,
		},
		die :{
			MobFSM.Events.FINISHED : idle
		}
	}
	state_machine.activate(idle)
	state_machine.is_debugging = true
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("shoot") :
		state_machine.trigger_event(MobFSM.Events.HEALTH_DEPLETED)
