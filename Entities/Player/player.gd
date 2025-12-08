extends CharacterBody3D

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

@onready var camera_3d: Camera3D = $Camera3D
@onready var cameraStartPos: Vector3 = $Camera3D.position
@onready var start_fov := camera_3d.fov
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

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	start_cam = $Camera3D.position.y
	start_coll = $CollisionShape3D.scale.y

func _physics_process(delta: float) -> void:
	if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
		return

	mouse_motion = mouse_motion.lerp(target_mouse_motion, mouse_smoothing_speed * delta)
	camera_rotation()

	# Gravity & falling
	if not is_on_floor():
		if velocity.y >= 0:
			velocity += get_gravity() * delta
		else:
			velocity += get_gravity() * delta * 0.5 * fall_multi

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

	# Sprint
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
		time_passed += delta * 6.0
		$Camera3D.position.y = cameraStartPos.y + sin(time_passed) * 0.1

		velocity.x = direction.x * movement_speed
		velocity.z = direction.z * movement_speed
	else:
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

func camera_rotation() -> void:
	rotate_y(mouse_motion.x)
	$Camera3D.rotate_x(mouse_motion.y)
	$Camera3D.rotation_degrees.x = clamp($Camera3D.rotation_degrees.x, -90.0, 90.0)
	target_mouse_motion = Vector2.ZERO
