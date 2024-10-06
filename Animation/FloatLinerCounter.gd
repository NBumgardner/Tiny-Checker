class_name FloatLinerCounter
extends UpdateCounter


var StartDelay:float = 0
var LinerTime:float 
var Start:float
var End:float

var Count = 0


func Reset():
	Count = 0
	
	
func Update(dt:float):
	var t = StartDelay+LinerTime
	Count+=dt
	if Count>t:
		Count = t
	
		
func Data():
	if Finish:
		return End
	var t = Count-StartDelay
	if t<0:
		t = 0
	elif t>LinerTime:
		t = LinerTime
	return Start+(End-Start)*t/LinerTime
		
