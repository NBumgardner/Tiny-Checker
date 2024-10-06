class_name V2FollowCounter
extends UpdateCounter


var MinSpeed:float = 0.05
var Speed :float= 1
var End:Vector2:
	set(value):
		Finish = false
		End = value
var Cur:Vector2:
	set(value):
		Cur = value
		Reset()


var _cur


func Reset():
	_cur = Cur
	Finish = false

func Update(dt:float):
	if not Finish:
		var dis = End-_cur
		var tem = UFV.V2Cut(UFV.V2Limit(dis*dt*3*Speed,MinSpeed),dis)
		if tem == dis:
			Finish = true
			_cur = End
		else:
			_cur+=tem
	
func Data():
	return _cur
