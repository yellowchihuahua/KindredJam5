extends Control

onready var image_swapper = get_node("VBoxContainer/HBoxContainer/LevelImage")

var level_shown = 0

func _ready():
	image_swapper.get_node("CurrentImage").texture = load(Global.get_level_image(0))

func show_level(num):
	print("showing ", num)
	num = num % len(Global.level_paths)
	image_swapper.swap_image(load(Global.get_level_image(num)), 1 if level_shown < num else -1)
	level_shown = num

func _on_RightButton_pressed():
	show_level(level_shown + 1)

func _on_LeftButton_pressed():
	show_level(level_shown - 1)

func _on_PlayLevel_pressed():
	Global.start_level(level_shown)

func _on_MenuButton_pressed():
	Global.load_menu()
