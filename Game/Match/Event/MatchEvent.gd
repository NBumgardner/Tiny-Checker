class_name MatchEvent
extends  RefCounted

enum  MatchEventType{none,Summon,Move,DealDamage,Offend,CheckDeath,Push,Heal,Ignite,Frozen,CheckFire,CheckIce}


var Type:MatchEventType = MatchEventType.none


func CheckAble(b:Board)->bool:
	return false

func PlayAnime(timeRate:float)->float:
	return 0
