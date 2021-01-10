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

var level_finished = false

var blizzards = 0
var blizzard_chill = -2
var chill_time = 0
var chill_delay = 0.5

############# SETUP
func _ready():
	connect_signals()
	
	emit_signal("warmth_set", warmth)
	

func connect_signals():
	var _out = player.connect("moved", self, "player_moved")
	_out = player.connect("set_warming", self, "set_player_warming")
	_out = player.connect("done_moving", self, "player_done_moving")

############## GAME PLAY

func _process(delta):
	chill_time += delta
	if blizzards > 0 and chill_time > chill_delay and not level_finished and warmth > 0:
		change_warmth(blizzard_chill)
		chill_time = 0
		check_frozen()
		
		

func change_warmth(delta, check_frozen=false):
	warmth += delta
	emit_signal("warmth_set", warmth)
	
	
	
func check_frozen():
	if warmth <= 0 and not level_finished:
		emit_signal("out_of_warmth")
	
func set_warmth(val):
	change_warmth(val - warmth)

func player_moved():
	if not is_warming:
		change_warmth(player_move_cost)
		
func player_done_moving():
	check_frozen()

func set_player_warming(warming):
	self.is_warming = warming
	if warming:
		set_warmth(max_warmth)
		
func on_player_in_water():
	set_warmth(0)
	check_frozen()
		
func on_switch_set(switch_num, enabled):
	switches[switch_num] = enabled
	emit_signal("switch_set", switch_num, enabled)
	
	
func player_in_blizzard(val):
	if val:
		blizzards += 1
	else:
		blizzards -= 1
	
	
	

################ LEVEL CONTROLS

func _on_Exit_body_entered(_body):
	level_finished = true
	emit_signal("level_finished")
	


func _on_NextButton_pressed():
	Global.load_next_level()

