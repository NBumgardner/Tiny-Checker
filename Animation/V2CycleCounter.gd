class_name V2CycleCounter
extends UpdateCounter


var Intensity:float = 1:
	set(value):
		if value<=0:
			Finish = true
		else:
			Finish = false
		Intensity = value
var Origin:Vector2
var MaxRange:Vector2
var Phase:float = 0
var CycleTime:float = 3:
	set(value):
		_cycleTime = 2*PI/value
		CycleTime = value
	get:
		return CycleTime
	

var _cycleTime:float


var Count:float = 0

func SetCycleInit(n:float):
	Count+=n*_cycleTime


func Update(dt:float):
	Count+=dt*_cycleTime
	if Count>=2*PI:
		Count  -=2*PI
	
func Data():
	if Finish:
		return Origin
	return Vector2(Origin.x+(MaxRange.x-Origin.x)*sin(Count)*Intensity,Origin.y+(MaxRange.y-Origin.y)*sin(Count+Phase)*Intensity)
