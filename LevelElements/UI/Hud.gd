extends Control

onready var warmth_bar = $"HBoxContainer/WarmthBar"

func _ready():
	Global.get_level_root().connect("out_of_warmth", self, "on_out_of_warmth")
	Global.get_level_root().connect("level_finished", self, "on_level_finished")
	
	$LooseLevel.visible = false
	$LevelFinished.visible = false

func on_out_of_warmth():
	$LooseLevel.visible = true
	
func on_level_finished():
	$LevelFinished.visible = true


func _on_RestartButton_pressed():
	Global.restart_level()


func _on_NextLevelButton_pressed():
	Global.load_next_level()
