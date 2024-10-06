class_name FloatCycleCounter
extends UpdateCounter


var Intensity:float = 1
var Origin:float
var MaxRange:float
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
		Count -= 2*PI
	
func Data():
	return Origin+(MaxRange-Origin)*sin(Count)*Intensity
