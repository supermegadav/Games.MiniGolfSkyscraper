extends Node2D

export var windUpOriginalPosition = 100
export var windUpRate = 1.03
export var windUpMax = 1500
export var windUpMin = 100
export var angleRate = 2
export var currentLevel = 0
var previousLevel = 0
var windUp = 100
var angleFromUp = 0
var windUpIncrease = true
var hasWindUpInAction = false
var hasShotInAction = false
var hasRewindInAction = false
export var isDebug = true

export var numberOfRewinds = 3
var cameraRewindPos = []
var cameraRewindZoom = []
var cameraRewindIndex = 0

enum GameplayStatus{
  TitleScreen = 1,
  Instructions = 2,
  Gameplay = 3,
  Congratulations = 4
}

export var currentGameplayStatus = GameplayStatus.TitleScreen
var score = [0,0,0,0,0,0,0,0,0]
var timerInFrame = 0

func _ready():
	randomize()
	$Ball.connect("ball_finished_moving", self, "on_ball_finished_moving")
	$Ball.connect("ball_entered_hole", self, "on_ball_entered_hole")
	$Ball.connect("ball_freefall_done", self, "on_ball_free_fall")
	$Ball.connect("ball_finished_rewinding", self, "on_ball_finish_rewinding")
	$HUD/WindUpBar.min_value = windUpMin
	$HUD/WindUpBar.max_value = windUpMax
	$HUD/FindYourBallAnim.play("New Anim")
	loadNewLevel()
	$AudioController.playGameplaySong()

func _physics_process(delta):
	$Skyscraper/ParallaxBackground/CloudQuick2.motion_offset.x += 0.5
	$Skyscraper/ParallaxBackground/CloudQuick.motion_offset.x += 1
	$Club.position = $Ball.position
	if currentGameplayStatus == GameplayStatus.Gameplay:
		timerInFrame += 1
		if hasRewindInAction:
			cameraRewindIndex -= 2
			if cameraRewindIndex >= 0:
				$Camera2D.offset = cameraRewindPos[cameraRewindIndex]
				$Camera2D.zoom = cameraRewindZoom[cameraRewindIndex]
		else:
			if isDebug:
				if not $Ball.ballIsMoving:
					if Input.is_action_just_pressed("debug_increase_level"):
						if currentLevel <= 9: 
							currentLevel += 1
							loadNewLevel()
					if Input.is_action_just_pressed("debug_decrease_level"):
						if currentLevel > 0: 
							currentLevel -= 1
							loadNewLevel()
					if Input.is_action_just_pressed("debug_reset_level"):
							loadNewLevel()
					
			if hasWindUpInAction:
				$HUD/WindUpBar.value = windUp
				if windUpIncrease:
					windUp *= windUpRate
				else:
					windUp /= windUpRate
				if windUp > windUpMax:
					windUpIncrease = false
				elif windUp < windUpMin:
					windUpIncrease = true
			if !hasShotInAction:
				angleFromUp = getAngleToMouse()
				if Input.is_action_pressed("left"):
					angleFromUp += angleRate
				if Input.is_action_pressed("right"):
					angleFromUp -= angleRate
				if Input.is_action_just_pressed("shoot"):
					if !hasWindUpInAction:
						hasWindUpInAction = true
					else:
						hasShotInAction = true
						hasWindUpInAction = false
						shoot()
				if Input.is_action_just_pressed("rewind"):
					if numberOfRewinds > 0 && cameraRewindPos.size() != 0:
						$Ball.rewind()
						$Club.visible = false
						$FixedComponents/Rewind.visible = true
						hasShotInAction = true
						hasRewindInAction = true
						currentLevel = previousLevel
						cameraRewindIndex = cameraRewindPos.size()
						numberOfRewinds -= 1
						if numberOfRewinds == 0:
							$HUD/Rewind1.visible = false
						if numberOfRewinds == 1:
							$HUD/Rewind2.visible = false
						if numberOfRewinds == 2:
							$HUD/Rewind3.visible = false
					
				$Club.rotation_degrees = angleFromUp
				$HUD/Club.rotation_degrees = angleFromUp
			else:
				cameraRewindPos.append($Camera2D.offset)
				cameraRewindZoom.append($Camera2D.zoom)
	elif currentGameplayStatus == GameplayStatus.Congratulations:
		pass


func shoot():
	$Club.visible = false
	previousLevel = currentLevel
	cameraRewindPos = []
	cameraRewindZoom = []
	hasShotInAction = true
	score[currentLevel-1] += 1
	var deg = deg2rad(angleFromUp)
	var directionx = cos(deg) * windUp
	var directiony = sin(deg) * windUp
	$Ball.move(Vector2(directionx, directiony))

