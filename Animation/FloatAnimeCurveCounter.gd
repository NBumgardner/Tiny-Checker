class_name FloatAnimeCurveCounter
extends UpdateCounter


var TotalTime:float = 0
var AnimeCurve:Curve
var Start:float = 0
var End:float = 1



var Count = 0


func Reset():
	Count = 0

# Called when the node enters the scene tree for the first time.
func Update(dt:float):
	Count+=dt
	if Count>=TotalTime:
		Count = TotalTime
		Finish = true
		
		
func Data():
	if Finish:
		return End
	return Start+ AnimeCurve.sample(Count/TotalTime)*(End-Start)
