extends CharacterBody3D
class_name NetGuner

@export var speed : float = 5.0
@export var rotate_speed : float = 100.0

@export var game_mode : int = 3

@onready var pda : Node3D = $pda/pda_model
@onready var gun : Node3D = $gun/gun_model

@export var swich_bloked : bool = false

@export var ram_indicator : PackedScene



@export var max_ram_unitys : int = 3:
	get():
		return max_ram_unitys
	set(value):
		max_ram_unitys = value
		
		if $hud/VBoxContainer/CenterContainer/GridContainer != null:
			for c in $hud/VBoxContainer/CenterContainer/GridContainer.get_children():
				$hud/VBoxContainer/CenterContainer/GridContainer.remove_child(c)
				c.queue_free()
			
			for i in max_ram_unitys:
				var v : ProgressBar = ram_indicator.instantiate()
				$hud/VBoxContainer/CenterContainer/GridContainer.add_child(v)
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
		
		if $hud/minimal_ram != null:
			$hud/minimal_ram.value = ram * 100
		
		if $hud/VBoxContainer/CenterContainer/GridContainer != null:
			var i : int = 0
			var chiltrem_count : int = $hud/VBoxContainer/CenterContainer/GridContainer.get_child_count()
			
			
			for c in $hud/VBoxContainer/CenterContainer/GridContainer.get_children():
				
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
	
	
	if target_raycast_node != null and ram > 1:
		target_raycast_node.hack(hack_name)
		ram-=1
		print("hack_name: ",hack_name)

@export var health : int = 50 :
	get():
		return health
	set(value):
		health = value
		$hud/VBoxContainer/healthBar.value = value

enum PowerUpTypes {
	none = 0,
	invunerable = 1,
	fast = 2,
	strong = 3,
}

@export var power_up_type : PowerUpTypes :
	get():
		return power_up_type
	set(value):
		power_up_type = value
		if $disable_power_up != null and value != PowerUpTypes.none:
			$disable_power_up.start()

func disable_power_up() -> void:
	power_up_type = PowerUpTypes.none


func _ready() -> void:
	
	Global.player = self
	
	max_ram_unitys = max_ram_unitys
	ram = ram
	
	$pda/pda_model/pda_screen/SubViewport.set_process_input(true)
	$pda/pda_model/pda_screen/SubViewport/HackMenu.hack.connect(make_haker_stuf)

func pda_mode(delta: float) -> void:
	$hud/able_to_hack_hint.visible = false
	Engine.set_time_scale(0.1)
	pda.position = pda.position.move_toward($pda/pda_action_pos.position,delta * 50)
	gun.position = gun.position.move_toward($gun/gun_rest_pos.position,delta * 50)


@export var bullet_sceane : PackedScene

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
	
	if power_up_type == PowerUpTypes.fast:
		velocity *= 2
	
	move_and_slide()
	
	if Input.is_action_just_pressed("ui_accept") and not $gun/gun_model/AnimationPlayer.is_playing():
		$gun/gun_model/AnimationPlayer.play("recoil")
		
		var b : Node3D = bullet_sceane.instantiate()
		get_parent().add_child(b)
		b.global_position = $Camera3D/muzle.global_position
		b.global_rotation = $Camera3D/muzle.global_rotation
		
		if power_up_type == PowerUpTypes.strong:
			b = bullet_sceane.instantiate()
			get_parent().add_child(b)
			b.global_position = $Camera3D/muzle.global_position
			b.global_rotation = $Camera3D/muzle.global_rotation
			b.rotation.y += 10
			
			b = bullet_sceane.instantiate()
			get_parent().add_child(b)
			b.global_position = $Camera3D/muzle.global_position
			b.global_rotation = $Camera3D/muzle.global_rotation
			b.rotation.y -= 10
		
		$gun_shot.play()
	
	if $Camera3D/RayCast3D.is_colliding() and $Camera3D/RayCast3D.get_collider().has_method("hack") and $Camera3D/RayCast3D.get_collider() != null and $Camera3D/RayCast3D.get_collider().has_method("get_hack_list"):
		target_raycast_node = $Camera3D/RayCast3D.get_collider()
		
		$pda/pda_model/pda_screen/SubViewport/HackMenu.clean_hack_buttons()
		for h : Hack in target_raycast_node.get_hack_list():
			$pda/pda_model/pda_screen/SubViewport/HackMenu.add_hack_button(h.hack_name,h.hack_text,h.hack_color)
		
		$hud/able_to_hack_hint.visible = target_raycast_node.get_hack_list().size() > 0
		
	else:
		$pda/pda_model/pda_screen/SubViewport/HackMenu.clean_hack_buttons()
		target_raycast_node = null
		$hud/able_to_hack_hint.visible = false

func nothing_mode(delta: float) -> void:
	
	Engine.set_time_scale(1.0)
	pda.position = pda.position.move_toward($pda/pda_rest_pos.position,delta * 10)
	gun.position = gun.position.move_toward($gun/gun_rest_pos.position,delta * 10)
	
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
	
	$hud/power_up_bar.visible = $disable_power_up.time_left > 0
	$hud/power_up_bar.value = $disable_power_up.time_left * 20
	
	var power_up_bar_color : Color = Color.BLACK
	if power_up_type == PowerUpTypes.invunerable:
		power_up_bar_color = Color.BLUE
	elif power_up_type == PowerUpTypes.fast:
		power_up_bar_color = Color.ORANGE
	elif power_up_type == PowerUpTypes.strong:
		power_up_bar_color = Color.DARK_RED
	
	var s : StyleBoxFlat = $hud/power_up_bar.get_theme_stylebox("fill")
	s.bg_color = power_up_bar_color
	$hud/power_up_bar.add_theme_stylebox_override("fill",s)
	
	ram += delta * ram_regeneration_speed
	if game_mode == 0:
		pda_mode(delta)
	elif game_mode == 1:
		gun_mode(delta)
	elif game_mode == 3:
		nothing_mode(delta)
	
	if not swich_bloked and Input.is_action_just_pressed("swich_mode"):
		if game_mode == 0:
			game_mode = 1
		elif game_mode == 1:
			game_mode = 0

@export var game_over_sceane :PackedScene
var on_iframe : bool = false
func get_shot() -> void:
	if not on_iframe and power_up_type != PowerUpTypes.invunerable:
		
		$iFrameTimer.start()
		$get_shot_sound.play()
		
		health -= 10
		
		on_iframe = true
		
		if health <= 0:
			get_tree().change_scene_to_packed(game_over_sceane)


func turn_off_iframes() -> void:
	on_iframe = false


func _unhandled_input(event: InputEvent) -> void:
	if game_mode == 0:
		$pda/pda_model/pda_screen/SubViewport.push_input(event)
