extends Control

onready var warmth_bar = $"HBoxContainer/WarmthBar"

func _ready():
	Global.get_level_root().connect("warmth_set", self, "set_warmth")
	Global.get_level_root().connect("out_of_warmth", self, "out_of_warmth")
	
	$LooseLevel.visible = false


func set_warmth(warmth):
	warmth_bar.value = warmth

func out_of_warmth():
	$LooseLevel.visible = true


func _on_RestartButton_pressed():
	Global.restart_level()
