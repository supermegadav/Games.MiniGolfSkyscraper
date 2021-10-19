extends Node2D

func changeLevel(level):
	hideAllLevel()
	var flagPosition = Vector2(0,0)
	var startPosition = Vector2(0,0)
	
	if level == 1:
		flagPosition = Vector2(625,100)
		startPosition = Vector2(625,600)
		$Level1.visible = true

	if level == 2:
		flagPosition = Vector2(275,70)
		startPosition = Vector2(625,100)
		$Level2.visible = true
		$Level2/RigidBody2D/Bumper1.disabled = false
		$Level2/RigidBody2D/Bumper2.disabled = false
		$Level2/RigidBody2D/Bumper3.disabled = false
		
	if level == 3:
		flagPosition = Vector2(1040,385)
		startPosition = Vector2(275,70)
		$Level3.visible = true
		
	if level == 4:
		flagPosition = Vector2(220,635)
		startPosition = Vector2(1040,385)
		$Level4.visible = true
	

	$Flag.global_position = flagPosition
	$StartPosition.global_position = startPosition
	return startPosition
	
	
func hideAllLevel():
	$Level1.visible = false
	$Level2.visible = false
	$Level3.visible = false
	$Level4.visible = false
	
