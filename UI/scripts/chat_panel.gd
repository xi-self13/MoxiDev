extends Control
class_name ChatPanel


@onready var ChatInput = $ChatInput
@onready var ChatOutput = $ChatOutput

@onready var toast = preload("res://UI/ToastUi.tscn")

var chat_config = ConfigFile.new()

@export_category("Commands Settings")
@export var commandPrefix : String = "/"
@export var commands_extra : Dictionary


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if GameManager.platform == "Mobile":
		$Bye.show()
	else:
		$Bye.hide()
	pass # Replace with function body.

signal on_chat()
signal on_runcommand(command_a)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		self.visible = false
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	pass

func save_chat_data():
	chat_config.set_value("chat_config", "username", "Moxira Kira Froxer")
	chat_config.save("user://GameConfig/chat_configurations.config")
	

func output_newline(text : String):
	ChatOutput.add_text(text)
	ChatOutput.newline()


func run_command(command_name : String, arg : Array):
	on_runcommand.emit()
	var cp = commandPrefix
	if command_name == (cp + "help"):
		output_newline("Their are multiple commands avaliable")
		output_newline("/help: displays this menu")
		output_newline("""
		/save: saves the configuration for chat
		/kill: suppose to kill <entity>
		/delete: delete who? me? No. this command is not implemented
		/whoru: About me!
		Thank you for using help model. Please proceed with a command. Or chat!
		""")
	elif command_name == (cp + "kill"):
		output_newline("""
		
		Kill who? I don't know. I don't know how to accept arguments yet. Please wait for my creator(s) to implement it!
		
		""")
	elif command_name == (cp + "save"):
		output_newline("Saving...")
		save_chat_data()
		var conf = chat_config.load("user://GameConfig/chat_configurations.config")
		if conf != OK:
			printerr("Sadly we cannot find the chat_configs... either it didn't write or I don't know what... Check chat_panel.gd")
			output_newline("Sadly... the configuration file didn't saved! check to see if anything happened in chat_panel.gd")
			return "configurational error :("
		elif conf == OK:
			output_newline("I have successfully done the action for you!")
		else:
			output_newline("I don't know what happened! Unknown, and a mystery...")
	elif command_name == (cp + "whoru"):
		output_newline("""
		Who am I? I am a chat system created by XiLy. The creator of this game.
		
		'She' wanted me to be somewhat alive? I don't know. I am just here
		being your chat system...
		""")
	else:
		output_newline("""
		That's not a valid command silly...
		attempted to use a invalid command set. :(
		""")


func _on_text_submitted(new_text: String) -> void:
	if "/" in ChatInput.text:
		run_command(new_text, [])
	else:
		on_chat.emit()
		output_newline(": unknown > " + new_text)
		#toast.send_toast("chat: " + new_text, 2.0)


func _on_pressed() -> void:
	self.visible = false
