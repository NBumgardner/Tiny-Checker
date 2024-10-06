class_name GenDirtAfterMove
extends PawnAfterMoveAbility



func Check(event:MoveEvent,system:MatchEventSystem,form:BoardCell):
	if event.MoveType!=PawnMoveAbility.MoveType.Fly:
		var ttt = SummonEvent.new(system.MainMatch)
		for i in 3:
			var tc = system.MainBoard.GetCellInDri(event.MovePawn._boardCell.BoardPosition,event.MoveDir,i+1)
			if tc!=null:
				ttt.AddData(PawnManager.GetPawn("Dirt"),tc.BoardPosition)
		system.AddEvent(ttt)
