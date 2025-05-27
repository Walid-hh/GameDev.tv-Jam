class_name WitchStates extends MobFSM


class StateCircularAttack extends State:
	var circular_attack_scene: PackedScene
	var attack_counter: int = 0
	var max_attacks: int = 5
	var initial_delay: float = 0.0
	var attack_interval: float = 1.0
	var timer: float = 0.0
	var waiting_for_initial_delay: bool = true

	func _init(init_mob: Mob, init_circular_attack: PackedScene) -> void:
		super("CircularAttack", init_mob)
		circular_attack_scene = init_circular_attack
		attack_counter = 0

	func enter() -> void:
		timer = 0.0
		waiting_for_initial_delay = true
		attack_counter = 0

	func update(delta: float) -> Events:
		timer += delta
		
		if waiting_for_initial_delay:
			if timer >= initial_delay:
				timer = 0.0
				waiting_for_initial_delay = false
				_spawn_circular_attack()
				attack_counter += 1
				if attack_counter >= max_attacks:
					return Events.FINISHED
		else:
			if timer >= attack_interval:
				timer = 0.0
				_spawn_circular_attack()
				attack_counter += 1

				if attack_counter >= max_attacks:
					return Events.FINISHED
		return Events.NONE

	func _spawn_circular_attack() -> void:
		if circular_attack_scene == null:
			push_error("Circular attack scene is null!")
			return

		var attack = circular_attack_scene.instantiate()

		mob.add_sibling(attack)

		attack.global_position = Global.player_position


	func exit() -> void:
		timer = 0.0
		waiting_for_initial_delay = true

class StateAoeAttack extends State:
	var aoe_attack_scene: PackedScene
	var attack_counter: int = 0
	var max_attacks: int = 4

	var attack_positions: Array[Vector2] = [
	Vector2(64, 64),
	Vector2(128, 64),
	Vector2(192, 64)
	]

	var attack_interval: float = 1.5 
	var timer: float = 0.0

	func _init(init_mob: Mob, init_aoe_attack: PackedScene) -> void:
		super("AoeAttack", init_mob)
		aoe_attack_scene = init_aoe_attack
		attack_counter = 0

	func enter() -> void:
		timer = 0.0
		attack_counter = 0

	func update(delta: float) -> Events:
		timer += delta

		if timer >= attack_interval:
			timer = 0.0
			_spawn_aoe_attack()
			attack_counter += 1

			if attack_counter >= max_attacks:
				return Events.FINISHED

		return Events.NONE

	func _spawn_aoe_attack() -> void:
		if aoe_attack_scene == null:
			push_error("AOE attack scene is null!")
			return

		var position_index = randi() % attack_positions.size()
		var spawn_position = attack_positions[position_index]
		var attack = aoe_attack_scene.instantiate()
		mob.add_sibling(attack)
		attack.global_position = spawn_position

	func exit() -> void:
		timer = 0.0

class StateFireArrow extends State:
	var attack_scene: PackedScene
	var attack_counter := 0
	var max_attacks := 5
	var attack_timer := 0.0
	var attack_interval := 1.0
	var possible_y_positions := [72, 88, 104, 120, 136, 152]
	var possible_x_positions := [64, 256]

	func _init(init_mob: Mob, init_attack_scene: PackedScene) -> void:
		super("FireArrow", init_mob)
		attack_scene = init_attack_scene

	func enter() -> void:
		attack_counter = 0
		attack_timer = 0.0


	func update(delta: float) -> Events:
		attack_timer += delta

		if attack_timer >= attack_interval:
			attack_timer = 0.0
			_spawn_attack()
			attack_counter += 1

			if attack_counter >= max_attacks:
				return Events.FINISHED

		return Events.NONE

	func _spawn_attack() -> void:
		var attack_instance = attack_scene.instantiate()
		mob.add_sibling(attack_instance)

		var pos_y = possible_y_positions.pick_random()
		var pos_x = possible_x_positions.pick_random()
		if pos_x == 64:
			attack_instance.rotation = PI
			attack_instance.direction = Vector2.RIGHT
		attack_instance.global_position = Vector2(pos_x, pos_y)

		

	func exit() -> void:
		# Clean up any remaining timers or state
		attack_timer = 0.0
		attack_counter = 0
