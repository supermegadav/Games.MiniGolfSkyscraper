extends Area2D

func _on_Flag_body_entered(body):
	if body.is_in_group("Ball"):
		if body.collision_with_hole():
			$AnimationPlayer.play("Shake")
			yield(get_tree().create_timer(1.5,false), "timeout")
			$AnimationPlayer.stop()
			$Flagpole.rotation_degrees = 0
			$Flagpole.position.x = 17
	if body.is_in_group("FakeBall"):
		body.enteredFlag()
