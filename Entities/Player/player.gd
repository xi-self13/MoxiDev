extends CharacterBody3D
class_name Player

# TODO! 12/25/25 10:48 PM Central USA Time
# stamina and the stamina_rebuild() is broken. For some reason
# it causes the game engine/game to hang.
#
# Its commented and set aside while we still use the previous working
# codes.
# 
# once done, see if we is able to implement stamina!
# after stamina, I (XiLy) will work out how to setup health
# and effects (buffs and debuffs) to work!
# 
# Optimize if needed.
# Happy holidays and happy coding!
# - XiLy

# All changes here was made by XiLy

signal on_respawn
signal on_died
signal on_low_health_threshold
signal _on_ghosted

# Normally you want to keep in here the properties of the player and functions that will be used for more than one state
#-EC
@export_category("Player Body Config")
@export var stamina_current : float = 100.0
@export var stamina_max : float = 100.0
@export var movement_speed := 5.0
@export var attack := 10.0
@export var defence := 10.0
@export var current_health := 100.0
@export var max_health := 100.0
@export var damage := 20.0
@export var experience := 0.0
@export var level := 0.0
@export var runMulti: float = 4
@export var fall_multi: float = 2.5
@export var jump_height: float = 1.0
@export var coyote_time: float = 0.1
@export var mouse_sensitivity: float = 0.003
@export var mouse_smoothing_speed: float = 12.0
@export_category("Extra Stats")
@export var sanity_max : float = 100.0
@export var sanity_current : float = 100.0
@export var hunger_max : float = 20.0
@export var hunger_current : float = 20.0
@export var sickness_current : float = 0.0
@export var sickness_max : float = 10.0
@export var happiness_max : float = 1.0
@export var happiness_current : float = 1.0
@export_category("Player Profile")
@export var username : String
@export var display_name : String
@export_category("Player Death Option")
@export var perma_death : bool = false # perma death. temporarily enabled by default to save us time to code the actual now broken respawn system
@export var is_ghosted : bool = false 

# What changed here?
# defined stamina Bar.
@onready var areaofdeath = %Area3D
@onready var head = $Girl/Girl/Body/Head
@onready var ap: AnimationPlayer = $Girl/AnimationPlayer
@onready var camera_3d: Camera3D = $Camera3D
@onready var cameraStartPos: Vector3 = $Camera3D.position
@onready var start_fov := camera_3d.fov
@onready var diedscreen = $YouDied
@onready var staminabar = $MobileUi/Stats/staminabar
@onready var healthbar = $MobileUi/Stats/Healthbar



# No change made...
var zoom_multiplier := 1
var target_mouse_motion: Vector2 = Vector2.ZERO
var mouse_motion: Vector2 = Vector2.ZERO
var coyote_jump_timer: float = 0.0
var jump_buffered: bool = false
var was_on_floor: bool = false
var is_crouching := false
var startSpeed := movement_speed
var time_passed := 0.0
var start_cam
var start_coll


# What changed here? Set .max_value, .value to be synced to varibles that were defined now.
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	start_cam = $Camera3D.position.y
	start_coll = $CollisionShape3D.scale.y
	staminabar.max_value = stamina_max # [Fixed... the node was in the wrong path...] Xogot decided to cancel this variable after it worked!? Check if Godot itself is okay with this attribute.
	staminabar.value = stamina_current
	healthbar.max_value = max_health
	healthbar.value = current_health
	camera_3d.near = 0.1

