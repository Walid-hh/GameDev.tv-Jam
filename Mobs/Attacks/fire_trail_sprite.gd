extends Sprite2D

# Controls for your shader time
var shader_time := 0.0
var was_visible := false
var animation_running := false

# Get the duration from the shader (to know when animation is complete)
@onready var duration = material.get_shader_parameter("duration")

func _ready():
	# Initialize the time parameter
	material.set_shader_parameter("visible_time", 0.0)
	
	# Connect to the visibility_changed signal
	if not visible:
		was_visible = false
	else:
		was_visible = true
		animation_running = true
	
	# Connect to visibility changed signals
	connect("visibility_changed", _on_visibility_changed)

func _process(delta):
	# Only update shader time when sprite is visible and animation is running
	if visible and animation_running:
		shader_time += delta
		material.set_shader_parameter("visible_time", shader_time)
		
		# Check if animation is complete (if not looping)
		if not material.get_shader_parameter("loop") and shader_time >= duration:
			animation_running = false

func _on_visibility_changed():
	# If visibility changes to true, reset and start the animation
	if visible and not was_visible:
		shader_time = 0.0
		material.set_shader_parameter("visible_time", 0.0)
		animation_running = true
	
	# Update visibility tracking
	was_visible = visible
