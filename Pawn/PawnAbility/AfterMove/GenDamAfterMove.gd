class_name GenDamAfterMove
extends PawnAfterMoveAbility



func Check(event:MoveEvent,system:MatchEventSystem,form:BoardCell):
	var ttt = SummonEvent.new(system.MainMatch)
	ttt.AddData(PawnManager.GetPawn("Dam"),form.BoardPosition)
	system.AddEvent(ttt)
