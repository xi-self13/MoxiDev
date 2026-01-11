extends PlayerState


@onready var ray_cast_3d: RayCast3D = $"../../RayCast3D"



func enter(previous_state_path: String, data := {}) -> void:
	player.camera_3d.fov = lerp(player.camera_3d.fov, player.start_fov, get_physics_process_delta_time() * 30)
	player.movement_speed = 5.0
	player.ap.play("Walkbasic")

func physics_update(delta: float) -> void:
	## Basically you just add these 4 lines of code and the move and slide if you want the player to be able
	## to move in this State
	var input_dir := Input.get_vector("left", "right", "fowards", "back")
	var direction := (player.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	player.velocity.x = direction.x * player.movement_speed
	player.velocity.z = direction.z * player.movement_speed

	# Coyote time update
	if player.coyote_jump_timer > 0.0:
		player.coyote_jump_timer -= delta

	# Jump buffering
	if Input.is_action_just_pressed("jump"):
		player.jump_buffered = true
	player.stamina_rebuild()
	player.move_and_slide()

	## right at the end of the phyisics update or update function you write the conditions that will make 
	## the state to change like not being on the floor that means you are falling, or pressing the keys to move, etc
	if not player.is_on_floor():
		finished.emit(FALLING) #you emit the signal falling, you can add new states at player_state.gd
	elif player.jump_buffered and (player.is_on_floor() or player.coyote_jump_timer > 0.0):
		finished.emit(JUMPING)
	elif is_equal_approx(player.velocity.x, 0.0) and is_equal_approx(player.velocity.z,0.0):
		finished.emit(IDLE)
	elif Input.is_action_pressed("sprint"):
		if player.stamina_current > 0:
			finished.emit(RUN)
	elif Input.is_action_pressed("crouch"):
		if !ray_cast_3d.is_colliding():
			finished.emit(CROUCH)
