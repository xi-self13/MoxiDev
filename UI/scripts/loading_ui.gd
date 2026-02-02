extends Control
class_name LoadingHandler
# Testing loading and stuff
@onready var tree = get_tree()
func _ready() -> void:
	pass

func load_scene(path : String):
	var nodecount = tree.get_node_count()
	# TODO? Make a new loading screen?
