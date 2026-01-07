extends Control
@onready var player = preload("res://Entities/Player/player.gd").new()
# TODO! Please make a on player died system. Thanks, and a reminder 
# in case! - XiLy
# Commented temporary... so godot can not throw warnings?
#signal onDied
#signal onNearDeath

# Some is misspelled on purpose. if you dont like this, you can just correct it. - XiLy
@export_category("Death Screen Customization")
@export var messages = {
	"fire" : "You was burnt to a crisp... :()",
	"noO2Water" : "You couldnt hold your breath",
	"suicide_kill" : ["You died? To yourself?! Permenant solution to a temporary problem", "You committed suicide..."],
	"unknown" : ["You died, to... WHAT?", "...", "I have no words.", "!...!", "sorry but not sorry, cant tell you what happened..."],
	"heart_cancer" : ["RIP, my friend... RIP. This was mot your fault."], 
	"unknown_perma" : "You permentaly died... so sad. You cannot revive."
}

func _process(_delta: float) -> void:
	pass
	#print("Death screen time_left : " + str($Timer.time_left))

@export var diedtype : String
@onready var description = $Panel/DiedDescriptor
func add_desc(text : String):
	description.add_text(text)
	description.newline()

func select(delay_sec : float):
	var tf : int = randi_range(0, 4)
	var timer = get_tree().create_timer(delay_sec)
	await timer.timeout
	return tf

func died() -> void:
	if player.current_health == 0:
		if diedtype == "unknown":
			description.text = messages.get("unknown")[0]
		if diedtype == "unknown_perma":
			description.text = messages.get("unknown_perma")[0]

func respawn_timed(sec : float):
	var t = $TimeManager
	t.delay(sec)
	await t.timeout_delay
	
	if player.perma_death == true:
		description.text = "Your time has come, but you couldn't respawn because you is perma dead! But i don't know how to restart a scene yet. Restart your game!"
	else:
		player.current_health = 100.0
		player.movement_speed = 5.0
		player.position = Vector3(0, 5, 0)
		self.visible = false



# ignore this as we is gonna go on a timer base.
func _on_pressedreload() -> void:
	if player.perma_death == true:
		self.visible = false
		#player.position = Vector3(0, 3, 0)
		#player.current_health = 0
		#player.movement_speed = 5.0
		get_tree().reload_current_scene()
	else: 
		player.position = Vector3(0, 3, 0)
		player.current_health = 100
		player.movement_speed = 5.0
		self.visible = false
