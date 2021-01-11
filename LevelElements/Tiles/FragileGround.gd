extends KinematicBody2D

func _on_PlayerDetector_body_exited(_body):
	queue_free()
