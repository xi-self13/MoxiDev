extends CharacterBody3D
class_name Player

# TODO! 12/25/25 10:48 PM Central USA Time
# Stanima and the stanima_rebuild() is broken. For some reason
# it causes the game engine/game to hang.
#
# Its commented and set aside while we still use the previous working
# codes.
# 
# once done, see if we is able to implement stanima!
# after stanima, I (XiLy) will work out how to setup health
# and effects (buffs and debuffs) to work!
# 
# Optimize if needed.
# Happy holidays and happy coding!
# - XiLy

# All changes here was made by XiLy

# What changed here. In the exports.
# Organized it some, and added stanima variables.
@export_category("Player Body Config")
@export var stanima_current : float = 100.0
@export var stanima_max : float = 100.0
@export var movement_speed := 5.0
@export var attack := 10.0
@export var defence := 10.0
@export var current_health := 100.0
@export var max_health := 100.0
@export var damage := 20.0
@export var experience := 0.0
@export var level := 0.0
@export var runMulti: float = 1.5
@export var fall_multi: float = 2.5
@export var jump_height: float = 1.0
@export var coyote_time: float = 0.1
@export var mouse_sensitivity: float = 0.003
@export var mouse_smoothing_speed: float = 12.0
@export_category("Player Profile")
@export var user_save_file : JSON

# What changed here?
# defined Stanima Bar.
@onready var areaofdeath = %Area3D
@onready var head = $Girl/Girl/Body/Head
@onready var ap: AnimationPlayer = $Girl/AnimationPlayer
@onready var camera_3d: Camera3D = $Camera3D
@onready var cameraStartPos: Vector3 = $Camera3D.position
@onready var start_fov := camera_3d.fov
@onready var diedscreen = $YouDied
@onready var stanimabar : ProgressBar #= $MobileUi/Stats/stanimabar # Commented for later use after we fix the hanging problem...
@onready var healthbar = $MobileUi/Stats/Healthbar

# No change made...
var zoom_multiplier := 0.7
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
	#stanimabar.max_value = stanima_max # [Fixed... the node was in the wrong path...] Xogot decided to cancel this variable after it worked!? Check if Godot itself is okay with this attribute.
	#stanimabar.value = stanima_current
	healthbar.max_value = max_health
	healthbar.value = current_health

