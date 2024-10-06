class_name PusharoundAfterTurn
extends PawnAfterTurnAbility


func Check(p:Pawn,system:MatchEventSystem):
	for i in 6:
		var ct = system.MainBoard.GetCellInDri(p._boardCell.BoardPosition,i,1)
		if ct!=null and ct.PawnSlot!=null:
			var ttt = PushEvent.new(p,i)
			system.AddEvent(ttt)
