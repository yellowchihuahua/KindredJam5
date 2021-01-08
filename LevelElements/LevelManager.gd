extends Node2D

signal warmth_set(w)
signal out_of_warmth
signal level_finished

export var max_warmth = 100
var warmth = max_warmth
var is_warming = false
export var player_move_cost = -10

func _ready():
	connect_signals()
	
	emit_signal("warmth_set", warmth)

func connect_signals():
	var _out = $Player.connect("moved", self, "player_moved")
	_out = $Player.connect("set_warming", self, "set_player_warming")

func change_warmth(delta):
	warmth += delta
	emit_signal("warmth_set", warmth)
	
	if warmth <= 0:
		emit_signal("out_of_warmth")
	
func set_warmth(val):
	change_warmth(val - warmth)

func player_moved():
	if not is_warming:
		change_warmth(player_move_cost)

func set_player_warming(warming):
	self.is_warming = warming
	if warming:
		set_warmth(max_warmth)


func _on_Exit_body_entered(_body):
	emit_signal("level_finished")


func _on_NextButton_pressed():
	Global.load_next_level()
