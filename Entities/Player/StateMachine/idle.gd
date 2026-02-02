extends PlayerState

@onready var ray_cast_3d: RayCast3D = $"../../RayCast3D"


func enter(previous_state_path: String, data := {}) -> void:
	player.ap.play("Idle1")
	player.diedscreen.visible = false

func physics_update(delta: float) -> void:
	var input_dir := Input.get_vector("left", "right", "fowards", "back")
	if not player.is_on_floor():
		if player.velocity.y >= 0:
			player.velocity += player.get_gravity() * delta
		else:
			player.velocity += player.get_gravity() * delta * 0.5 * player.fall_multi
	player.move_and_slide()
	player.stamina_rebuild()
	# Coyote time update
	if player.coyote_jump_timer > 0.0:
		player.coyote_jump_timer -= delta

	# Jump buffering
	if Input.is_action_just_pressed("jump"):
		player.jump_buffered = true
	
	if not player.is_on_floor():
		finished.emit(FALLING)
	elif player.jump_buffered and (player.is_on_floor() or player.coyote_jump_timer > 0.0):
		finished.emit(JUMPING)
	elif input_dir:
		finished.emit(WALKING)
	elif Input.is_action_pressed("crouch"):
		if !ray_cast_3d.is_colliding():
			finished.emit(CROUCH)
