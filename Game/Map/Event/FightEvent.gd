class_name FightEvent
extends MapEvent


var Data:MatchData

func EndEvenrCallBack():
	MainMap.MainGame.StartMatch(Data)
