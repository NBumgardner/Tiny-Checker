class_name Deal1DamageToRoundAfterDeath
extends PawnAfterDeathAbility


# Called when the node enters the scene tree for the first time.
func Check(event:CheckDeathEvent,system:MatchEventSystem,form:BoardCell):
	for i in system.MainBoard.GetCellInRange(form.BoardPosition,1):
		if i!=null:
			var t = i.PawnSlot
			while  t!=null:
				var ttt = DealDamageEvent.new(null,t,1)
				system.AddEvent(ttt)
				t = t.PawnSlot
