extends PlayerState

#I am pretty sure that this is possible to simplify a little bit but i was more worried for making the other states work

func respawn():
	if player.was_dead == true:
		player.diedscreen.visible = false
		player.current_health = 100
		player.position = Vector3(0,6,0)
		player.movement_speed = 5.0
		player.camera_3d.rotation.y = 0
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		player.camera_3d.projection = Camera3D.PROJECTION_PERSPECTIVE
		player.camera_3d.fov = lerp(20.0, player.start_fov, 0.05)
		player.camera_3d.position = player.camera_3d.position.lerp(player.cameraStartPos, 1.0)
		player.was_dead = false
		finished.emit(IDLE)

func enter(previous_state_path: String, data := {}) -> void:
	if player.perma_death == true:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		player.camera_3d.rotation.y += 5.0 / 1000 # camera goes around
		player.camera_3d.position += player.camera_3d.position.lerp(Vector3(0, 1, 0), 1.0) / 10
		player.camera_3d.projection=Camera3D.PROJECTION_FRUSTUM
		player.movement_speed = 0 # FREEZE! if anything, touch will be useless to move on MobileUi and DesktopUi because the deathscreen is over it!
		player.diedscreen.diedtype = "unknown_perma"
		player.diedscreen.died() # suppose to call the death screen, but i dont know if Godot works this away. (it does)
		player.diedscreen.visible = true
		player.diedscreen.add_desc("you have been... vanished? FOREVER!!!")
		player.delay(5.0)
		player.diedscreen.add_desc("Restart your game... idk. like. sure, go, bye.")
		player.delay(5.0)
		player.diedscreen.add_desc("and we repeat.")
	elif player.perma_death == false:
		player.was_dead = true
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		player.camera_3d.rotation.y += 5.0 / 100 # camera goes around
		player.camera_3d.position += player.camera_3d.position.lerp(Vector3(0, 1, 0), 1.0)
		player.camera_3d.projection=Camera3D.PROJECTION_FRUSTUM
		player.movement_speed = 0 # FREEZE! if anything, touch will be useless to move on MobileUi and DesktopUi because the deathscreen is over it!
		player.diedscreen.diedtype = "unknown"
		player.diedscreen.died()  # suppose to call the death screen, but i dont know if Godot works this away. (it does)
		player.diedscreen.add_desc("... wow.. a round pipe killed you... sad...")
		player.diedscreen.visible = true
		await get_tree().create_timer(5.0).timeout
		respawn()
func physics_update(_delta: float) -> void:
	pass
