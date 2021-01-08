extends Node2D

signal warmth_set(w)
signal out_of_warmth

var warmth = 100
export var player_move_cost = -10

func _ready():
	connect_signals()
	
	emit_signal("warmth_set", warmth)

func connect_signals():
	$Player.connect("moved", self, "player_moved")

func change_warmth(delta):
	warmth += delta
	emit_signal("warmth_set", warmth)
	
	if warmth <= 0:
		emit_signal("out_of_warmth")

func player_moved():
	change_warmth(player_move_cost)
