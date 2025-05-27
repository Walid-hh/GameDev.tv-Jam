class_name MobFrog extends Mob

var spear_attack_scene := preload("res://Mobs/Frog/FrogAttacks/spear_attack.tscn")
var water_trap_scene := preload("res://Mobs/Frog/FrogAttacks/water_trap.tscn")
var bubble_attack_scene := preload("res://Mobs/Frog/FrogAttacks/bubble_attack.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	setup_state_machine()

func setup_state_machine():
	state_machine = FrogStates.StateMachine.new()
	add_child(state_machine)
	var idle := FrogStates.StateIdle.new(self)
	var combat := FrogStates.StateCombat.new(self)
	var attack_one := FrogStates.StateSpearThrow.new(self , spear_attack_scene)
	var attack_two := FrogStates.StateWaterTrap.new(self , water_trap_scene)
	var attack_three := FrogStates.StateBubbleAttack.new(self , bubble_attack_scene)
	var stun := FrogStates.StateStun.new(self)
	var stagger := FrogStates.StateStagger.new(self)
	var die := FrogStates.StateDie.new(self )
	state_machine.transitions = {
		idle :{
			FrogStates.Events.COMBAT_STARTED : combat
		},
		stagger :{
			FrogStates.Events.FINISHED : combat,
		},
		combat :{
			FrogStates.Events.FINISHED : idle,
			FrogStates.Events.ATTACK_ONE : attack_one,
			FrogStates.Events.ATTACK_TWO : attack_two,
			FrogStates.Events.ATTACK_THREE : attack_three,
		},
		attack_one :{
			FrogStates.Events.FINISHED : combat,
		},
		attack_two :{
			FrogStates.Events.FINISHED : combat,
		},
		attack_three :{
			FrogStates.Events.FINISHED : combat,
		},
		die :{
			FrogStates.Events.FINISHED : idle,
		},
		stun :{
			FrogStates.Events.FINISHED : combat
		},
	}
	
	state_machine.add_transition_to_all_states(FrogStates.Events.STUN , stun)
	state_machine.add_transition_to_all_states(FrogStates.Events.STAGGER_HEALTH_DEPLETED , stagger)
	state_machine.add_transition_to_all_states(FrogStates.Events.PLAYER_DIED , idle)
	state_machine.add_transition_to_all_states(FrogStates.Events.HEALTH_DEPLETED , die)
	state_machine.activate(combat)
	state_machine.is_debugging = false
