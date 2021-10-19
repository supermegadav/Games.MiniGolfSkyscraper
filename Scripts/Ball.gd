extends RigidBody2D

signal ball_finished_moving
signal ball_entered_hole

var ballIsMoving = false

func _physics_process(delta):
	#slowdown faster
	if abs(linear_velocity.x) <= 50 && abs(linear_velocity.y) < 50:
		if ballIsMoving:
			emit_signal("ball_finished_moving")
			ballIsMoving = false
			linear_velocity = Vector2(0,0)
	

func move(velocity:Vector2):
	linear_velocity = velocity
	ballIsMoving = true
	
	
func collision_with_hole():
	linear_velocity = Vector2(0,0)
	ballIsMoving = false
	emit_signal("ball_entered_hole")
