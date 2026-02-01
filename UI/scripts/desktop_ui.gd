extends Control

func _input(event: InputEvent) -> void:
    if event.is_action_pressed("chat_key"):
        %ChatPanel.show()
        Input.mouse_mode = Input.MOUSE_MODE_VISIBLE