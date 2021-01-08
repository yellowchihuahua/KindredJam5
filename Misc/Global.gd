extends Node

# array storing paths to all levels in order of play
export var level_paths = ["res://Levels/Test.tscn"]
var menu_path = "res://Levels/Menu.tscn"
var current_level = 0


func get_level_root():
	return get_tree().root.get_node("LevelRoot")

func restart_level():
	var _out = get_tree().reload_current_scene()
	
func start_level(num):
	current_level = num - 1
	load_next_level()
	
func load_next_level():
	current_level += 1
	if current_level >= len(level_paths):
		get_tree().change_scene(menu_path)
	else:
		get_tree().change_scene(level_paths[current_level])
