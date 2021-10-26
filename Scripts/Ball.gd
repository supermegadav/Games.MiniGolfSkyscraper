extends RigidBody2D

signal ball_finished_moving
signal ball_entered_hole
signal ball_freefall_done
signal ball_finished_rewinding

var ballIsMoving = false
var ballIsFreefalling = false
var ballIsInPerspective = 0
var ballIsJumping = false
var ballIsJumpingNeedsReverse = false
var ballIsJumpingNeedsReverseLeft = false
var ballIsJumpingNeedsReverseRight = false
var ballIsJumpingFellOffRamp = false
var ballIsInFreeFallArea = false
var ballIsInWind = false


var ballIsInRewind = false
var ballIsInRewindIndex = 0
var lastShot = []

func _physics_process(delta):
	rotation_degrees = 0
	if ballIsMoving:
		lastShot.append(global_position)
		
	if ballIsInRewind:
		ballIsInRewindIndex -= 2
		if ballIsInRewindIndex >= 0:
			global_transform.origin = lastShot[ballIsInRewindIndex]
		else:
			lastShot = []
			ballIsInRewind = false
			set_collision_mask_bit(0, true)
			emit_signal("ball_finished_rewinding")
	
	if ballIsJumping:
		if !ballIsJumpingNeedsReverse:
			if abs(linear_velocity.x) <= 10:
				if linear_velocity.x > 0:
					ballIsJumpingNeedsReverseLeft = true
				else:
					ballIsJumpingNeedsReverseRight = true
				ballIsJumpingNeedsReverse = true
		else:
			linear_damp = 0.4
			if ballIsJumpingNeedsReverseLeft:
				linear_velocity.x -= 10
			elif ballIsJumpingNeedsReverseRight:
				linear_velocity.x += 10
			linear_velocity.y = 35
	elif ballIsInWind:
		linear_velocity.y = linear_velocity.y + 1.5
	elif ballIsJumpingFellOffRamp:
		linear_velocity.y = linear_velocity.y + 3
	else:
		#slowdown faster
		if abs(linear_velocity.x) <= 50 && abs(linear_velocity.y) < 50:
			if ballIsMoving:
				emit_signal("ball_finished_moving")
				ballIsMoving = false
				linear_velocity = Vector2(0,0)
		else:
			if ballIsFreefalling && linear_velocity.y < 0:
				resetToTopDownMode()
				ballIsFreefalling = false
			elif ballIsFreefalling:
				get_parent().changeCamera(position)
				if ballIsInFreeFallArea:
					linear_velocity.y = 800


func resetToTopDownMode():
	var perspectives = get_tree().get_nodes_in_group("Perspective")
	for perspective in perspectives:
		perspective.get_node("Perspective1").get_node("CollisionShape2D").set_deferred("disabled", false)
		perspective.get_node("Perspective2").get_node("CollisionShape2D").set_deferred("disabled", false)
		perspective.get_node("Perspective3").get_node("CollisionShape2D").set_deferred("disabled", false)
		perspective.get_node("Perspective4").get_node("CollisionShape2D").set_deferred("disabled", false)
		perspective.get_node("Perspective5").get_node("CollisionShape2D").set_deferred("disabled", false)
		perspective.get_node("Perspective6").get_node("CollisionShape2D").set_deferred("disabled", false)
	set_collision_mask_bit(0, true)
	set_collision_mask_bit(9+ballIsInPerspective, false)
	emit_signal("ball_freefall_done")
	

func move(velocity:Vector2):
	lastShot = []
	$SFX/BallHit.play()
	linear_velocity = velocity
	ballIsMoving = true

func rewind():
	if lastShot != null:
		ballIsInRewind = true
		ballIsInRewindIndex = lastShot.size()
		set_collision_mask_bit(0, false)
		
func collision_with_hole():
	#TODO: if velocity too high, not enterd
	if abs(linear_velocity.x) >= 500 or abs(linear_velocity.y) > 500:
		$SFX/Wood/Hit1.play()
		$AnimationPlayer.play("Bounce")
		return true
	else:
		$SFX/BallEnteringHole.play()
		linear_velocity = Vector2(0,0)
		ballIsMoving = false
		emit_signal("ball_entered_hole")
		emit_signal("ball_finished_moving")
		return false
	
func enteredVoid():
	linear_velocity = Vector2(linear_velocity.x,1000)
	set_collision_mask_bit(0, false)
	set_collision_mask_bit(9+ballIsInPerspective, true)
	ballIsFreefalling = true
	
func enteredJump():
	linear_damp = 1.75
	if linear_velocity.x > 0:
		linear_velocity = Vector2(linear_velocity.x - 100, linear_velocity.y - 130)
	else:
		linear_velocity = Vector2(linear_velocity.x + 100, linear_velocity.y - 130)
		
	ballIsJumping = true
	return linear_velocity
	
func exitJump():
	linear_damp = 0.75
	ballIsJumping = false
	ballIsJumpingNeedsReverse = false
	ballIsJumpingNeedsReverseLeft = false
	ballIsJumpingNeedsReverseRight = false
	return linear_velocity
	
func enteredFreeFallArea():
	ballIsInFreeFallArea = true
	
func exitedFreeFallArea():
	ballIsInFreeFallArea = false
	$AnimationPlayer.play("Bounce")
	$SFX/Wood/Hit2.play()

func applyWind(direction:Vector2):
	ballIsInWind = true
	
func noWind():
	ballIsInWind = false

func enteredWater():
	print("entered water")

func fellOffRamp():
	ballIsJumpingFellOffRamp = true
	
func exitedOffRamp():
	ballIsJumpingFellOffRamp = false

func changeScale(perspective):
	if perspective == 1:
		$Sprite.scale = Vector2(1.15, 1.15)
	elif perspective == 2:
		$Sprite.scale = Vector2(1.075, 1.075)
	elif perspective == 3:
		$Sprite.scale = Vector2(1, 1)
	elif perspective == 4:
		$Sprite.scale = Vector2(0.92, 0.92)
	elif perspective == 5:
		$Sprite.scale = Vector2(0.86, 0.86)
	elif perspective == 6:
		$Sprite.scale = Vector2(0.80, 0.80)
	ballIsInPerspective = perspective

func resetPosition(pos:Vector2):
	global_transform.origin = pos


func _on_Ball_body_entered(body):
	if body.is_in_group("SideJump"):
		print("needs to drop down")
