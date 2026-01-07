extends Node
class_name Effects

@onready var plr = preload("res://Entities/Player/player.gd").new()
@export_category("Effects Stuff")
@export var particles : CPUParticles3D

# Sanity
func grow_insane(by_how : float):
	plr.sanity_current -= by_how
func free_insane(by_how : float):
	plr.sanity_current += by_how
func check_sanity():
	if plr.sanity_current < 20.0:
		return "insane"
	elif plr.sanity_current < 40.0:
		return "okay"
	else: 
		return "normal"

# Hunger
func eat(by_how : float, saturation : float):
	if plr.hunger_current != plr.hunger_max:
		plr.hunger_current += by_how * saturation
	elif plr.hunger_current == plr.hunger_max:
		print("Player: Im too full silly. :p")
func check_hunger():
	if plr.current_health < 10:
		return "hungry"
	elif plr.current_health < 5:
		return "starving"
	else: 
		return "peckish"