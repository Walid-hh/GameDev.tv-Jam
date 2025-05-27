class_name Player extends CharacterBody2D

@onready var screen_shake: ColorRect = %ScreenShake
@onready var player_sprite: AnimatedSprite2D = %PlayerSprite
@onready var health_bar: ProgressBar = %HealthBar
@onready var health_count: Label = %HealCount
@onready var thunder_count: Label = %ThunderCount
@onready var combat_ui: CanvasLayer = %CombatUI
@onready var swordsfx: AudioStreamPlayer = %swordsfx
@onready var tookdamage: AudioStreamPlayer = %tookdamage
@export_category("Base Stats")
@export var max_health := 5
@export var walk_speed := 100
@export var healing_charges := 3
@export var thunder_charges := 1
@export var health_component : HealthComponent = null
@export var stun_gauge : StunGauge = null
@export_category("Weapon")
@export var weapon : Weapon = null
@export_category("Hit Stop")
@export var hit_stop_duration: float = 0.1
@export var hit_stop_strength: float = 0.05
@export_category("Debug")
@export var debug_label : Label = null
var crit_attack := false
var last_direction : Vector2 = Vector2.DOWN
var direction_text : String = "_down"
var state_machine : Node

func _ready() -> void:
	add_to_group("player")
	Global.player_position = global_position
	Global.player_last_direction = last_direction
	state_machine = PlayerFSM.StateMachine.new()
	add_child(state_machine)
	Global.combat_start.connect(state_machine.trigger_event.bind(PlayerFSM.Events.COMBAT_STARTED))
	health_component.hurt_box.took_hit.connect(func(hit_box) -> void :
		health_component.damage_health(hit_box)
		state_machine.trigger_event(PlayerFSM.Events.TOOK_HIT))


	var safe := PlayerFSM.StateSafe.new(self)
	safe.speed = walk_speed
	
	var combat := PlayerFSM.StateCombat.new(self , weapon)
	combat.speed = walk_speed

	var stagger := PlayerFSM.StateStagger.new(self)
	
	var crit_attack := PlayerFSM.StateCritAttack.new(self)
	
	var die := PlayerFSM.StateDie.new(self)

	state_machine.transitions ={
		safe :{
			PlayerFSM.Events.COMBAT_STARTED : combat,
		},
		combat :{
			#PlayerFSM.Events.FINISHED : safe,
			PlayerFSM.Events.CRIT_ATTACK : crit_attack,
		},
		crit_attack :{
			PlayerFSM.Events.FINISHED : combat,
		},
		stagger :{
			PlayerFSM.Events.FINISHED : combat,
		},

	}

	state_machine.add_transition_to_all_states(PlayerFSM.Events.TOOK_HIT , stagger)
	state_machine.add_transition_to_all_states(PlayerFSM.Events.HEALTH_DEPLETED , die)
	state_machine.activate(safe)
	state_machine.is_debugging = false
	health_bar.max_value = health_component.max_health

func _physics_process(delta: float) -> void:
	
	Global.player_position = global_position
	Global.player_last_direction = last_direction
	health_bar.value = health_component.health
	health_count.text = str(health_component.health)
	thunder_count.text = str(thunder_charges)
	match last_direction :
		Vector2.UP : direction_text = "_up"
		Vector2.DOWN : direction_text = "_down"
		Vector2.LEFT : direction_text = "_left"
		Vector2.RIGHT : direction_text = "_right"
	if health_component.health <= 0 :
		state_machine.trigger_event(PlayerFSM.Events.HEALTH_DEPLETED)

	
func _combat_movement(speed : int) -> Vector2 :
	var direction := Input.get_vector("move_left","move_right","move_up","move_down")
	direction = direction.sign().normalized()
	velocity = direction * speed
	move_and_slide()
	return direction

func apply_hit_stop():
	var original_time_scale = Engine.time_scale
	Engine.time_scale = hit_stop_strength
	var timer = get_tree().create_timer(hit_stop_duration * hit_stop_strength)
	await timer.timeout
	Engine.time_scale = original_time_scale
