extends Area2D

signal player_in_blizzard(val)

func _ready():
	var _out = connect("player_in_blizzard", Global.get_level_root(), "player_in_blizzard")
	var extents = $CollisionShape2D.shape.extents
	$"CollisionShape2D/Particles2D".emission_rect_extents = extents
	extents /= Global.grid_size
	$"CollisionShape2D/Particles2D".amount *= extents.x * extents.y

func _on_Blizzard_body_entered(_body):
	emit_signal("player_in_blizzard", true)

func _on_Blizzard_body_exited(_body):
	emit_signal("player_in_blizzard", false)
