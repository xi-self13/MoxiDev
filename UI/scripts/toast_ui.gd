extends Control
#class_name ToastService

@export var toast_body : String

@onready var ap : AnimationPlayer = $ToastPanel/AnimationPlayer
@onready var body = $ToastPanel/ToastBody
func delay(sec : float):
	await get_tree().create_timer(sec).timeout

func send_toast(bods : String, time_to_go : float):
	body.text = bods
	ap.play("toasted")
	delay(time_to_go)
	ap.play_backwards("toasted")
	body.text = ""
