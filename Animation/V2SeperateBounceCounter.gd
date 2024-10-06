class_name V2SeperateBounceCounter
extends UpdateCounter

var xBounce:FloatBounceCounter = FloatBounceCounter.new()
var yBounce:FloatBounceCounter = FloatBounceCounter.new()
var End:Vector2:
	set(value):
		Finish = false
		End = value
		xBounce.End = value.x
		yBounce.End = value.y
var Cur:Vector2:
	set(value):
		Cur = value
		xBounce.Cur = value.x
		yBounce.Cur = value.y
		Reset()
		

var Frequnce:Vector2 = Vector2(1,1):
	set(value):
		Frequnce = value
		xBounce.Frequnce = value.x
		yBounce.Frequnce = value.y
var Speed:Vector2 = Vector2(1,1):
	set(value):
		Speed = value
		xBounce.Speed = value.x
		yBounce.Speed = value.y
var Decay:Vector2 = Vector2(1,1):
	set(value):
		Decay = value
		xBounce.Decay = value.x
		yBounce.Decay = value.y
var BounceRange:Vector2 = Vector2(-1,-1):
	set(value):
		BounceRange = value
		xBounce.BounceRange = value.x
		yBounce.BounceRange = value.y
		
var StartVocilty :Vector2 = Vector2(0,0):
	set(value):
		StartVocilty = value
		xBounce.StartVocilty = value.x
		yBounce.StartVocilty = value.y
		






func Reset():
	Finish = false
	xBounce.Reset()
	yBounce.Reset()
	
func Update(dt:float):
	var fx = xBounce.Finish
	var fy = yBounce.Finish
	if fx and fy:
		Finish = true
		return
	else:
		if ! fx:
			xBounce.Update(dt)
		if ! fy:
			yBounce.Update(dt)


func AddVocility(v:Vector2):
	Finish = false
	xBounce.AddVocility(v.x)
	yBounce.AddVocility(v.y)

func Data():
	return Vector2(xBounce.Data(),yBounce.Data())
