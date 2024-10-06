class_name OffendEvent
extends MatchEvent

var MainPawn:Pawn
var Dri:int

var toPawn:Pawn
# Called when the node enters the scene tree for the first time.
func _init(p:Pawn,dri:int) -> void:
	MainPawn = p
	Dri = dri
	Type = MatchEventType.Offend


func CheckAble(b:Board)->bool:
	if MainPawn==null:
		return false
	var c:BoardCell = b.GetCellInDri(MainPawn._boardCell.BoardPosition,Dri,1)
	if c == null or c.PawnSlot == null or c.GetTop().Flag == MainPawn.Flag:
		return  false
	else:
		toPawn = c.GetTop()
		return true

func PlayAnime(timeRate:float)->float:
	MainPawn.WubbleTimeRate = timeRate
	MainPawn.StartWubble(Dri)
	return MainPawn.WubbleTime*timeRate/2
