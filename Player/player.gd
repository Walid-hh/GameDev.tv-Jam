class_name Player extends CharacterBody2D

@onready var screen_shake: ColorRect = %ScreenShake
@onready var player_sprite: AnimatedSprite2D = %PlayerSprite
@export_category("Base Stats")
@export var max_health := 5
@export var walk_speed := 100
@export var healing_charges := 5
@export var health_component : HealthComponent = null
@export_category("Weapon")
@export var weapon : Weapon = null
@export_category("Debug")
@export var debug_label : Label = null

var last_direction : Vector2 = Vector2.DOWN
var direction_text : String = "_down"
var state_machine : Node

func _ready() -> void:
	
	Global.player_position = global_position
	Global.player_last_direction = last_direction
	state_machine = PlayerFSM.StateMachine.new()
	add_child(state_machine)
	Global.combat_start.connect(state_machine.trigger_event.bind(PlayerFSM.Events.TOOK_HIT))
	health_component.hurt_box.took_hit.connect(func(hit_box) -> void :
		health_component.damage_health(hit_box)
		state_machine.trigger_event(PlayerFSM.Events.TOOK_HIT))
	health_component.max_health = max_health
	print(health_component.health)


	var safe := PlayerFSM.StateSafe.new(self)
	safe.speed = walk_speed
	
	var combat := PlayerFSM.StateCombat.new(self , weapon)
	combat.speed = walk_speed

	var stagger := PlayerFSM.StateStagger.new(self)
	
	var die := PlayerFSM.StateDie.new(self)

	state_machine.transitions ={
		safe :{
			PlayerFSM.Events.COMBAT_STARTED : combat,
		},
		combat :{
			PlayerFSM.Events.FINISHED : safe,
		},
		stagger :{
			PlayerFSM.Events.FINISHED : combat,
		},
		die :{
			PlayerFSM.Events.FINISHED : safe,
		}
	}

	state_machine.add_transition_to_all_states(PlayerFSM.Events.TOOK_HIT , stagger)
	state_machine.add_transition_to_all_states(PlayerFSM.Events.HEALTH_DEPLETED , die)
	state_machine.activate(combat)
	state_machine.is_debugging = true
	

func _physics_process(delta: float) -> void:

	Global.player_position = global_position
	Global.player_last_direction = last_direction
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
