class_name PawnPartical2
extends PawnPartical


func _process(delta: float) -> void:
	position+=(initSpeed+Vector2(0,-30))*delta
	if firstFrame:
		position = initposition
		firstFrame = false
		scale  = Vector2(0,0)
	initSpeed*=1-(5*delta)

	scale+=Vector2(1,1)*6*delta
	if scale.x>1:
		scale = Vector2(1,1)
	
	duration-=delta
	rotation+=rotateSpeed*delta
	if duration<=0:
		queue_free()
		
