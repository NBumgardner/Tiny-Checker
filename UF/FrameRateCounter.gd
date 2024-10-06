class_name FrameRateCounter


var countTime:int = 20
var _count:int = 0
var _totalTime:float = 0


func Update(dt:float):
	_count+=1
	_totalTime+=dt
	
	if _count>=countTime:
		print("FrameRate : "+str(1/_totalTime*countTime))
		_count = 0
		_totalTime = 0
