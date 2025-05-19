extends CanvasLayer
class_name ScreenShake
 
@onready var color_rect: ColorRect = %ColorRect
var strength = 0.2 ;
var curStrength = 0;

# Called when the node enters the scene tree for the first time.

func _ready():

	pass # Replace with function body.
 

# Called every frame. ‘delta’ is the elapsed time since the previous frame.

func _process(delta):
	curStrength = max(curStrength - delta, 0);
	if Input.is_action_just_pressed("shoot"):
		curStrength = strength;
		color_rect.material.set_shader_parameter("ShakeStrength", max(curStrength,0))
