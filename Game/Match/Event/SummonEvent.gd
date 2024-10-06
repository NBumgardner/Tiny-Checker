class_name SummonEvent
extends MatchEvent


var SummonPawns:Array[PawnData]
var SummonPositions:Array[Vector2i]

var eventDelay:float = 0
var interTime:float = 0.06
var animeTime:float = 0.2
var distant:float = 30
var ToMatch:Match

var _containers:Array[MoveContainer] = []

func AddData(p:PawnData,v:Vector2i):
	SummonPawns.append(p)
	SummonPositions.append(v)

func _init(toMatch:Match):
	Type = MatchEventType.Summon
	SummonPawns = []
	SummonPositions =[]
	ToMatch = toMatch

func CheckAble(b:Board)->bool:
	for i in SummonPawns.size():
		var c = b.GetCell(SummonPositions[i])
		if c!=null and SummonPawns[i]!=null:
			if c.CanAddGenPawn(SummonPawns[i]):
				var temp:Pawn = Pawn.new()
				temp.Data = SummonPawns[i]
				temp.GenSprite()
				var p = c.AddToPosition(temp)
				var temc = MoveContainer.new(p-Vector2(0,distant),p,temp,animeTime,c,c,0,true,ToMatch)
				temc.Summon = true
				_containers.append(temc)
				
	if _containers.size()>0:
		return true
	else:
		return false
			


func PlayAnime(timeRate:float)->float:
	var tc = 0
	var last = 0
	for i in _containers:
		DelayEventManager.DelayWithData(Callable(i.To,"add_child"),tc,i)
		i.TotalTime*=timeRate
		last = tc+i.TotalTime
		tc+=interTime*timeRate
		
	
	return last+eventDelay
