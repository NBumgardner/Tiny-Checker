class_name FrozenEvent
extends MatchEvent



var MainPawn:Pawn
var FrozenNum:int
var _interTime = 0.05


func _init(p:Pawn,frozen:int) -> void:
	MainPawn = p
	FrozenNum = frozen
	Type = MatchEventType.Frozen


func CheckAble(b:Board)->bool:
	if MainPawn!=null and FrozenNum>0:
		return true
	return false

func PlayAnime(timeRate:float)->float:
	MainPawn.TakeIce(FrozenNum)
	return _interTime*timeRate
	
