class_name V2BounceCounter
extends UpdateCounter



var End:Vector2:
	set(value):
		Finish = false
		End = value
var Cur:Vector2:
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
		
var StartVocilty :Vector2 = Vector2(0,0)


var _cur:Vector2
var last:Vector2 = Vector2(0,0)
var r2:float = 0
var firstFrame:bool = true
var addv:Vector2 = Vector2(0,0)



func Reset():
	Finish = false
	firstFrame = true
	_cur = Cur
	last = Vector2(0,0)



func Update(dt:float):
	if dt>=0.05:
		dt = 0.05
	if firstFrame:
		UpdateFirstFrame()
		firstFrame = false
	if not Finish:
		var dis = End-_cur
		var a:Vector2= Speed*(Speed*Frequnce*dis*400+Decay*-20*last)
		last = last+a*dt
		var res = last*dt
		_cur+=res
		if BounceRange>0:
			var ll = last.length_squared()
			if ll>r2:
				last = last*r2/ll
		if UFV.V2InRange(End-_cur,0.002) and UFV.V2InRange(last,0.01):
			Finish = true
			_cur = End

func UpdateFirstFrame():
	if End != _cur:
		var dis = End-_cur
		last = dis*20*Speed/(Decay)
		last = last*StartVocilty.x + UFV.V2Rotate90(last)*StartVocilty.y
	last +=addv
	addv = Vector2(0,0)
		
func AddVocility(v:Vector2):
	Finish = false
	if firstFrame:
		addv+=v*20*Speed/(Decay)
	else:
		last+=v*20*Speed/(Decay)
func Data():
	return _cur
