extends Area2D

signal set_switch (num, switch_on)

export var switch_num = -1

var body_count = 0

func _ready():
	var _out = connect("set_switch", Global.get_level_root(), "on_switch_set")
	emit_signal("set_switch", switch_num, false)


func _on_Button_body_entered(_body):
	body_count += 1
	if body_count == 1:
		emit_signal("set_switch", switch_num, true)


func _on_Button_body_exited(_body):
	body_count -= 1
	if body_count == 0:
		emit_signal("set_switch", switch_num, false)
