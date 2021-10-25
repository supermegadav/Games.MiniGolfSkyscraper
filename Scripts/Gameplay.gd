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

func _ready():
	$Ball.connect("ball_finished_moving", self, "on_ball_finished_moving")
	$Ball.connect("ball_entered_hole", self, "on_ball_entered_hole")
	$Ball.connect("ball_freefall_done", self, "on_ball_free_fall")
	$Ball.connect("ball_finished_rewinding", self, "on_ball_finish_rewinding")
	$HUD/WindUpBar.min_value = windUpMin
	$HUD/WindUpBar.max_value = windUpMax
	loadNewLevel()
	$AudioController.playGameplaySong()

func _physics_process(delta):
	if currentGameplayStatus == GameplayStatus.TitleScreen:
		if Input.is_action_just_pressed("shoot"):
			currentGameplayStatus = GameplayStatus.Instructions
			$Tween.interpolate_property($FixedComponents/TitleScreen, "position", Vector2(140,40), Vector2(140, -500), 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			$Tween.start()
			yield($Tween, "tween_all_completed")
			currentLevel += 1
			loadNewLevel()
			yield($Tween, "tween_all_completed")
			$Tween.interpolate_property($FixedComponents/Instructions, "position", Vector2(140,800), Vector2(140,40), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			$Tween.start()
		
	elif currentGameplayStatus == GameplayStatus.Instructions:
		if Input.is_action_just_pressed("shoot"):
			currentGameplayStatus = GameplayStatus.Gameplay
			$Tween.interpolate_property($FixedComponents/Instructions, "position",  Vector2(140,40), Vector2(140, 800), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			$Tween.interpolate_property($FixedComponents/ColorRect, "modulate", $FixedComponents/ColorRect.modulate, Color(255,255,255,0), 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			$Tween.start()
			yield($Tween, "tween_all_completed")
		
	elif currentGameplayStatus == GameplayStatus.Gameplay:
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
					if numberOfRewinds > 0:
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
	previousLevel = currentLevel
	cameraRewindPos = []
	cameraRewindZoom = []
	hasShotInAction = true
	var deg = deg2rad(angleFromUp)
	var directionx = cos(deg) * windUp
	var directiony = sin(deg) * windUp
	$Ball.move(Vector2(directionx, directiony))

func on_ball_finished_moving():
	windUp = windUpOriginalPosition
	angleFromUp = 0
	hasShotInAction = false
	$Club.position = $Ball.position
	$Club.rotation_degrees = 0
	$HUD/Club.rotation_degrees = 0
	$HUD/WindUpBar.value = windUpOriginalPosition
	print('ball finished moving')
	print('ball position: %s' % $Ball.position)
	resetCamera()
	
func on_ball_free_fall():
	currentLevel -= 1

func on_ball_entered_hole():
	windUp = windUpOriginalPosition
	angleFromUp = 0
	hasShotInAction = false
	yield(get_tree().create_timer(1, false), "timeout")
	currentLevel += 1
	loadNewLevel()
	
func on_ball_finish_rewinding():
	angleFromUp = 0
	hasShotInAction = false
	hasRewindInAction = false
	cameraRewindPos = []
	cameraRewindZoom = []
	cameraRewindIndex = 0
	$Club.position = $Ball.position
	$Club.rotation_degrees = 0
	$HUD/Club.rotation_degrees = 0
	$HUD/WindUpBar.value = windUpOriginalPosition
	$Club.visible = true
	resetCamera()
	$FixedComponents/Rewind.visible = false
	
		
func changeCamera(off:Vector2):
	$Camera2D.offset.y = off.y

func resetCamera():
	$Camera2D.current = true
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
		cameraZoom = Vector2(1.75,1.75)
		cameraOffset = Vector2(620,400)
	elif currentLevel == 7:
		cameraZoom = Vector2(1.75,1.75)
		cameraOffset = Vector2(620,-360)
	elif currentLevel == 8:
		cameraZoom = Vector2(1,1)
		cameraOffset = Vector2(0,-1120)
	elif currentLevel == 9:
		cameraZoom = Vector2(2,2)
		cameraOffset = Vector2(0,-2280)
	else:
		#TODO where do you won!!
		cameraZoom = Vector2(12,12)
		cameraOffset = Vector2(620,920)
		print('you won!')
		
	$Tween.interpolate_property($Camera2D, "zoom", $Camera2D.zoom, cameraZoom, speed, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($Camera2D, "offset", $Camera2D.offset, cameraOffset, speed, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	
func loadNewLevel():
	print(currentLevel)
	resetCamera()
	$Club.visible = true
	$HUD/Club.visible = false
	if currentLevel == 1:
		$Ball.resetPosition(Vector2(-250,4300))
	elif currentLevel == 2:
		$Ball.resetPosition(Vector2(-250,3390))
	elif currentLevel == 3:
		$Ball.resetPosition(Vector2(50,2750))
	elif currentLevel == 4:
		$Ball.resetPosition(Vector2(-300,1920))
	elif currentLevel == 5:
		$Ball.resetPosition(Vector2(1350,1210))
	elif currentLevel == 6:
		$Club.visible = false
		$HUD/Club.visible = true
		$Ball.resetPosition(Vector2(-150,350))
	elif currentLevel == 7:
		$Ball.resetPosition(Vector2(1350,-310))
	elif currentLevel == 8:
		$Ball.resetPosition(Vector2(-300,-1170))
	elif currentLevel == 9:
		$Ball.resetPosition(Vector2(-150,-1930))
	$Tween.start()
	$Club.position = $Ball.position
	$Club.rotation_degrees = 0
	$HUD/Club.rotation_degrees = 0
	$HUD/WindUpBar.value = windUpOriginalPosition
		


func _on_Area_FreeFall_body_entered(body):
	if body.is_in_group("Ball"):
		$Ball.enteredFreeFallArea()


func _on_Area_FreeFall_body_exited(body):
	if body.is_in_group("Ball"):
		$Ball.exitedFreeFallArea()

