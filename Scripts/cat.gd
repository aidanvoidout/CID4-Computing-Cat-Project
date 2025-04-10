extends Node2D

@onready var sprite = $AnimatedSprite2D
@onready var timer = $Timer

var check_interval = 0.1  # Check every 50 seconds
var chance_to_play = 0.1  # 10% chance to play an animation
@onready var raycastright: RayCast2D = $Raycastright
@onready var raycastleft: RayCast2D = $Raycastleft
var direction = 1  # 1 = right, -1 = left
var speed = 100
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
var is_dragging = false
var velocity = Vector2.ZERO  # For falling motion
var gravity = 500  # Adjust gravity as needed
var last_click_time = 0.0  # For detecting double-clicks
var boundary_left = -194
var boundary_right = 0
func _ready():
	play_idle()
	timer.timeout.connect(_choose_animation)
	timer.start(check_interval)
	print("Cat Position (local):", sprite.position)  # Local position of the sprite
	print("Cat Global Position:", sprite.global_position)  # Global position of the sprite
	print("Parent Position (local):", sprite.get_parent().position)  # Local position of the parent
	print("Parent Global Position:", sprite.get_parent().global_position)  # Global position of the parent
	

func play_idle():
	sprite.play("Idle")
	timer.start(check_interval)

func play_walk():
	sprite.play("Walk")
	var timer_walk = get_tree().create_timer(40)  # Walk for 40 seconds

	while timer_walk.time_left > 0:
		# Check boundaries and reverse direction if necessary
		if sprite.global_position.x <= boundary_left:
			direction = 1
			sprite.flip_h = true
		elif sprite.global_position.x >= boundary_right:
			direction = -1
			sprite.flip_h = false

		# Apply movement  # Simulate frame-by-frame update

		# Wait for the next frame
		await get_tree().process_frame


	# Once the timer completes, return to idle	
	play_idle()

func play_run():
	sprite.play("Run")
	var timer_run = get_tree().create_timer(20)  

	while timer_run.time_left > 0:
		# Check boundaries and reverse direction if necessary
		if sprite.global_position.x <= boundary_left:
			direction = -1
			sprite.flip_h = true
		elif sprite.global_position.x >= boundary_right:
			direction = 1
			sprite.flip_h = false

		# Apply movement  # Simulate frame-by-frame update

		# Wait for the next frame
		await get_tree().process_frame


	# Once the timer completes, return to idle	
	play_idle()

func play_sleep():
	sprite.play("Sleep")
	await get_tree().create_timer(60).timeout
	play_idle()

func _choose_animation():
	print("Checking animation...Current:", sprite.animation)
	if sprite.animation == "Walk" or sprite.animation == "Run" or sprite.animation == "Sleep":
		return  # If not idle, wait until the current animation ends

	# Use randi_range() for an exact 10% chance
	if randi_range(1, 10) == 1:  
		var random_num = randi_range(1, 3)
		match random_num:
			1:
				play_walk()
			2:
				play_run()
			3:
				play_sleep()
			_:
				play_idle()
	else:
		print('remain idle')
		play_idle()
		

	timer.start(check_interval)  # Recheck every 50 seconds


func _process(delta):
	
	if not is_dragging:
		velocity.y += gravity * delta  # Apply gravity
		position += velocity * delta  # Move the cat
	var current_speed = speed
	if sprite.animation == "Run":
		current_speed = 40
	elif sprite.animation == "Walk":
		current_speed = 20
	if sprite.animation == "Walk" or sprite.animation == "Run":
		# Check if the next position is within boundaries
		if sprite.global_position.x + direction * current_speed * delta <= boundary_left:
			sprite.global_position.x = boundary_left  # Stop at left boundary
			direction = 1  # Reverse direction
			sprite.flip_h = false  # Ensure sprite faces right
		elif sprite.global_position.x + direction * current_speed * delta >= boundary_right:
			sprite.global_position.x = boundary_right  # Stop at right boundary
			direction = -1  # Reverse direction
			sprite.flip_h = true  # Ensure sprite faces left
		else:
			sprite.global_position.x += direction * current_speed * delta
	print(sprite.global_position)
	

	
