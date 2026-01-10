extends Control

@export_category("Player's Profile")

@onready var uf = $Panel/ScrollContainer/VBoxContainer/Username
@onready var bio = $Panel/ScrollContainer/VBoxContainer/Bio



func save_data():
	OS.request_permissions()
	var save = FileAccess.open("user://PlayerData/" + uf.text + "/beingdata.plr", FileAccess.WRITE)
	var _data = {
		"username" : uf.text,
		"bio" : bio.text
	}
	save.store_line("Hi... i guess?") # testing to see if the file stores a line
	save.flush()

func load_player_data():
	var save = FileAccess.open("user://PlayerData/"+uf.text+"/beingdata.plr",FileAccess.READ)
	var data = save.get_line()
	return data

func _on_pressed() -> void:
	save_data()
