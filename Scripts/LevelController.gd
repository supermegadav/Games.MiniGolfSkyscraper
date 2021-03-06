extends Node2D

export var levelNumber = 1

func _ready():
	if levelNumber == 3:
		$Obstacles/WheelMovingAnim.play("New Anim")
	if levelNumber == 4:
		$Obstacles/Pusher1/AnimationPlayer.play("PusherUp")
		$Obstacles/Pusher3/AnimationPlayer.play("PusherUp")
		$Obstacles/Pusher5/AnimationPlayer.play("PusherUp")
		yield(get_tree().create_timer(1.5, false), "timeout")
		$Obstacles/Pusher2/AnimationPlayer.play("PusherUp")
		$Obstacles/Pusher4/AnimationPlayer.play("PusherUp")
	if levelNumber == 5:
		$Obstacles/Generator/AnimationPlayer.play("Shake")
		$Obstacles/Wind1/TurbineAnim.play("New Anim")
		$Obstacles/Pistons/AnimationPlayer.play("PistonAnimation")
		yield(get_tree().create_timer(0.1, false), "timeout")
		$Obstacles/Pistons2/AnimationPlayer.play("PistonAnimation")
		yield(get_tree().create_timer(0.1, false), "timeout")
		$Obstacles/Pistons3/AnimationPlayer.play("PistonAnimation")
		yield(get_tree().create_timer(0.1, false), "timeout")
		$Obstacles/Pistons4/AnimationPlayer.play("PistonAnimation")
		yield(get_tree().create_timer(0.1, false), "timeout")
		$Obstacles/Pistons5/AnimationPlayer.play("PistonAnimation")
	if levelNumber == 8:
		$Obstacles/Wind1/TurbineAnim.play("New Anim")
		yield(get_tree().create_timer(0.1, false), "timeout")
		$Obstacles/Wind2/TurbineAnim.play("New Anim")
		yield(get_tree().create_timer(0.1, false), "timeout")
		$Obstacles/Wind3/TurbineAnim.play("New Anim")
		
	

func _on_Void_body_entered(body):
	if body.is_in_group("Ball"):
		var perspective = body.enteredVoid()
		switchToSideScrollerMode()
	if body.is_in_group("FakeBall"):
		body.enteredVoid()

func switchToSideScrollerMode():
	self.get_node("SideScroller").get_node("Plane1").get_node("CollisionShape2D").set_deferred("disabled", true)
	self.get_node("SideScroller").get_node("Plane2").get_node("CollisionShape2D").set_deferred("disabled", true)
	self.get_node("SideScroller").get_node("Plane3").get_node("CollisionShape2D").set_deferred("disabled", true)
	self.get_node("SideScroller").get_node("Plane4").get_node("CollisionShape2D").set_deferred("disabled", true)
	self.get_node("SideScroller").get_node("Plane5").get_node("CollisionShape2D").set_deferred("disabled", true)
	self.get_node("SideScroller").get_node("Plane6").get_node("CollisionShape2D").set_deferred("disabled", true)
	self.z_index = 10
	yield(get_tree().create_timer(1, false), "timeout")
	self.get_node("SideScroller").get_node("Plane1").get_node("CollisionShape2D").set_deferred("disabled", false)
	self.get_node("SideScroller").get_node("Plane2").get_node("CollisionShape2D").set_deferred("disabled", false)
	self.get_node("SideScroller").get_node("Plane3").get_node("CollisionShape2D").set_deferred("disabled", false)
	self.get_node("SideScroller").get_node("Plane4").get_node("CollisionShape2D").set_deferred("disabled", false)
	self.get_node("SideScroller").get_node("Plane5").get_node("CollisionShape2D").set_deferred("disabled", false)
	self.get_node("SideScroller").get_node("Plane6").get_node("CollisionShape2D").set_deferred("disabled", false)
	self.z_index = 0


func _on_Ramp_body_entered(body):
	if body.is_in_group("Ball"):
		var currentVelocity = body.enteredJump()


func _on_Ramp_body_exited(body):
	if body.is_in_group("Ball"):
		var currentVelocity = body.exitJump()


func _on_Wind_body_entered(body):
	if body.is_in_group("Ball"):
		var currentVelocity = body.applyWind(Vector2.DOWN)


func _on_Wind_body_exited(body):
	if body.is_in_group("Ball"):
		var currentVelocity = body.noWind()


func _on_Water_body_entered(body):
	if body.is_in_group("Ball"):
		var currentVelocity = body.enteredWater()


func _on_SideArea_body_entered(body):
	if body.is_in_group("Ball"):
		body.fellOffRamp()


func _on_SideArea_body_exited(body):
	if body.is_in_group("Ball"):
		body.exitedOffRamp()
