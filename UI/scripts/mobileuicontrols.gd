extends Control

@onready var psetpanel = $PanelContainer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_forward_down() -> void:
	Input.action_press("fowards")
func _on_forward_up() -> void:
	Input.action_release("fowards")
func _on_backward_down() -> void:
	Input.action_press("back")
func _on_backward_up() -> void:
	Input.action_release("back")
func _on_left_down() -> void:
	Input.action_press("left")
func _on_left_up() -> void:
	Input.action_release("left")
func _on_right_down() -> void:
	Input.action_press("right")
func _on_right_up() -> void:
	Input.action_release("right")


func _on_crouch_toggled(toggled_on: bool) -> void:
	if toggled_on == true:
		Input.action_press("crouch")
	else:
		Input.action_release("crouch")


func _on_sprint_toggled(toggled_on: bool) -> void:
	if toggled_on == true:
		Input.action_press("sprint")
	else:
		Input.action_release("sprint")


func _on_jump_up() -> void:
	Input.action_press("jump")
func _on_jump_down() -> void:
	Input.action_release("jump")


func _on_plsettings_pressed() -> void:
	psetpanel.visible = true
func _on_kill_plsettings() -> void:
	psetpanel.visible = false



