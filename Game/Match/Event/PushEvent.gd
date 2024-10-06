class_name PushEvent
extends MatchEvent

var MainPawn:Pawn
var Dri


# Called when the node enters the scene tree for the first time.
func _init(p:Pawn,dri:int) -> void:
	Type = MatchEventType.Push
	MainPawn = p
	Dri = dri

func CheckAble(b:Board)->bool:
	if MainPawn == null:
		return false
	var tc:BoardCell = b.GetCellInDri(MainPawn._boardCell.BoardPosition,Dri,1)
	if tc==null or tc.PawnSlot ==null:
		return false
	return true

func PlayAnime(timeRate:float)->float:
	MainPawn.WubbleTimeRate = timeRate
	MainPawn.StartWubble(Dri)
	SoundManager.PlaySound("Push")
	return MainPawn.WubbleTime*timeRate/2
