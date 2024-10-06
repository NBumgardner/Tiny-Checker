class_name CheckIceEvent
extends MatchEvent


var CheckPawn:Pawn
var _interTime:float = 0.1

func _init(p:Pawn) -> void:
	CheckPawn = p
	Type = MatchEventType.CheckIce


func CheckAble(b:Board)->bool:
	if CheckPawn == null or CheckPawn.IceTurn<=0:
		return false
	return true

func PlayAnime(timeRate:float)->float:
	return _interTime*timeRate
