class_name HealaroundAfterTurn
extends PawnAfterTurnAbility


func Check(p:Pawn,system:MatchEventSystem):
	for i in system.MainBoard.GetCellInRange(p._boardCell.BoardPosition,1):
		if i!=null:
			var tem = i.PawnSlot
			while tem!=null:
				var ttt = HealEvent.new(tem,1)
				tem = tem.PawnSlot
				system.AddEvent(ttt)
