extends Panel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_settings_pressed() -> void:
	var SettingsWindows: Window = %SettingsWindow
	SettingsWindows.visible = true


func _on_settings_window_close_requested() -> void:
	var SettingsWindows: Window = %SettingsWindow
	SettingsWindows.visible = false
