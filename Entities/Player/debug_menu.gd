extends Node
@export var UINode: Control


var debug_menu : Panel
var texto : String = ""
var fps : float


var player : Player

func _ready() -> void:
	player = get_parent()

func _enter_tree() -> void:
	#Builds the debug menu
	if UINode:
		var debug_panel = Panel.new()
		debug_panel.pivot_offset = Vector2(860/2,242/2)
		debug_panel.size = Vector2(860,242)
		debug_panel.hide()
		var debug_label = Label.new()
		debug_label.name = "debug_label"
		debug_label.text = ""
		debug_label.set_anchors_preset(Control.PRESET_FULL_RECT)
		debug_panel.add_child(debug_label)
		UINode.add_child(debug_panel)
		debug_menu = debug_panel
		

func _process(delta: float) -> void:
	#You must make a var for every value you want to be shown
	fps = Engine.get_frames_per_second()
	
	var stamina = player.stamina_current
	var speed = player.velocity
	var runMultiplier = player.runMulti
	var stat = %StateMachine.state
	var floor = player.is_on_floor()
	#Add the values you want to show to this dict
	var values : Dictionary = {
		"FPS": fps,
		"Stamina": stamina,
		"speed": speed,
		"runMultiplier": runMultiplier,
		"currentState": stat.name,
		"is on floor?": floor,
	}

	if UINode:
		var debuglab = debug_menu.get_node("debug_label")
		var texto = var_to_str(values)
		var final_text = texto.replace("{"," ").replace("}","").replacen('"',"").replacen(',',"")
		debuglab.text = final_text
		

func _input(event: InputEvent) -> void:
	#The debug_key is normally F3 to toggle the debug menu on or off JUST LIKE IN MINECRAFT
	if event.is_action_pressed("debug_key"):
		debug_menu.visible = !debug_menu.visible
