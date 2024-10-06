class_name HealEvent
extends MatchEvent



var MainPawn:Pawn
var HealNum:int
var _interTime = 0.05


func _init(p:Pawn,heal:int) -> void:
	MainPawn = p
	HealNum = heal
	Type = MatchEventType.Heal


func CheckAble(b:Board)->bool:
	if MainPawn!=null and HealNum>0:
		return true
	return false

func PlayAnime(timeRate:float)->float:
	MainPawn.Heal(HealNum)
	return _interTime*timeRate
	
