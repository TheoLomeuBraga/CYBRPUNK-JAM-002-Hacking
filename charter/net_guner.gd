extends CharacterBody3D


@export var speed : float = 5.0
@export var rotate_speed : float = 100.0

var game_mode : int = 1

@onready var pda : Node3D = $pda/pda_model

func make_haker_stuf(hack_name : String) -> void:
	print("hack_name: ",hack_name)

func _ready() -> void:
	$pda/pda_model/pda_screen/SubViewport.set_process_input(true)
	$pda/pda_model/pda_screen/SubViewport/HackMenu.hack.connect(make_haker_stuf)

func pda_mode(delta: float) -> void:
	
	pda.position = pda.position.move_toward($pda/pda_action_pos.position,delta * 10)

func gun_mode(delta: float) -> void:
	
	pda.position = pda.position.move_toward($pda/pda_rest_pos.position,delta * 10)
	
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
		pda_mode(delta)
	elif game_mode == 1:
		gun_mode(delta)
	
	if Input.is_action_just_pressed("swich_mode"):
		if game_mode == 0:
			game_mode = 1
		elif game_mode == 1:
			game_mode = 0







func _unhandled_input(event: InputEvent) -> void:
	if game_mode == 0:
		$pda/pda_model/pda_screen/SubViewport.push_input(event)
