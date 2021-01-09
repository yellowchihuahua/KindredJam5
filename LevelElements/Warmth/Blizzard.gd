extends Area2D

signal player_in_blizzard(val)

func _ready():
	connect("player_in_blizzard", Global.get_level_root(), "player_in_blizzard")

func _on_Blizzard_body_entered(body):
	emit_signal("player_in_blizzard", true)

func _on_Blizzard_body_exited(body):
	emit_signal("player_in_blizzard", false)
