extends Node2D

export var windUpOriginalPosition = 100
export var windUpRate = 20
export var windUpMax = 1400
export var windUpMin = 100
export var angleRate = 4
export var currentLevel = 1
var windUp = 100
var angleFromUp = 0
var windUpIncrease = true
var hasWindUpInAction = false
var hasShotInAction = false



func _ready():
	$Ball.connect("ball_finished_moving", self, "on_ball_finished_moving")
	$Ball.connect("ball_entered_hole", self, "on_ball_entered_hole")
	$Ball.connect("ball_freefall_done", self, "on_ball_free_fall")
	$Club/WindUpBar.min_value = windUpMin
	$Club/WindUpBar.max_value = windUpMax
	loadNewLevel()

func _physics_process(delta):
	if hasWindUpInAction:
		$Club/WindUpBar.value = windUp
		if windUpIncrease:
			windUp += windUpRate
		else:
			windUp -= windUpRate
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
		$Club.rotation_degrees = angleFromUp

func shoot():
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
	$Club/WindUpBar.value = 100
	print('ball finished moving')
	print('ball position: %s' % $Ball.position)
	resetCamera()
	
func on_ball_free_fall():
	currentLevel -= 1
	print(currentLevel)

func on_ball_entered_hole():
	windUp = windUpOriginalPosition
	angleFromUp = 0
	hasShotInAction = false
	yield(get_tree().create_timer(1, false), "timeout")
	currentLevel += 1
	loadNewLevel()
	
func changeCamera(off:Vector2):
	$Camera2D.offset.y = off.y

func resetCamera():
	$Camera2D.current = true
	if currentLevel == 1:
		$Tween.interpolate_property($Camera2D, "offset", $Camera2D.offset, Vector2(0,4150), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	elif currentLevel == 2:
		$Tween.interpolate_property($Camera2D, "offset", $Camera2D.offset, Vector2(0,3390), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	elif currentLevel == 3:
		$Tween.interpolate_property($Camera2D, "offset", $Camera2D.offset, Vector2(0,2630), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	elif currentLevel == 4:
		$Tween.interpolate_property($Camera2D, "offset", $Camera2D.offset, Vector2(0,1870), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	elif currentLevel == 5:
		$Tween.interpolate_property($Camera2D, "offset", $Camera2D.offset, Vector2(0,1110), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	elif currentLevel == 6:
		$Tween.interpolate_property($Camera2D, "offset", $Camera2D.offset, Vector2(0,350), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	elif currentLevel == 7:
		$Tween.interpolate_property($Camera2D, "offset", $Camera2D.offset, Vector2(0,-410), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	elif currentLevel == 8:
		$Tween.interpolate_property($Camera2D, "offset", $Camera2D.offset, Vector2(0,-1170), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	elif currentLevel == 9:
		$Tween.interpolate_property($Camera2D, "offset", $Camera2D.offset, Vector2(0,-1930), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	else:
		print('you won!')
	$Tween.start()
	
func loadNewLevel():
	resetCamera()
	if currentLevel == 1:
		$Ball.resetPosition(Vector2(-150,4150))
	elif currentLevel == 2:
		$Ball.resetPosition(Vector2(-150,3390))
	elif currentLevel == 3:
		$Ball.resetPosition(Vector2(-150,2630))
	elif currentLevel == 4:
		$Ball.resetPosition(Vector2(-150,1870))
	elif currentLevel == 5:
		$Ball.resetPosition(Vector2(-150,1110))
	elif currentLevel == 6:
		$Ball.resetPosition(Vector2(-150,350))
	elif currentLevel == 7:
		$Ball.resetPosition(Vector2(-150,-410))
	elif currentLevel == 8:
		$Ball.resetPosition(Vector2(-150,-1170))
	elif currentLevel == 9:
		$Ball.resetPosition(Vector2(-150,-1930))
	$Tween.start()
	$Club.position = $Ball.position
	$Club.rotation_degrees = 0
	$Club/WindUpBar.value = 100
		
