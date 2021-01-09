extends Control


func _on_Button_pressed():
	Global.start_level(0)


func _on_LevelSelect_pressed():
	Global.load_level_select()
