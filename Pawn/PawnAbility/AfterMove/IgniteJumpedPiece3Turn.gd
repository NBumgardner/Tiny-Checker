class_name IgniteJumpedPiece3Turn
extends PawnAfterMoveAbility



func Check(event:MoveEvent,system:MatchEventSystem,form:BoardCell):
	if event.MoveType == PawnMoveAbility.MoveType.Jump:
		for i in system.MainBoard.GetCellBettween(form,event.MovePawn._boardCell):
			if i!=null and i.PawnSlot!=null:
				var ttt = IgniteEvent.new(i.PawnSlot,3)
				system.AddEvent(ttt)
