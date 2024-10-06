class_name FloatFollowCounter
extends UpdateCounter


var MinSpeed:float = 0.005
var Speed :float= 1
var End:float:
	set(value):
		Finish = false
		End = value
var Cur:float:
	set(value):
		Cur = value
		Reset()


var _cur = Cur


func Reset():
	_cur = Cur
	Finish = false

func Update(dt:float):
	if not Finish:
		var dis = End-_cur
		var tem = UFM.FloatCut(UFM.FloatLimit(dis*dt*3*Speed,MinSpeed),Vector2(Cur,End))
		if tem == dis:
			Finish = true
			_cur = End
		else:
			_cur+=tem
			
	
func Data():
	return _cur
