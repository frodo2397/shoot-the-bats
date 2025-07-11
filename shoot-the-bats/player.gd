extends CharacterBody3D

var current_jumps = 0
var player_alive = true
signal reset_game

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	if (player_alive):
		if event is InputEventMouseMotion:
			#mouse moved
			rotation_degrees.y -= (event.relative.x) * 0.3
			%Camera3D.rotation_degrees.x -= event.relative.y * 0.15
			%Camera3D.rotation_degrees.x = clamp(%Camera3D.rotation_degrees.x, -60, 60)
		elif event.is_action_pressed("ui_cancel"):
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			pass

func _physics_process(delta):
	if (player_alive):
		const SPEED = 5.5
		var input_direction_2D = Input.get_vector(
			"move_left", "move_right", "move_forward",  "move_back"
		)
		var input_direction_3D = Vector3(
			input_direction_2D.x, 0.0, input_direction_2D.y
		)
		
		var direction = transform.basis * input_direction_3D
		
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		
		velocity.y -= 20 * delta
		
		if (is_on_floor()):
			current_jumps = 0
		
		if Input.is_action_just_pressed("jump") :
			if is_on_floor():
				current_jumps = 1
				velocity.y = 5.0
			elif current_jumps < 3:
				current_jumps += 1
				velocity.y = 5.0
		
		if Input.is_action_pressed("shoot") and %Timer.is_stopped():
			shoot_bullet()

		move_and_slide()
	
func shoot_bullet():
	if (player_alive):
		const BULLET_3D = preload("res://player/bullet_3d.tscn")
		var new_bullet = BULLET_3D.instantiate()
		%Marker3D.add_child(new_bullet)
		new_bullet.global_transform = %Marker3D.global_transform
		%Timer.start()
		%AudioStreamPlayer.play()
	
func _on_game_player_died():
	player_alive = false
