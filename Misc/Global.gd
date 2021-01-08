extends Node


func get_level_root():
	return get_tree().root.get_node("LevelRoot")

func restart_level():
	get_tree().reload_current_scene()
