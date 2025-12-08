extends Control

func _ready() -> void:
	pass

func _on_quit_pressed() -> void:
	GameManager.save_game()
	get_tree().quit()
