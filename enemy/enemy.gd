@tool
extends CharacterBody3D
class_name Enemy


@export var base_material : Material :
	get():
		return base_material
	set(value):
		base_material = value
		if $template_psx_charter/Object/Skeleton3D != null:
			for c1 in $template_psx_charter/Object/Skeleton3D.get_children():
				for c2 in c1.get_children():
					if c2 is MeshInstance3D:
						c2.mesh.set("surface_0/material",value)

@export var outline_material : Material :
	get():
		return outline_material
	set(value):
		outline_material = value
		if $template_psx_charter/Object/Skeleton3D != null:
			for c1 in $template_psx_charter/Object/Skeleton3D.get_children():
				for c2 in c1.get_children():
					if c2 is MeshInstance3D:
						c2.mesh.set("surface_1/material",value)

@export var outline_color : Color : 
	get():
		return outline_material.get_shader_parameter("color")
	set(value):
		outline_material.set_shader_parameter("color",value)

@export var walk_animation_speed : float : 
	get():
		if $template_psx_charter/AnimationTree != null:
			return $template_psx_charter/AnimationTree.get("parameters/walk/blend_position")
		return 0
	set(value):
		if $template_psx_charter/AnimationTree != null:
			$template_psx_charter/AnimationTree.set("parameters/walk/blend_position",value)

func shot() -> void:
	$template_psx_charter/AnimationTree.set("parameters/OneShot/request","fire")

var game_mode : int = 0

func enter_trtiger_area(body : Node) -> void:
	if body is NetGuner:
		game_mode = 1
		print("new target")




@export var triger_area : Area3D 
func _ready() -> void:
	if not Engine.is_editor_hint():
		if triger_area != null:
			triger_area.body_entered.connect(enter_trtiger_area)

func idle_mode(delta: float) -> void:
	walk_animation_speed = 0

enum EnemyTypes {
	death = -1,
	vunerable = 0,
	invunerable = 1,
	fast = 2,
	strong = 3,
}

@export var enemy_type : EnemyTypes

func action_mode(delta: float) -> void:
	walk_animation_speed = 0
	velocity = Vector3.ZERO
	move_and_slide()

@export var hacks : Array[Hack]

func _physics_process(delta: float) -> void:
	if not Engine.is_editor_hint():
		
		if game_mode == 0:
			idle_mode(delta)
		elif game_mode == 1:
			action_mode(delta)

func explode() -> void:
	$death_explosion.emitting = true
	$template_psx_charter.visible = false
	$CollisionShape3D.disabled = true
	$AudioStreamPlayer3D.play()

func get_shot() -> void:
	if true:
		explode()

func hack(hack_name : String) -> void:
	if hack_name == "kill":
		enemy_type = EnemyTypes.death
		explode()

func get_hack_list() -> Array[Hack]:
	var ha : Array[Hack]
	
	if enemy_type == EnemyTypes.vunerable:
		var h : Hack = Hack.new()
		h.hack_name = "kill"
		h.hack_text = "kill"
		h.hack_color = Color.RED
		ha.append(h)
	
	return ha


func self_destruct() -> void:
	queue_free()