# Optimized animations and corrected a few mistakes.
func _physics_process(delta: float) -> void:
	# temporary for testing...
	if Input.is_action_pressed("temporary_controls.dev.flashlight"):
		$Camera3D/SpotLight3D.visible = true
	else: 
		$Camera3D/SpotLight3D.visible = false
	# Keep stats refreshing
	#stanimabar.value = stanima_current
	healthbar.value = current_health
	# Idle
	if ap.current_animation == "":
		ap.play("Idle1")
	if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
		return
	mouse_motion = mouse_motion.lerp(target_mouse_motion, mouse_smoothing_speed * delta)
	# camera_rotation()
	camera_rotation()

	# Gravity & falling
	if not is_on_floor():
		if velocity.y >= 0:
			ap.play("Falling")
			velocity += get_gravity() * delta
		else:
			ap.play_backwards("Falling")
			velocity += get_gravity() * delta * 0.5 * fall_multi
	if was_on_floor and velocity.y > 1:
		current_health -= 2
	# Coyote time update
	if coyote_jump_timer > 0.0:
		coyote_jump_timer -= delta

	# Jump buffering
	if Input.is_action_just_pressed("jump"):
		jump_buffered = true

	# Crouch
	if Input.is_action_pressed("crouch"):
		$Camera3D.position.y = lerp($Camera3D.position.y, start_cam - 0.2, 0.2)
		$CollisionShape3D.scale.y = lerp($CollisionShape3D.scale.y, start_coll - 0.2, 0.2)
		movement_speed = 2
		camera_3d.fov = lerp(camera_3d.fov, start_fov, delta * 30)
		is_crouching = true
	elif !$RayCast3D.is_colliding():
		$Camera3D.position.y = lerp($Camera3D.position.y, start_cam, 0.25)
		$CollisionShape3D.scale.y = lerp($CollisionShape3D.scale.y, start_coll, 0.25)
		if !Input.is_action_pressed("sprint"):
			movement_speed = 5
		is_crouching = false
	# OnDied!
	#if current_health == 0:
	#	diedscreen.died()
	#	diedscreen.diedtype = "unknown"
	#	diedscreen.visible = true
	#else: 
	#	diedscreen.visible = false
		
	# Sprint and stanima
	#if stanima_current != 0: 
	#	if !Input.is_action_pressed("crouch") and Input.is_action_pressed("sprint") and !is_crouching:
	#		stanima_current -= 5
	#		movement_speed = lerp(movement_speed, startSpeed * runMulti, 0.2)
	#		camera_3d.fov = lerp(camera_3d.fov, start_fov / zoom_multiplier, delta * 20.0)
	#	else:
	#		camera_3d.fov = lerp(camera_3d.fov, start_fov, delta * 30)
	#		movement_speed = lerp(movement_speed, 5.0, 0.2)

	if !Input.is_action_pressed("crouch") and Input.is_action_pressed("sprint") and !is_crouching:
		movement_speed = lerp(movement_speed, startSpeed * runMulti, 0.2)
		camera_3d.fov = lerp(camera_3d.fov, start_fov / zoom_multiplier, delta * 20.0)
	else:
		camera_3d.fov = lerp(camera_3d.fov, start_fov, delta * 30)
		movement_speed = lerp(movement_speed, 5.0, 0.2)
	
	
	# Jump
	if jump_buffered and (is_on_floor() or coyote_jump_timer > 0.0):
		velocity.y = sqrt(jump_height * 2 * -get_gravity().y)
		jump_buffered = false
		coyote_jump_timer = 0.0

	# Movement input
	var input_dir := Input.get_vector("left", "right", "fowards", "back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction:
		if current_health != 0: 
			time_passed += delta * 6.0
			$Camera3D.position.y = cameraStartPos.y + sin(time_passed) * 0.1 / 3
			if Input.is_action_pressed("sprint"):
				ap.play("Run")
			else: 
				ap.play("Walkbasic")
			velocity.x = direction.x * movement_speed
			velocity.z = direction.z * movement_speed
		elif current_health == 0: 
			pass
	else:
			if Input.is_action_just_released("sprint") or Input.is_action_just_released("back") or Input.is_action_just_released("fowards") or Input.is_action_just_released("left") or Input.is_action_just_released("right"): 
				ap.stop()
			velocity.x = move_toward(velocity.x, 0, movement_speed)
			velocity.z = move_toward(velocity.z, 0, movement_speed)


	move_and_slide()

	# Update coyote jump
	if was_on_floor and not is_on_floor():
		coyote_jump_timer = coyote_time

	if not was_on_floor and is_on_floor():
		jump_buffered = false

	was_on_floor = is_on_floor()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		target_mouse_motion = -event.relative * mouse_sensitivity

# Whats this?
# Suppose to handle death screen.
# TODO! Fix the you died screen.
func _process(_delta: float) -> void:
	if current_health == 0:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		camera_3d.rotation.y += 5.0 / 1000 # camera goes around
		camera_3d.position.y = 5
		camera_3d.projection=Camera3D.PROJECTION_FRUSTUM
		movement_speed = 0 # FREEZE! if anything, touch will be useless to move on MobileUi and DesktopUi because the deathscreen is over it!
		diedscreen.died() # suppose to call the death screen, but i dont know if Godot works this away. (it does)
		diedscreen.diedtype = "unknown"
		diedscreen.visible = true
	elif current_health < 20:
		camera_3d.fov = 60
		camera_3d.position = (Vector3(randf_range(-0.2,0.2), randf_range(-0.2,0.2), 0) + Vector3(0, 1.37787, -0.29387))
	elif current_health == 100:
		camera_3d.rotation.y = 0
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		camera_3d.projection = Camera3D.PROJECTION_PERSPECTIVE
		camera_3d.fov = 80
		camera_3d.position = Vector3(0, 1.37787, -0.29397)
	else: 
		movement_speed = 5.0
		diedscreen.visible = false

# Nothing...
func camera_rotation() -> void:
	rotate_y(mouse_motion.x)
	$Camera3D.rotate_x(mouse_motion.y)
	$Camera3D.rotation_degrees.x = clamp($Camera3D.rotation_degrees.x, -90.0, 90.0)
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
		ap1.rotation = Vector3(-0, 22.6, 0)
		ap1.position = Vector3(2, 1.32, 2.11)
	
	elif index == 1:
		# First Person
		ap1.position = Vector3(0, 1.86, 1)
		ap1.rotation = Vector3(0,0,0)
		rotcam.emit()


func _on_mobile_ui_pressed_killplayer() -> void:
	current_health = 0
	print(str(current_health))


func _on_kill_plsettings() -> void:
	var c = $MobileUi/PanelContainer
	c.visible = false

# Warning! This code hangs the game.
func stanima_rebuild(): 
	while stanima_current != stanima_max:
		if stanima_current != stanima_max and !Input.is_action_pressed("sprint"):
			stanimabar.value += 5
