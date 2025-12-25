extends Control

func _ready() -> void:
	pass

func _on_quit_pressed() -> void:
	GameManager.save_game()
	get_tree().quit()

@onready var filesys = FileDialog.new()

func _on_showsdir_h() -> void:
	filesys.popup_centered()
	filesys.access = FileDialog.ACCESS_USERDATA
	filesys.visible = true
	filesys.show()
