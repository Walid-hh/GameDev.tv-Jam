extends Control
@onready var boss_first: Button = %BossFirst
@onready var boss_second: Button = %BossSecond
@onready var boss_third: Button = %BossThird
@onready var exit: Button = %Exit
@onready var settings_button: TextureButton = %SettingsButton
@onready var credit: Button = %Credit
@onready var credits: RichTextLabel = %Credits

var boss_one := preload("res://Levels/frog_boss_fight.tscn")
var boss_two := preload("res://Levels/plant_boss_fight.tscn")
var boss_three := preload("res://Levels/witch_boss_fight.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	boss_first.pressed.connect(SceneManager.transition_to_packed_scene.bind(boss_one))
	boss_second.pressed.connect(SceneManager.transition_to_packed_scene.bind(boss_two))
	boss_third.pressed.connect(SceneManager.transition_to_packed_scene.bind(boss_three))
	exit.pressed.connect(get_tree().quit)
	credit.pressed.connect(func() -> void :
		credits.visible = true)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		credits.visible = false
