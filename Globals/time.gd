extends Node
#class_name TimeManager
# note to Freewave, set this as a global as my editor (Xogot) cannot perform this action due to payment.
# - XiLy
@export_category("Sun Properties")
@export var ticks_per_second: float = 60.0 ## 1 tick = 1 second in real life

var sun_node : DirectionalLight3D

var seconds : float
var minutes : float
var hours : int = 0 ##Change this to edit starting hour

func _ready() -> void:
	if get_tree().current_scene == Node3D:
		#Check if the current scene can be applied time
		#this way time doesn't passes when we are in the main menu 
		for i in get_tree().current_scene.get_children():
			if i is DirectionalLight3D:
				sun_node = i

func time_repeat(delta: float):
	seconds += delta * ticks_per_second
	if seconds >= 60.0:
		seconds = 0
		minutes += 1
	if minutes >= 60:
		minutes = 0
		hours += 1
	if hours >= 24:  #
		hours = 0
		minutes = 0
		seconds = 0
	update_sun_rotation()
	return str(hours,":",minutes,":",seconds)
	

func update_sun_rotation():
	if not sun_node:
		return
	
	
	var total_hours = hours + (minutes / 60.0) + (seconds / 3600.0)
	
	# 0 hours = midnight
	# 6 hours = morning 
	# 12 hours = mid-day or smth idk english
	# 18 hours = evening 
	# 24 hours = night
	
	var sun_angle = (total_hours / 24.0) * 360.0
	

	sun_node.rotation_degrees.x = -(sun_angle - 90.0)




func _process(delta: float) -> void:
	if sun_node:
		var t = time_repeat(delta)