# Optimized animations and corrected a few mistakes.
func _physics_process(delta: float) -> void:
	var flashlight := $Camera3D/SpotLight3D

	# Lerp the flashlight rotation to follow the camera smoothly
	var flashlight_speed := 5.0
	flashlight.rotation = flashlight.rotation.lerp(camera_3d.rotation, flashlight_speed * delta)
	var flashlight_offset := Vector3(0, 1, 0)
	flashlight.global_position = flashlight.global_position.lerp(camera_3d.global_transform.origin + camera_3d.global_transform.basis * flashlight_offset, flashlight_speed * delta)
	# temporary for testing...
	if Input.is_action_pressed("temporary_controls.dev.flashlight"):
		$Camera3D/SpotLight3D.visible = true
	else: 
		$Camera3D/SpotLight3D.visible = false
	# Keep stats refreshing
	staminabar.value = stamina_current
	healthbar.value = current_health

	if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
		return
	mouse_motion = mouse_motion.lerp(target_mouse_motion, mouse_smoothing_speed * delta)
	# camera_rotation()
	camera_rotation()

	
	# OnDied!
	#if current_health == 0:
	#	diedscreen.died()
	#	diedscreen.diedtype = "unknown"
	#	diedscreen.visible = true
	#else: 
	#	diedscreen.visible = false
		
	
	check_is_dead()


	was_on_floor = is_on_floor()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		target_mouse_motion = -event.relative * mouse_sensitivity
#		if event.pressed:
#			ap.play("combat_fist")

# Whats this?
# Suppose to handle death screen.
# TODO! Fix the you died screen.
func _process(delta: float) -> void:
	pass
	#if Input.is_action_just_pressed("mouse_release"):
		#Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	#var diedpos : Vector3
	#var did_died : bool

func stamina_rebuild(): 
	if stamina_current < stamina_max and !Input.is_action_pressed("sprint"):
		staminabar.value += 5
		stamina_current += 5 * get_physics_process_delta_time()
	# The stamina was going off limits, this will make sure never goes past the maximum or minimum - EC
	if stamina_current > stamina_max:
		stamina_current = stamina_max
	elif stamina_current < -1:
		stamina_current = 0

# Nothing...
func camera_rotation() -> void:
	rotate_y(mouse_motion.x)
	#$Camera3D.rotate_y(mouse_motion.x)
	$Camera3D.rotate_x(mouse_motion.y)
	$Camera3D.rotation_degrees.x = clamp($Camera3D.rotation_degrees.x, -90.0, 90.0)
	#$Camera3D.rotation_degrees.y = clamp($Camera3D.rotation_degrees.y, -90.0, 90.0)
	target_mouse_motion = Vector2.ZERO
	head.rotation = $Camera3D.rotation # head moves when camera moves

# Not needed, but in case...
func _on_body_entered(body: Player) -> void:
	if body:
		current_health = 0
@onready var ap1 = $Camera3D
signal rotcam

# TODO! Fix this to where first person camera rotates
# but in third person not!
func _on_pov_selected(index: int) -> void:
	
	if index == 0:
		# Third Person
		ap1.rotation = ap1.rotation.lerp(Vector3(-0, 22.6, 0), 1.0)
		ap1.position = ap1.position.lerp(Vector3(2, 1.32, 2.11), 1.0)
	
	elif index == 1:
		# First Person
		ap1.position = ap1.position.lerp(Vector3(0, 1.86, 1), 1.0)
		ap1.rotation = ap1.rotation.lerp(Vector3(0,0,0), 1.0)
		rotcam.emit()


func _on_mobile_ui_pressed_killplayer() -> void:
	current_health = 0
	print(str(current_health))


func _on_kill_plsettings() -> void:
	var c = $MobileUi/PanelContainer
	c.visible = false




func delay(sec : float):
	var t = get_tree().create_timer(sec)
	await t.timeout


func _on_current_health_changed(value: float) -> void:
	healthbar.position += Vector2(randf_range(1,-1), randf_range(1,-1))
	delay(2.0)
	healthbar.position = Vector2(712, 552)



func _on_health_changed(value: float) -> void:
	camera_3d.position += lerp(cameraStartPos, Vector3(0, 0.5, 0), 1)
	delay(.5)
	camera_3d.position = camera_3d.position.lerp(cameraStartPos, 1)

var was_dead : bool = false

func check_is_dead():


		#camera_3d.position = lerp(Vector3(7, 8, 9), Vector3(0, 1.37787, -0)
		
		#diedpos = camera_3d.positio
		
	if current_health < 20:
		on_low_health_threshold.emit()
		camera_3d.fov = 60
		camera_3d.position = (Vector3(randf_range(-0.05,0.05), randf_range(-0.05,0.05), 0) + Vector3(0, 1.37787, -0.29387))
	elif current_health == 100 and was_dead == true:
		pass
