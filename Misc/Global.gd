extends Node

# array storing paths to all levels in order of play
# [level_path, level_image]
var level_path_root = "res://Levels/"
var level_image_root = "res://Resources/LevelSelectImages/"

# [path, # collectables
export var level_paths = [["Level_IntroExit", 0],
						["Level_IntroFire", 0],
						["Level_IntroBlocks", 0],
						["Level_IntroBlocksFragile", 0],
						["Level_IntroInteractable", 0],
						["Level_SlipNSlide", 0],
						["Level_SlidingBoxes", 0]]

var menu_path = "res://Levels/Menu.tscn"
var current_level = 0

# collision layer bits
var level_bit = 0
var player_bit = 1
var pushable_bit = 2
var warmth_bit = 3
var water_bit = 4
var sunken_bit = 5
var interactable_bit = 6
var slick_bit = 7

var grid_size = Vector2(80, 70)

var collected = {}

var interactable_colors = [Color(1,0,0),Color(1,0,1),Color(0,1,1),Color(1,0,0)]

func _ready():
	setup_collected_dict()

func get_level_name():
	return level_paths[current_level][0]
	
func get_collectable_id(num, level_num=current_level):
	return level_paths[level_num][0] + str(num)
	
func get_collected_count(level):
	var count = 0
	for i in collected[level]:
		if collected[level][i]:
			count += 1
	return count
func get_collected_total(level):
	return level_paths[level][1]

func get_level_root():
	return get_tree().root.get_node("LevelRoot")

func restart_level():
	var _out = get_tree().reload_current_scene()
	
func start_level(num):
	current_level = num - 1
	load_next_level()
	
	
func get_level_path(num):
	return level_path_root + level_paths[num][0] + ".tscn"

func get_level_image(num):
	return level_image_root + level_paths[num][0] + ".PNG"
	
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
	
func play_ui_click():
	$UIClick.play()

func setup_collected_dict():
	for i in range(len(level_paths)):
		collected[i] = {}
		for id in range(level_paths[i][1]):
			var name = get_collectable_id(id, i)
			collected[i][name] = false
			

func on_collected_pickup(id):
	if not collected[current_level].has(id):
		printerr("Collected id ", id, " does not exist in Global. Check collected count in level_paths.")
	collected[current_level][id] = true
