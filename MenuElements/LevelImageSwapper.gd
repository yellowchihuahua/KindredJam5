extends Control

onready var old = get_node("LevelImage/OldImage")
onready var new = get_node("LevelImage/NewImage")

var level_shown = 0

func _ready():
	show_level(level_shown)
	

func swap_image(img, direction):
	old.texture = new.texture
	new.texture = img
	
	var anim = "swap_right" if direction == 1 else "swap_left"
	get_node("LevelImage/AnimationPlayer").play(anim)


func play_level():
	Global.play_ui_click()
	Global.start_level(level_shown)

func show_level(num):	
	var new_level = (num+len(Global.level_paths)) % len(Global.level_paths)
	if new_level < 0:
		new_level += len(Global.level_paths)
	
	level_shown = new_level
	
	$CollectedCount.text = "collected " + str(Global.get_collected_count(level_shown)) + "/" + str(Global.get_collected_total(level_shown))
	$LevelNumber.text = "level " + str(level_shown + 1)
	
	var img_path = Global.get_level_image(new_level)
	if ResourceLoader.exists(img_path):
		swap_image(load(Global.get_level_image(new_level)), 1 if level_shown < num else -1)
	

func _on_RightButton_pressed():
	Global.play_ui_click()
	show_level(level_shown + 1)

func _on_LeftButton_pressed():
	Global.play_ui_click()
	show_level(level_shown - 1)
