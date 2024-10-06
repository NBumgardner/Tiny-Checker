class_name CheckDeathEvent
extends MatchEvent


var CheckPawn:Pawn
var _interTime:float = 0.1

func _init(p:Pawn) -> void:
	CheckPawn = p
	Type = MatchEventType.CheckDeath


func CheckAble(b:Board)->bool:
	if CheckPawn == null or CheckPawn.HP>0:
		return false
	return true

func PlayAnime(timeRate:float)->float:
	return _interTime*timeRate