func on_ball_finished_moving():
	windUp = windUpOriginalPosition
	angleFromUp = getAngleToFlagRounded()
	hasShotInAction = false
	$Club.position = $Ball.position
	$Club.rotation_degrees = 0
	$HUD/Club.rotation_degrees = 0
	$HUD/WindUpBar.value = windUpOriginalPosition
	resetCamera()
	
func on_ball_free_fall():
	currentLevel -= 1

func on_ball_entered_hole():
	if hasShotInAction:
		$Club.visible = false
		$Ball.visible = false
		windUp = windUpOriginalPosition
		hasShotInAction = false
		yield(get_tree().create_timer(1, false), "timeout")
		currentLevel += 1
		loadNewLevel()

func on_ball_finish_rewinding():
	angleFromUp = getAngleToFlagRounded()
	hasShotInAction = false
	hasRewindInAction = false
	cameraRewindPos = []
	cameraRewindZoom = []
	cameraRewindIndex = 0
	$Club.position = $Ball.position
	$Club.rotation_degrees = angleFromUp
	$HUD/Club.rotation_degrees = angleFromUp
	$HUD/WindUpBar.value = windUpOriginalPosition
	$Club.visible = true
	resetCamera()
	$FixedComponents/Rewind.visible = false
	
		
func changeCamera(off:Vector2):
	$Camera2D.offset.y = off.y
	if currentLevel == 4 or currentLevel == 5 or currentLevel == 6 or currentLevel == 7 or currentLevel == 8 or currentLevel == 9:
		$Camera2D.offset.x = 620
		$Camera2D.zoom = Vector2(1.75,1.75)
	else:
		$Camera2D.offset.x = 0
		$Camera2D.zoom = Vector2(1,1)

