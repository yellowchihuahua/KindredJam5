extends Node

# array storing paths to all levels in order of play
# [level_path, level_image]
var level_path_root = "res://Levels/"
var level_image_root = "res://Resources/LevelSelectImages/"
export var level_paths = ["Level_IntroExit",
						"Level_IntroFire",
						"Level_IntroBlocks",
						"Level_IntroBlocksFragile"]

var menu_path = "res://Levels/Menu.tscn"
var current_level = 0

# collision layer bits
var level_bit = 0
var player_bit = 1
var pushable_bit = 2
var warmth_bit = 3
var water_bit = 4
var sunken_bit = 5

func get_level_root():
	return get_tree().root.get_node("LevelRoot")

func restart_level():
	var _out = get_tree().reload_current_scene()
	
func start_level(num):
	current_level = num - 1
	load_next_level()
	
	
func get_level_path(num):
	return level_path_root + level_paths[num] + ".tscn"

func get_level_image(num):
	return level_image_root + level_paths[num] + ".PNG"
	
func load_next_level():
	current_level += 1
	if current_level >= len(level_paths):
		var _out = get_tree().change_scene(menu_path)
	else:
		var _out = get_tree().change_scene(get_level_path(current_level))

func load_level_select():
	var _out = get_tree().change_scene("res://Levels/LevelSelect.tscn")
	
func load_menu():
	var _out = get_tree().change_scene(menu_path)
