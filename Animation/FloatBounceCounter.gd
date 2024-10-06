class_name FloatBounceCounter
extends UpdateCounter



var End:float:
	set(value):
		Finish = false
		End = value
var Cur:float:
	set(value):
		Cur = value
		Reset()
var Frequnce:float = 1
var Speed:float = 1
var Decay:float = 1
var BounceRange:float = -1:
	set(value):
		r2 = value*value
		BounceRange = value
		
var StartVocilty :float = 0


var _cur:float
var last:float = 0
var r2:float = 0
var firstFrame:bool = true
var addv:float = 0


func Reset():
	Finish = false
	firstFrame = true
	_cur = Cur
	last = 0


func Update(dt:float):
	if dt>=0.1:
		dt = 0.1
	if firstFrame:
		UpdateFirstFrame()
		firstFrame = false
	if not Finish:
		var dis = End-_cur
		var a:float= Speed*(Speed*Frequnce*dis*400+Decay*-20*last)
		last = last+a*dt
		var res = last*dt
		_cur+=res
		if BounceRange>0:
			var ll = last*last
			if ll>r2:
				last = last*r2/ll
		if UFM.AbsInRange(End-_cur,0.002) and UFM.AbsInRange(last,0.1):
			Finish = true
			_cur = End

func UpdateFirstFrame():
	if End != _cur:
		var dis = End-_cur
		last = dis*20*Speed*Decay*StartVocilty
	last +=addv
	addv = 0
		
func AddVocility(v:float):
	Finish = false
	if firstFrame:
		addv+=v*20*Speed*Decay
	else:
		last+=v*20*Speed*Decay
func Data():
	return _cur
