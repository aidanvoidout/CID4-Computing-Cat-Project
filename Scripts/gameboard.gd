extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var window_size = get_window().size  # Get the window size
	position = Vector2(randf_range(0, window_size.x), randf_range(0, window_size.y))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var window_size = get_window().size  # Get the window size

	# Clamp position to keep it inside the window
	position.x = clamp(position.x, 0, window_size.x)
	position.y = clamp(position.y, 0, window_size.y)
	
