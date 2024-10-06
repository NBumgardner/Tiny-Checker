class_name DealDamageToSelfAfterTurn
extends PawnAfterTurnAbility


func Check(p:Pawn,system:MatchEventSystem):
	var ttt = DealDamageEvent.new(p,p,1)
	system.AddEvent(ttt)
