class_name Bow extends Weapon
@onready var animation_player: AnimationPlayer = %AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if  !animation_player.is_playing():
		visible = true
		animation_player.play("bow_anim")
	animation_player.animation_finished.connect(func (animation_name) -> void :
		visible = false)
	super(delta)
