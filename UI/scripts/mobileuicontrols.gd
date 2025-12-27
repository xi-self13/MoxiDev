extends Control

@onready var psetpanel = $PanelContainer
@onready var player = $"../"
# Called when the node enters the scene tree for the first time.

# Shows this ui if its either Android or iOS
func _ready() -> void:
	print("(Server): Mobile Controls Enabled")
	print("Running on " + str(OS.get_distribution_name()))
	if OS.get_distribution_name() == "iOS" or OS.get_distribution_name() == "Android":
		self.visible = true
	else: 
		self.visible = false


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





func _on_flashlight_toggle(toggled_on: bool) -> void:
	if toggled_on == true:
		Input.action_press("temporary_controls.dev.flashlight")
	elif toggled_on == false:
		Input.action_release("temporary_controls.dev.flashlight")


func _on_player_pressed() -> void:
	player.current_health -= 5


func _on_chat_panel_pressed() -> void:
	$ChatPanel.visible = true
