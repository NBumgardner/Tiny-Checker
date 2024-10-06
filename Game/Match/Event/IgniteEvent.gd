class_name IgniteEvent
extends MatchEvent



var MainPawn:Pawn
var IgniteNum:int
var _interTime = 0.05


func _init(p:Pawn,ignite:int) -> void:
	MainPawn = p
	IgniteNum = ignite
	Type = MatchEventType.Ignite


func CheckAble(b:Board)->bool:
	if MainPawn!=null and IgniteNum>0:
		return true
	return false

func PlayAnime(timeRate:float)->float:
	MainPawn.TakeFire(IgniteNum)
	return _interTime*timeRate
	
