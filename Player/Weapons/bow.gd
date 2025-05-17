class_name Bow extends Weapon
@onready var animation_player: AnimationPlayer = %AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	process_mode = Node.PROCESS_MODE_PAUSABLE


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	super(delta)
	if Input.is_action_just_pressed("shoot") and !animation_player.is_playing():
		visible = true
		animation_player.play("bow_anim")
		await get_tree().create_timer(0.65).timeout
		_shoot()
	animation_player.animation_finished.connect(func (animation_name) -> void :
		visible = false)
	
