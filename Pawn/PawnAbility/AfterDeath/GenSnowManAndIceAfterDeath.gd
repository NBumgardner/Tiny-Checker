class_name GenSnowManAndIceAfterDeath
extends PawnAfterDeathAbility


# Called when the node enters the scene tree for the first time.
func Check(event:CheckDeathEvent,system:MatchEventSystem,form:BoardCell):
	var ttt = SummonEvent.new(system.MainMatch)
	ttt.AddData(PawnManager.GetPawn("Snow Man"),form.BoardPosition)
	for i in system.MainBoard.GetCellInRange(form.BoardPosition,1):
		if i!=null:
			var tem = i.PawnSlot
			while tem!=null:
				var tttt = FrozenEvent.new(tem,2)
				system.AddEvent(tttt)
				tem =tem.PawnSlot
	system.AddEvent(ttt)
