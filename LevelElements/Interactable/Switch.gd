extends StaticBody2D

signal set_switch (num, switch_on)

var is_on = false

export var switch_num = -1

func _ready():
	var _out = connect("set_switch", Global.get_level_root(), "on_switch_set")
	emit_signal("set_switch", switch_num, is_on)
	
	if is_on:
		$AnimationPlayer.play("turn")

func interact():
	if is_on:
		$AnimationPlayer.play_backwards("turn")
	else:
		$AnimationPlayer.play("turn")
		
	is_on = not is_on
	
	$AudioStreamPlayer.play()
	
	emit_signal("set_switch", switch_num, is_on)
	
