extends PlayerState

@onready var camera_3d: Camera3D = $"../../Camera3D"

@onready var collision_shape_3d: CollisionShape3D = $"../../CollisionShape3D"


func enter(previous_state_path: String, data := {}) -> void:
	player.movement_speed = 2
	player.camera_3d.fov = lerp(player.camera_3d.fov, player.start_fov, get_physics_process_delta_time() * 30)
	camera_3d.position.y = lerp(camera_3d.position.y, player.start_cam - 0.2, 0.2)
	collision_shape_3d.scale.y = lerp(collision_shape_3d.scale.y, player.start_coll - 0.2, 0.2)
	player.ap.play("CrouchDown", -1, 0.5)
	await player.ap.animation_finished

func physics_update(delta: float) -> void:
	var input_dir := Input.get_vector("left", "right", "fowards", "back")
	var direction := (player.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	player.velocity.x = direction.x * player.movement_speed
	player.velocity.z = direction.z * player.movement_speed
	player.move_and_slide()
	player.stamina_rebuild()
	
	#You can change this to just pressed if you want to toggle crouch instead of having to hold it
	if Input.is_action_just_released("crouch"):
		if is_equal_approx(player.velocity.x, 0.0) and is_equal_approx(player.velocity.z,0.0):
			finished.emit(IDLE)
		else:
			finished.emit(WALKING)

func exit():
	camera_3d.position.y = lerp(camera_3d.position.y, player.start_cam, 0.2)
	collision_shape_3d.scale.y = lerp(collision_shape_3d.scale.y, player.start_coll, 0.2)
	player.movement_speed = 5
	player.ap.play_backwards("CrouchDown")
	await player.ap.animation_finished
