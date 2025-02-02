extends CharacterBody3D


@export var speed : float = 5.0
@export var rotate_speed : float = 100.0

var game_mode : int = 0

func play_mode(delta: float) -> void:
	var input_dir := Input.get_vector("left", "right", "front", "back")
	
	if not Input.is_action_pressed("strafe"):
		rotation_degrees.y -= input_dir.x * delta * rotate_speed
		input_dir.x = 0
	
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	
	move_and_slide()

func _physics_process(delta: float) -> void:
	
	if game_mode == 0:
		play_mode(delta)
