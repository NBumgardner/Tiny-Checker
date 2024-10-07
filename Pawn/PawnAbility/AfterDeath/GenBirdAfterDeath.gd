class_name GenBirdAfterDeath
extends PawnAfterDeathAbility


# Called when the node enters the scene tree for the first time.
func Check(event:CheckDeathEvent,system:MatchEventSystem,form:BoardCell):
	var ttt = SummonEvent.new(system.MainMatch)
	var tem = ["Gold Sparrow","Gold Seagull","Gold Raven"]
	ttt.AddData(PawnManager.GetPawn(UFM.GetRandonItem(tem)),form.BoardPosition)
	system.AddEvent(ttt)
