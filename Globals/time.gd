extends Node
#class_name TimeManager
# note to Freewave, set this as a global as my editor (Xogot) cannot perform this action due to payment.
# - XiLy
@export_category("Sun Properties")
@export var time_speed : int = 5000
@export var sun_node : DirectionalLight3D

var current_time : float
#func GetDirectionalLightNode():
#	var tree = get_tree()
#	return tree.current_scene.get_node(%Sun)

func time_set_forward(_forward_to_usec : int): pass
	#var sun_node = GetDirectionalLightNode()
#	sun_node.rotation += forward_to_usec

# i dont know right now, ill comeback here. - XiLy
func time_get(): pass
	#var sun_node = GetDirectionalLightNode()
	#var sun_rot = int(sun_node.rotation)
#
signal timeout_delay


func delay(sec : float):
	var s = sec
	while s != 0:
		print("(time.gd L30): time" + str(s) )
		s -= .1
		if s <= 0:
			timeout_delay.emit()
			break


func start_day_night(timespeed : float):
	if not sun_node:
		#printerr("No node set for sun... is you using it for timer instead?")
		return "no... sun"
	var m = 0.0
	m += (timespeed + current_time)
	sun_node.rotation += Vector3(1,7,2) / m * (timespeed * 2) / 10000.0
	var v = 0
	# TODO! Add a proper time conversion where it outputs time and other features.
	return v


@onready var g = $Label3D

func time_repeat(delta : float):
	current_time += 3.0 * delta
	if current_time == 24.0:
		current_time -= 24.0


func _process(delta: float) -> void:
	var _r = start_day_night(1000)
	var t = time_repeat(delta)