func resetCamera():
	$Camera2D.current = true
	$Club.visible = true
	$HUD/Club.visible = false
	$HUD/FindYourBall.visible = false
	var cameraOffset = Vector2()
	var cameraZoom = Vector2()
	var speed = 0.5
	if currentGameplayStatus == GameplayStatus.Instructions:
		speed = 1	
	if currentLevel == 1:
		cameraZoom = Vector2(1,1)
		cameraOffset = Vector2(0,4200)
	elif currentLevel == 2:
		cameraZoom = Vector2(1,1)
		cameraOffset = Vector2(0,3440)
	elif currentLevel == 3:
		cameraZoom = Vector2(1,1)
		cameraOffset = Vector2(0,2680)
	elif currentLevel == 4:
		cameraZoom = Vector2(1.75,1.75)
		cameraOffset = Vector2(620,1920)
	elif currentLevel == 5:
		cameraZoom = Vector2(1.75,1.75)
		cameraOffset = Vector2(620,1160)
	elif currentLevel == 6:
		$Club.visible = false
		$HUD/Club.visible = true
		$HUD/FindYourBall.visible = true
		cameraZoom = Vector2(1.75,1.75)
		cameraOffset = Vector2(620,400)
	elif currentLevel == 7:
		cameraZoom = Vector2(1.75,1.75)
		cameraOffset = Vector2(620,-360)
	elif currentLevel == 8:
		cameraZoom = Vector2(1,1)
		cameraOffset = Vector2(0,-1120)
	elif currentLevel == 9:
		cameraZoom = Vector2(1.25,1.25)
		cameraOffset = Vector2(0,-2050)
	else:
		#TODO where do you won!!
		cameraZoom = Vector2(12,12)
		cameraOffset = Vector2(620,920)
	$Tween.interpolate_property($Camera2D, "zoom", $Camera2D.zoom, cameraZoom, speed, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($Camera2D, "offset", $Camera2D.offset, cameraOffset, speed, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	
	
func loadNewLevel():
	$Ball.visible = true
	resetCamera()
	if currentLevel == 1:
		$Ball.resetPosition(Vector2(-240,4300))
	elif currentLevel == 2:
		$Ball.resetPosition(Vector2(-250,3390))
	elif currentLevel == 3:
		$Ball.resetPosition(Vector2(50,2750))
	elif currentLevel == 4:
		$Ball.resetPosition(Vector2(-300,1920))
	elif currentLevel == 5:
		$Ball.resetPosition(Vector2(1450,1130))
	elif currentLevel == 6:
		$Ball.resetPosition(Vector2(-150,350))
	elif currentLevel == 7:
		$Ball.resetPosition(Vector2(1350,-310))
	elif currentLevel == 8:
		$Ball.resetPosition(Vector2(-300,-1170))
	elif currentLevel == 9:
		$Ball.resetPosition(Vector2(345,-1880))
	elif currentLevel == 10:
		winning()
	angleFromUp = getAngleToFlagRounded()
	$Tween.start()
	$Club.position = $Ball.position
	$Club.rotation_degrees = angleFromUp
	$HUD/Club.rotation_degrees = angleFromUp
	$HUD/WindUpBar.value = windUpOriginalPosition
	
		
func getFlagPosition() -> Vector2:
	if currentLevel == 1:
		return $Skyscraper/Level01/Flag.global_position
	elif currentLevel == 2:
		return $Skyscraper/Level02/Flag.global_position
	elif currentLevel == 3:
		return $Skyscraper/Level03/Flag.global_position
	elif currentLevel == 4:
		return $Skyscraper/Level04/Flag.global_position
	elif currentLevel == 5:
		return $Skyscraper/Level05/Flag.global_position
	elif currentLevel == 6:
		return $Skyscraper/Level06/Flag.global_position
	elif currentLevel == 7:
		return $Skyscraper/Level07/Flag.global_position
	elif currentLevel == 8:
		return $Skyscraper/Level08/Flag.global_position
	elif currentLevel == 9:
		return $Skyscraper/Level09/Flag.global_position
	return Vector2.UP

func getAngleToFlagRounded() -> float:
	var flagPosition = getFlagPosition()
	var ballPosition = $Ball.global_position
	var angle = rad2deg(flagPosition.angle_to_point(ballPosition))
	var randomAngleSum = RNGTools.randi_range(-25.0, 25.0)
	return (angle+randomAngleSum)

func getAngleToMouse() -> float:
	var mousePosition = get_global_mouse_position()
	var ballPosition = $Ball.global_position
	var angle = rad2deg(mousePosition.angle_to_point(ballPosition))
	return angle

func winning():
	currentGameplayStatus = GameplayStatus.Congratulations
	$FixedComponents/Fireworks.visible = true
	$FixedComponents/Fireworks/FireworkTimer1.start()
	$FixedComponents/Fireworks/FireworkTimer2.start()
	$FixedComponents/Fireworks/FireworkTimer3.start()
	$FixedComponents/Fireworks/FireworkTimer4.start()
	yield(get_tree().create_timer(3, false), "timeout")
	$FixedComponents/EndPanel/Scores/Level1.text = str(score[0])
	$FixedComponents/EndPanel/Scores/Level2.text = str(score[1])
	$FixedComponents/EndPanel/Scores/Level3.text = str(score[2])
	$FixedComponents/EndPanel/Scores/Level4.text = str(score[3])
	$FixedComponents/EndPanel/Scores/Level5.text = str(score[4])
	$FixedComponents/EndPanel/Scores/Level6.text = str(score[5])
	$FixedComponents/EndPanel/Scores/Level7.text = str(score[6])
	$FixedComponents/EndPanel/Scores/Level8.text = str(score[7])
	$FixedComponents/EndPanel/Scores/Level9.text = str(score[8])
	$FixedComponents/EndPanel/Scores/TotalScore.text = str(sumScore())
	$FixedComponents/EndPanel/Scores/TotalTime.text = str(getTime())
	$FixedComponents/EndPanel.visible = true
	

func sumScore():
	var sum = 0.0
	for element in score:
		 sum += element
	return sum
	
func getTime():
	var seconds = (timerInFrame / 60) % 60
	var minutes = (timerInFrame / 60 / 60) % 60
	var hours = (timerInFrame / 60 / 60 / 60) % 60
	return "%s:%s:%s" % [str(hours).pad_zeros(2), str(minutes).pad_zeros(2), str(seconds).pad_zeros(2)]
	

func _on_Area_FreeFall_body_entered(body):
	if body.is_in_group("Ball"):
		$Ball.enteredFreeFallArea()


func _on_Area_FreeFall_body_exited(body):
	if body.is_in_group("Ball"):
		$Ball.exitedFreeFallArea()


func _on_TextureButton_pressed():
	currentGameplayStatus = GameplayStatus.Gameplay
	$Tween.interpolate_property($FixedComponents/TitleScreen/Logo, "position", Vector2(140,40), Vector2(140, -500), 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	$FixedComponents/TitleScreen/PlayButton.visible = false
	$FixedComponents/TitleScreen/InstructionsButton.visible = false
	$FixedComponents/TitleScreen/LudwigJamLogo.visible = false
	$FixedComponents/TitleScreen/GodotLogo.visible = false
	yield($Tween, "tween_all_completed")
	currentLevel += 1
	loadNewLevel()
	$Tween.interpolate_property($FixedComponents/TitleScreen/WhiteBackground, "modulate", $FixedComponents/TitleScreen/WhiteBackground.modulate, Color(255,255,255,0), 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	yield($Tween, "tween_all_completed")
	$HUD/PowerMeter.visible = true
	$HUD/WindUpBar.visible = true
	$HUD/Rewind1.visible = true
	$HUD/Rewind2.visible = true
	$HUD/Rewind3.visible = true

func _on_InstructionsButton_pressed():
	currentGameplayStatus = GameplayStatus.Instructions
	$Tween.interpolate_property($FixedComponents/TitleScreen/Logo, "position", Vector2(140,40), Vector2(140, -500), 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	$FixedComponents/TitleScreen/PlayButton.visible = false
	$FixedComponents/TitleScreen/InstructionsButton.visible = false
	$FixedComponents/TitleScreen/LudwigJamLogo.visible = false
	$FixedComponents/TitleScreen/GodotLogo.visible = false
	yield($Tween, "tween_all_completed")
	$Tween.interpolate_property($FixedComponents/TitleScreen/Instructions, "position", Vector2(140,800), Vector2(140,40), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	yield($Tween, "tween_all_completed")
	$FixedComponents/TitleScreen/BackButton.visible = true

func _on_BackButton_pressed():
	currentGameplayStatus = GameplayStatus.TitleScreen
	$FixedComponents/TitleScreen/BackButton.visible = false
	$Tween.interpolate_property($FixedComponents/TitleScreen/Instructions, "position", Vector2(140,40), Vector2(140, 800), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	yield($Tween, "tween_all_completed")
	$Tween.interpolate_property($FixedComponents/TitleScreen/Logo, "position", Vector2(140,-500), Vector2(140, 40), 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	yield($Tween, "tween_all_completed")
	$FixedComponents/TitleScreen/PlayButton.visible = true
	$FixedComponents/TitleScreen/InstructionsButton.visible = true
	$FixedComponents/TitleScreen/LudwigJamLogo.visible = true
	$FixedComponents/TitleScreen/GodotLogo.visible = true
	
func _on_FireworkTimer_timeout():
	var fireworkNode = load("res://Nodes/Fireworks/Explosion.tscn")
	var fireworkInstance = fireworkNode.instance()
	fireworkInstance.position = Vector2(175,200)
	$FixedComponents/Fireworks.add_child(fireworkInstance)
	$FixedComponents/Fireworks/FireworkTimer1.wait_time = RNGTools.randi_range(0.5,2.0)


func _on_FireworkTimer2_timeout():
	var fireworkNode = load("res://Nodes/Fireworks/Explosion.tscn")
	var fireworkInstance = fireworkNode.instance()
	fireworkInstance.position = Vector2(1100,175)
	$FixedComponents/Fireworks.add_child(fireworkInstance)
	$FixedComponents/Fireworks/FireworkTimer2.wait_time = RNGTools.randi_range(0.5,2.0)

func _on_FireworkTimer3_timeout():
	var fireworkNode = load("res://Nodes/Fireworks/Explosion.tscn")
	var fireworkInstance = fireworkNode.instance()
	fireworkInstance.position = Vector2(860,250)
	$FixedComponents/Fireworks.add_child(fireworkInstance)
	$FixedComponents/Fireworks/FireworkTimer3.wait_time = RNGTools.randi_range(0.5,2.0)

func _on_FireworkTimer4_timeout():
	var fireworkNode = load("res://Nodes/Fireworks/Explosion.tscn")
	var fireworkInstance = fireworkNode.instance()
	fireworkInstance.position = Vector2(225,210)
	$FixedComponents/Fireworks.add_child(fireworkInstance)
	$FixedComponents/Fireworks/FireworkTimer4.wait_time = RNGTools.randi_range(0.5,2.0)


func _on_MusicSlider_value_changed(value):
	PlayerVariables.musicVolume = -1 * ((100-value)/100 * 40)

func _on_SFXSlider_value_changed(value):
	PlayerVariables.sfxVolume = -1 * ((100-value)/100 * 25)
	$FixedComponents/TitleScreen/Instructions/BallEnteringHole.volume_db = PlayerVariables.sfxVolume
	$FixedComponents/TitleScreen/Instructions/BallEnteringHole.play()
