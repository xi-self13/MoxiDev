extends Control
@onready var player = $"../"
# TODO! Please make a on player died system. Thanks, and a reminder 
# in case! - XiLy
# Commented temporary... so godot can not throw warnings?
#signal onDied
#signal onNearDeath

# Some is misspelled on purpose. if you dont like this, you can just correct it. - XiLy
@export_category("Death Screen Customization")
@export var messages = {
	"fire" : ["You was burnt to a crisp... :(", "You was incinerated...", "Oh. Whewwww... blows the crisp away"],
	"noO2Water" : ["You couldnt hold your breath...", "Gagglles and chookes", "*Your O2 ran out..."],
	"suicide_kill" : ["You died? To yourself?! Permenant solution to a temporary problem", "You committed suicide..."],
	"unknown" : ["You died, to... WHAT?", "...", "I have no words.", "!...!", "sorry but not sorry, cant tell you what happened..."],
	"heart_cancer" : ["RIP, my friend... RIP. This was mot your fault."]
}
@export var diedtype : String
@onready var description = $Panel/DiedDescriptor
func died() -> void:
	if player.current_health == 0:
		if diedtype == "unknown":
			description.text = messages.get("unknown")[4]






func _on_pressedreload() -> void:
	self.visible = false
	player.position = Vector3(0, 3, 0)
	player.current_health = 100
	player.movement_speed = 5.0
