extends PlayerState
#change the properties for the run multiplier and Stamina drain, player runs at insane speeds
func enter(previous_state_path: String, data := {}) -> void:
	player.ap.play("run")
	player.camera_3d.fov = lerp(player.camera_3d.fov, player.start_fov / player.zoom_multiplier, get_physics_process_delta_time() * 20.0)	

func physics_update(delta: float) -> void:
	var input_dir := Input.get_vector("left", "right", "fowards", "back")
	var direction := (player.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	player.movement_speed = lerp(player.movement_speed, player.startSpeed * player.runMulti, 0.2)
	player.velocity.x = direction.x * player.movement_speed
	player.velocity.z = direction.z * player.movement_speed
	# Coyote time update
	if player.coyote_jump_timer > 0.0:
		player.coyote_jump_timer -= delta

	# Jump buffering
	if Input.is_action_just_pressed("jump"):
		player.jump_buffered = true
	
	player.move_and_slide()
	
	###Stamina drain
	player.stamina_current -= 10 * delta


	if not player.is_on_floor():
		finished.emit(FALLING)
	elif player.jump_buffered and (player.is_on_floor() or player.coyote_jump_timer > 0.0):
		finished.emit(JUMPING)
	elif is_equal_approx(player.velocity.x, 0.0) and is_equal_approx(player.velocity.z,0.0):
		finished.emit(IDLE)
	elif player.stamina_current < 0 or !Input.is_action_pressed("sprint"):
		finished.emit(WALKING)
