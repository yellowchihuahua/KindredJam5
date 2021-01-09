extends Control

onready var old = $OldImage
onready var current = $CurrentImage
onready var new = $NewImage

func swap_image(img, direction):
	old.texture = current.texture
	new.texture = img
	
	var anim = "swap_right" if direction == 1 else "swap_left"
	$AnimationPlayer.play(anim)

func settle_image():
	current.texture = new.texture
