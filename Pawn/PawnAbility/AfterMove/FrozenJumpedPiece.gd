class_name FrozenJumpedPiece
extends PawnAfterMoveAbility



func Check(event:MoveEvent,system:MatchEventSystem,form:BoardCell):
	if event.MoveType == PawnMoveAbility.MoveType.Jump:
		for i in system.MainBoard.GetCellBettween(form,event.MovePawn._boardCell):
			if i!=null and i.PawnSlot!=null:
				var ttt = FrozenEvent.new(i.PawnSlot,2)
				system.AddEvent(ttt)
