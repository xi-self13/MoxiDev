extends Node

func save():
	var save_dict = {
		"filename" : get_scene_file_path(),
		"parent" : get_parent().get_path(),
		"pos_x" : Player.position.x,
		"pos_y" : Player.position.y,
		"movement_speed" : Player.movement_speed
		"attack" : Player.attack,
		"defense" : Player.defence,
		"current_health" : Player.current_health,
		"max_health" : Player.max_health,
		"damage" : Player.damage,
		"experience" : Player.experience,
		"level" : Player.level
	}
	return save_dict

func save_game():
	var save_file = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for node in save_nodes:
		if node.scene_file_path.is_empty():
			print("persistent node '%s' is not an instanced scene, skipped" % node.name)
			continue
		if !node.has_method("save"):
			print("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue
		var node_data = node.call("save")
		var json_string = JSON.stringify(node_data)
		save_file.store_line(json_string)

func load_data():
	print("LOAD - Implementation Needed")
