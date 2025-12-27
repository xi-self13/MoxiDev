extends Control

@onready var ChatInput = $ChatInput
@onready var ChatOutput = $ChatOutput

@export_category("Commands Settings")
@export var commandPrefix : String = "/"
@export var commands_extra : Dictionary


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func run_command(command_name : String):
	var cp = commandPrefix
	if command_name == (cp + "help"):
		ChatOutput.add_text("completion is below... ones with a * is not implemented")
		ChatOutput.newline()
		ChatOutput.append_text("help *tp *kill *playap *play *killserver *startserver")
		ChatOutput.newline()
	elif command_name == (cp + "kill"):
		ChatOutput.append_text("Feature not implemented, the chat does not know how to accept args")
		ChatOutput.newline()
	else:
		ChatOutput.append_text("(Error) Not a valid command silly... (tried to use: " + command_name + ") but failed...")


func _on_text_submitted(new_text: String) -> void:
	if commandPrefix in ChatInput.text:
		run_command(new_text)
	else:
		ChatOutput.append_text("< Unknown data user > " + new_text)
		ChatOutput.newline()
	ChatInput.text = ""


func _on_pressed() -> void:
	self.visible = false
