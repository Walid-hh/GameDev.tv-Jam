class_name MobWitch extends Mob

var circular_attack_scene := preload("res://Mobs/Attacks/circular_attack.tscn")
var aoe_attack_scene := preload("res://Mobs/Attacks/aoe_attack.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	setup_state_machine()
	var combat_start_timer := Timer.new()
	add_child(combat_start_timer)
	combat_start_timer.start(3)
	combat_start_timer.one_shot = true
	combat_start_timer.timeout.connect(func() -> void :
		state_machine.trigger_event(WitchStates.Events.COMBAT_STARTED))


func setup_state_machine():
	state_machine = WitchStates.StateMachine.new()
	add_child(state_machine)
	var idle := WitchStates.StateIdle.new(self)
	var combat := WitchStates.StateCombat.new(self )
	var attack_one := WitchStates.StateCircularAttack.new(self , circular_attack_scene)
	var attack_two := WitchStates.StateAoeAttack.new(self , aoe_attack_scene)
	var die := WitchStates.StateDie.new(self)
	state_machine.transitions = {
		idle :{
			WitchStates.Events.COMBAT_STARTED : combat
		},
		combat :{
			WitchStates.Events.FINISHED : idle,
			WitchStates.Events.ATTACK_ONE : attack_one,
			WitchStates.Events.ATTACK_TWO : attack_two,
		},
		attack_one :{
			WitchStates.Events.FINISHED : combat,
		},
		attack_two :{
			WitchStates.Events.FINISHED : combat,
		}
	}
	state_machine.add_transition_to_all_states(WitchStates.Events.HEALTH_DEPLETED , die)
	state_machine.activate(idle)
	state_machine.is_debugging = true
