extends Control


func _on_LevelSelect_pressed():
	Global.load_level_select()


func _on_PlayButton_pressed():
	$LevelSelector.play_level()
