class_name MobPlant extends Mob

var acid_rain_scene := preload("res://Mobs/Plant/PlantAttacks/poison_rain.tscn")
var trunc_chase_scene := preload("res://Mobs/Plant/PlantAttacks/trunc_chase.tscn")
var acid_explosion_scene := preload("res://Mobs/Plant/PlantAttacks/acid_explosion.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	setup_state_machine()


func setup_state_machine():
	state_machine = PlantStates.StateMachine.new()
	add_child(state_machine)
	var idle := PlantStates.StateIdle.new(self)
	var combat := PlantStates.StateCombat.new(self )
	var attack_one := PlantStates.StateAcidRain.new(self , acid_rain_scene)
	var attack_two := PlantStates.StateTrunc.new(self , trunc_chase_scene)
	var attack_three := PlantStates.StateAcidExplosion.new(self , acid_explosion_scene)
	var stagger := PlantStates.StateStagger.new(self)
	var stun := PlantStates.StateStun.new(self)
	var die := PlantStates.StateDie.new(self)
	state_machine.transitions = {
		idle :{
			PlantStates.Events.COMBAT_STARTED : combat
		},
		stagger :{
			PlantStates.Events.FINISHED : combat,
		},
		combat :{
			PlantStates.Events.FINISHED : idle,
			PlantStates.Events.ATTACK_ONE : attack_one,
			PlantStates.Events.ATTACK_TWO : attack_two,
			PlantStates.Events.ATTACK_THREE : attack_three,
		},
		attack_one :{
			PlantStates.Events.FINISHED : combat,
		},
		attack_two :{
			PlantStates.Events.FINISHED : combat,
		},
		attack_three :{
			PlantStates.Events.FINISHED : combat,
		},
		die :{
			PlantStates.Events.FINISHED : idle,
		},
		stun :{
			PlantStates.Events.FINISHED : combat
		},
	}
	state_machine.add_transition_to_all_states(PlantStates.Events.STUN , stun)
	state_machine.add_transition_to_all_states(PlantStates.Events.STAGGER_HEALTH_DEPLETED , stagger)
	state_machine.add_transition_to_all_states(PlantStates.Events.PLAYER_DIED , idle)
	state_machine.add_transition_to_all_states(PlantStates.Events.HEALTH_DEPLETED , die)
	state_machine.activate(combat)
	state_machine.is_debugging = false
