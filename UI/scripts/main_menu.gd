extends Control

@onready var cam : Camera3D = $Camera3D
@onready var sun : DirectionalLight3D = $DirectionalLight3D


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

func _process(_delta: float) -> void:
	cam.rotation += Vector3(2, 5, 1) / 500
	sun.rotation += Vector3(1, 3, 8) / 500
