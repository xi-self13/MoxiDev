extends PlayerState

func enter(previous_state_path: String, data := {}) -> void:
	player.velocity.y = sqrt(player.jump_height * 2 * -player.get_gravity().y)
	player.jump_buffered = false
	player.coyote_jump_timer = 0.0
	#player.ap.play("jump")

func physics_update(delta: float) -> void:
	if not player.is_on_floor():
		if player.velocity.y >= 0:
			player.velocity += player.get_gravity() * delta
		else:
			player.ap.play_backwards("Falling")
			player.velocity += player.get_gravity() * delta * 0.5 * player.fall_multi
	
	
	var input_dir := Input.get_vector("left", "right", "fowards", "back")
	var direction := (player.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	player.velocity.x = direction.x * player.movement_speed
	player.velocity.z = direction.z * player.movement_speed
	player.move_and_slide()

	if player.velocity.y <= 0:
		finished.emit(FALLING)
