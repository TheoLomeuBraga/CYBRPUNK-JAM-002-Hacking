extends CharacterBody3D


@export var speed : float = 5.0
@export var rotate_speed : float = 100.0

var game_mode : int = 1

@onready var pda : Node3D = $pda/pda_model
@onready var gun : Node3D = $gun/gun_model

@export var swich_bloked : bool = false

@export var ram_indicator : PackedScene



@export var max_ram_unitys : int = 3:
	get():
		return max_ram_unitys
	set(value):
		max_ram_unitys = value
		
		if $hud/VBoxContainer/HBoxContainer != null:
			for c in $hud/VBoxContainer/HBoxContainer.get_children():
				$hud/VBoxContainer/HBoxContainer.remove_child(c)
				c.queue_free()
			
			for i in max_ram_unitys:
				var v : ProgressBar = ram_indicator.instantiate()
				$hud/VBoxContainer/HBoxContainer.add_child(v)
				v.value = 0

@export var ram : float = 3.0:
	get():
		return ram
	set(value):
		ram = value
		
		if ram < 0:
			ram = 0.0
		elif ram > max_ram_unitys:
			ram = max_ram_unitys
		
		var i : int = 0
		var chiltrem_count : int = $hud/VBoxContainer/HBoxContainer.get_child_count()
		
		
		for c in $hud/VBoxContainer/HBoxContainer.get_children():
			
			if c is ProgressBar:
				if i < int(ram):
					c.value = 100
				elif i > int(ram):
					c.value = 0
				else:
					c.value = (ram - int(ram)) * 100
				
				i+=1

@export var ram_regeneration_speed : float = 0.1

var target_raycast_node : Node

func make_haker_stuf(hack_name : String) -> void:
	print("hack_name: ",hack_name)
	
	if target_raycast_node != null:
		target_raycast_node.hack(hack_name)

func _ready() -> void:
	
	max_ram_unitys = max_ram_unitys
	ram = ram
	
	$pda/pda_model/pda_screen/SubViewport.set_process_input(true)
	$pda/pda_model/pda_screen/SubViewport/HackMenu.hack.connect(make_haker_stuf)

func pda_mode(delta: float) -> void:
	$hud/able_to_hack_hint.visible = false
	Engine.set_time_scale(0.1)
	pda.position = pda.position.move_toward($pda/pda_action_pos.position,delta * 50)
	gun.position = gun.position.move_toward($gun/gun_rest_pos.position,delta * 50)



func gun_mode(delta: float) -> void:
	
	Engine.set_time_scale(1.0)
	pda.position = pda.position.move_toward($pda/pda_rest_pos.position,delta * 10)
	gun.position = gun.position.move_toward($gun/gun_action_pos.position,delta * 10)
	
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
	
	if Input.is_action_just_pressed("ui_accept") and not $gun/gun_model/AnimationPlayer.is_playing():
		$gun/gun_model/AnimationPlayer.play("recoil")
	
	if $Camera3D/RayCast3D.is_colliding() and $Camera3D/RayCast3D.get_collider().has_method("hack") and $Camera3D/RayCast3D.get_collider().has_method("get_hack_list"):
		target_raycast_node = $Camera3D/RayCast3D.get_collider()
		
		$pda/pda_model/pda_screen/SubViewport/HackMenu.clean_hack_buttons()
		for h : Hack in target_raycast_node.get_hack_list():
			$pda/pda_model/pda_screen/SubViewport/HackMenu.add_hack_button(h.hack_name,h.hack_text,h.hack_color)
		
	else:
		$pda/pda_model/pda_screen/SubViewport/HackMenu.clean_hack_buttons()
		target_raycast_node = null
	
	$hud/able_to_hack_hint.visible = target_raycast_node != null



func _physics_process(delta: float) -> void:
	ram += delta * ram_regeneration_speed
	if game_mode == 0:
		pda_mode(delta)
	elif game_mode == 1:
		gun_mode(delta)
	
	if not swich_bloked and Input.is_action_just_pressed("swich_mode"):
		if game_mode == 0:
			game_mode = 1
		elif game_mode == 1:
			game_mode = 0







func _unhandled_input(event: InputEvent) -> void:
	if game_mode == 0:
		$pda/pda_model/pda_screen/SubViewport.push_input(event)
