extends PlayerState

func physics_update(delta: float) -> void:
    player.movement_speed = lerp(player.movement_speed, 0.0, 0.2)
    player.velocity.x = 0.0
    player.velocity.z = 0.0
    player.camera_3d.fov = lerp(player.camera_3d.fov, player.start_fov, get_physics_process_delta_time() * 20.0)	

    if not player.is_on_floor():
        if player.velocity.y >= 0:
            player.velocity += player.get_gravity() * delta
        else:
            player.velocity += player.get_gravity() * delta * 0.5 * player.fall_multi

    if not player.is_on_floor():
        finished.emit(FALLING)
    if %ChatPanel.visible == false:
        finished.emit(IDLE)