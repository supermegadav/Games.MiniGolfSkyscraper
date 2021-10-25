extends Node2D

var hit = 0

func playGameplaySong():
	$Song1.play()

func playHitSolidObjects():
	if hit == 0:
		$SFX/Wood/Hit1.play()
	elif hit == 1:
		$SFX/Wood/Hit2.play()
	elif hit == 2:
		$SFX/Wood/Hit3.play()
	hit += 1
	if hit == 3: hit == 0
	
func playBallHit():
	$SFX/BallHit.play()
	
func playBallEnteringHole():
	$SFX/BallEnteringHole.play()
