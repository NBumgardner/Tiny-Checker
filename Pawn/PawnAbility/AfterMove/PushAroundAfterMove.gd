class_name PushAroundAfterMove
extends PawnAfterMoveAbility



func Check(event:MoveEvent,system:MatchEventSystem,form:BoardCell):
	for i in 6:
		var ct = system.MainBoard.GetCellInDri(event.MovePawn._boardCell.BoardPosition,i,1)
		if ct!=null and ct.PawnSlot!=null:
			var ttt = PushEvent.new(event.MovePawn,i)
			system.AddEvent(ttt)
