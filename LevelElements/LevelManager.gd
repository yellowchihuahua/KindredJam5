extends Node2D

signal warmth_set(w)
signal out_of_warmth
signal level_finished
signal switch_set(switch_num, enabled)

export var max_warmth = 100
var warmth = max_warmth
var is_warming = false
export var player_move_cost = -10

onready var player = $"PlayingField/Player"

var switches = {}


############# SETUP
func _ready():
	connect_signals()
	
	emit_signal("warmth_set", warmth)

func connect_signals():
	var _out = player.connect("moved", self, "player_moved")
	_out = player.connect("set_warming", self, "set_player_warming")

############## GAME PLAY


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
		
func on_switch_set(switch_num, enabled):
	switches[switch_num] = enabled
	emit_signal("switch_set", switch_num, enabled)
	

################ LEVEL CONTROLS

func _on_Exit_body_entered(_body):
	emit_signal("level_finished")


func _on_NextButton_pressed():
	Global.load_next_level()

