class_name ShotGunAfterMove
extends PawnAfterMoveAbility



func Check(event:MoveEvent,system:MatchEventSystem,form:BoardCell):
	if event.MoveType!=PawnMoveAbility.MoveType.Fly:
		SoundManager.PlaySound("ShotGun")
		var dd = event.MoveDir+3
		if dd>=6:
			dd-=6
		event.MovePawn.StartWubble(dd)
		for i in 2:
			var tc = system.MainBoard.GetCellInDri(event.MovePawn._boardCell.BoardPosition,event.MoveDir,i+1)
			if tc!=null and tc.GetTop()!=null and tc.GetTop().Flag !=PawnData.PawnFlag.FRIEND:
				var ttt = DealDamageEvent.new(event.MovePawn,tc.GetTop(),2)
				system.AddEvent(ttt)
	
