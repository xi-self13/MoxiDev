extends Node

var player :=  preload("res://Entities/Player/player.tscn")
<<<<<<< HEAD

var platform = OS.get_name()

=======
>>>>>>> 9d1ac263696d885e4b5cb26c245d09811db1843f
func save():
	if !player:
		return {"filename" : get_scene_file_path(), "parent" : get_parent().get_path()}
	var save_dict = {
		"filename" : get_scene_file_path(),
		"parent" : get_parent().get_path(),
		"pos_x" : player.position.x,
		"pos_y" : player.position.y,
		"movement_speed" : player.movement_speed,
		"attack" : player.attack,
		"defense" : player.defence,
		"current_health" : player.current_health,
		"max_health" : player.max_health,
		"damage" : player.damage,
		"experience" : player.experience,
		"level" : player.level,
		"uname" : player.username,
		"dname" : player.displayname,
		}
	return save_dict

func save_game():
	var save_file = FileAccess.open("user://WorldData/game_data.save", FileAccess.WRITE)
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
