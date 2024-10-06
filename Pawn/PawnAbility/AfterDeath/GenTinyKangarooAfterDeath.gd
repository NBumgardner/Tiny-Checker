class_name GenTinyKangarooAfterDeath
extends PawnAfterDeathAbility


# Called when the node enters the scene tree for the first time.
func Check(event:CheckDeathEvent,system:MatchEventSystem,form:BoardCell):
	var ttt = SummonEvent.new(system.MainMatch)
	ttt.AddData(PawnManager.GetPawn("Tiny Kangaroo"),form.BoardPosition)
	system.AddEvent(ttt)
