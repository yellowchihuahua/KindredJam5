extends Control

onready var old = get_node("LevelImage/OldImage")
onready var new = get_node("LevelImage/NewImage")

var level_shown = 0


func swap_image(img, direction):
	new.texture = img
	old.texture = new.texture
	
	var anim = "swap_right" if direction == 1 else "swap_left"
	get_node("LevelImage/AnimationPlayer").play(anim)


func play_level():
	Global.start_level(level_shown)

func show_level(num):
	num = (num+len(Global.level_paths)) % len(Global.level_paths)
	swap_image(load(Global.get_level_image(num)), 1 if level_shown < num else -1)
	level_shown = num

func _on_RightButton_pressed():
	show_level(level_shown + 1)

func _on_LeftButton_pressed():
	show_level(level_shown - 1)
