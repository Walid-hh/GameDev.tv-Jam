class_name Player extends CharacterBody2D

@onready var player_sprite: AnimatedSprite2D = %PlayerSprite
@export_category("Base Stats")
@export var walk_speed := 100
@export_category("Debug")
@export var debug_label : Label = null

var last_direction : Vector2 = Vector2.DOWN
var direction_text : String = "_down"

func _ready() -> void:

	var state_machine := PlayerFSM.StateMachine.new()
	add_child(state_machine)
	Global.combat_start.connect(state_machine.trigger_event.bind(PlayerFSM.Events.COMBAT_STARTED))

	var safe := PlayerFSM.StateSafe.new(self)
	safe.speed = walk_speed
	
	var combat := PlayerFSM.StateCombat.new(self)
	combat.speed = walk_speed

	state_machine.transitions ={
		safe :{
			PlayerFSM.Events.COMBAT_STARTED : combat,
		},
		combat :{
			PlayerFSM.Events.FINISHED : safe,
		},
	}

	state_machine.activate(safe)
	state_machine.is_debugging = true
	

func _process(delta: float) -> void:
	Global.player_position = global_position
	Global.player_last_direction = last_direction
	match last_direction :
		Vector2.UP : direction_text = "_up"
		Vector2.DOWN : direction_text = "_down"
		Vector2.LEFT : direction_text = "_left"
		Vector2.RIGHT : direction_text = "_right"

func _combat_movement(speed : int) -> Vector2 :
	var direction := Input.get_vector("move_left","move_right","move_up","move_down")
	direction = direction.sign().normalized()
	velocity = direction * speed
	move_and_slide()
	return direction
