extends Window
const MAINMENU_ENV_TRESA = preload("res://assets/mainmenu.env.tresa.tres")


func _on_check_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		%WE.environment = null
	else:
		%WE.environment = MAINMENU_ENV_TRESA
