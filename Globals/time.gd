extends Node
#class_name TimeManager
# note to Freewave, set this as a global as my editor (Xogot) cannot perform this action due to payment.
# - XiLy
@export_category("Sun Properties")
@export var ticks_per_second: float = 60.0 ## 1 tick = 1 second in real life

enum Weather { NORMAL, RAINY, STORMY }

@export var current_weather: Weather = Weather.NORMAL
@export var weather_change_interval: float = 300.0  # Change weather every 5 minutes (in game time)

var sun_node : DirectionalLight3D
var weather_timer: float = 0.0
var rain_node: GPUParticles3D

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
		# Create rain effect node
		rain_node = GPUParticles3D.new()
		rain_node.script = load("res://Globals/rain_effect.gd")
		rain_node.visible = false
		rain_node.position = Vector3(0, 20, 0)  # Position above the scene for rain to fall
		get_tree().current_scene.add_child(rain_node)
	change_weather()  # Initialize weather

func time_repeat(delta: float):
	seconds += delta * ticks_per_second
	if seconds >= 60.0:
		seconds = 0
		minutes += 1
	if minutes >= 60:
		minutes = 0
		hours += 1
	if hours >= 24:  #A new day has began
		hours = 0
		minutes = 0
		seconds = 0
		print_debug("A new day has begun!")
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




func change_weather():
	var rand = randi() % 3
	current_weather = Weather.values()[rand]
	print("Weather changed to: ", Weather.keys()[current_weather])

func update_weather_effects():
	if not sun_node:
		return
	
	var base_energy = 1.0
	match current_weather:
		Weather.NORMAL:
			sun_node.light_energy = base_energy
			if rain_node:
				rain_node.visible = false
		Weather.RAINY:
			sun_node.light_energy = base_energy * 0.7  # Dimmer for rain
			if rain_node:
				rain_node.visible = true
				rain_node.rain_intensity = 1.0
		Weather.STORMY:
			sun_node.light_energy = base_energy * 0.4  # Even dimmer for storm
			if rain_node:
				rain_node.visible = true
				rain_node.rain_intensity = 2.0  # Heavier rain for storm




func _process(delta: float) -> void:
	if sun_node:
		var t = time_repeat(delta)
		weather_timer += delta * ticks_per_second
		if weather_timer >= weather_change_interval:
			weather_timer = 0.0
			change_weather()
		update_weather_effects()
