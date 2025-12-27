extends Node
class_name TimeManager
# note to Freewave, set this as a global as my editor (Xogot) cannot perform this action due to payment.
# - XiLy
@export_category("Sun Properties")
@export var time_speed : int = 5000
@export var sun_node : DirectionalLight3D

var seconds = Time.get_ticks_usec()

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

func start_day_night(timespeed : float):
	var m = 0.0
	m += (timespeed + seconds)
	sun_node.rotation += Vector3(1,7,2) / m * (timespeed * 2)
	var v = 0
	# TODO! Add a proper time conversion where it outputs time and other features.
	return v

func _process(_delta: float) -> void:
	var r = start_day_night(1000)
	var l = %Times
	l.text = str(r)