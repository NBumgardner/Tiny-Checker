class_name DealDamagearoundAfterTurn
extends PawnAfterTurnAbility


func Check(p:Pawn,system:MatchEventSystem):
	for i in system.MainBoard.GetCellInRange(p._boardCell.BoardPosition,1):
		if i!=null:
			var tem = i.GetTop()
			if tem!=null:
				if tem.Flag != PawnData.PawnFlag.FRIEND:
					var ttt = DealDamageEvent.new(p,tem,1)
					system.AddEvent(ttt)
