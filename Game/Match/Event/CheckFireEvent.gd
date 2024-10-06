class_name CheckFireEvent
extends MatchEvent


var CheckPawn:Pawn
var _interTime:float = 0.1

func _init(p:Pawn) -> void:
	CheckPawn = p
	Type = MatchEventType.CheckFire


func CheckAble(b:Board)->bool:
	if CheckPawn == null or CheckPawn.FireTurn<=0:
		return false
	return true

func PlayAnime(timeRate:float)->float:
	return _interTime*timeRate
