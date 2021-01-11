extends KinematicBody2D

func _on_PlayerDetector_body_exited(_body):
	$AnimationPlayer.play("Crack")


func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()
