class_name MatchEventSystem
extends RefCounted

var MainMatch:Match
var MainBoard:Board
var EventList:Array[MatchEvent]
var CurentEventNum:int
var EventCount:int
var FinishCallBack:Callable
var FinishCallBackData


var _maxEvent:int = 50




func AddEvent(e:MatchEvent):
	if EventCount<=_maxEvent:
		EventList.append(e)
		EventCount+=1
		
func InsertEvent(e:MatchEvent):
	if EventCount<=_maxEvent:
		EventList.insert(CurentEventNum+1,e)
		EventCount+=1

func TimeRate()->float:
	return 1
	
	
	
func Start(callback:Callable,callbackData):
	FinishCallBack = callback
	FinishCallBackData = callbackData
	Continue()
	
	
func StartNextEvent():
	if CurentEventNum>=EventList.size()-1:
		End()
	else:
		if !EventList[CurentEventNum+1].CheckAble(MainBoard):
			CurentEventNum+=1
			EventList[CurentEventNum] = null
			StartNextEvent()
		else:
			CurentEventNum+=1
			DelayEventManager.Delay(Callable(self,"Continue"),EventList[CurentEventNum].PlayAnime(TimeRate()))

	
	
func Continue():
	if CurentEventNum>=EventList.size():
		End()
		return
	if EventList[CurentEventNum] == null:
		StartNextEvent()
		return
	match EventList[CurentEventNum].Type:
		MatchEvent.MatchEventType.none:
			EventList[CurentEventNum] == null
			StartNextEvent()
		MatchEvent.MatchEventType.Summon:
			Summon(EventList[CurentEventNum])
			EventList[CurentEventNum] == null
			StartNextEvent()
		MatchEvent.MatchEventType.Move:
			Move(EventList[CurentEventNum])
			EventList[CurentEventNum] == null
			StartNextEvent()
		MatchEvent.MatchEventType.Offend:
			Offend(EventList[CurentEventNum])
			EventList[CurentEventNum] == null
			StartNextEvent()
		MatchEvent.MatchEventType.DealDamage:
			DealDamage(EventList[CurentEventNum])
			EventList[CurentEventNum] == null
			StartNextEvent()
		MatchEvent.MatchEventType.Push:
			Push(EventList[CurentEventNum])
			EventList[CurentEventNum] == null
			StartNextEvent()
		MatchEvent.MatchEventType.CheckDeath:
			CheckDeath(EventList[CurentEventNum])
			EventList[CurentEventNum] == null
			StartNextEvent()
		MatchEvent.MatchEventType.CheckFire:
			CheckFire(EventList[CurentEventNum])
			EventList[CurentEventNum] == null
			StartNextEvent()
		MatchEvent.MatchEventType.CheckIce:
			CheckIce(EventList[CurentEventNum])
			EventList[CurentEventNum] == null
			StartNextEvent()
		_:
			EventList[CurentEventNum] == null
			StartNextEvent()
		

func Summon(event:SummonEvent):
	for i in event._containers:
		if i!=null:
			MainMatch.AddPawnFromMoveContainer(i)

func Move(event:MoveEvent):
	if event.MoveType == PawnMoveAbility.MoveType.Jump:
		for i in MainBoard.GetCellBettween(event._container.P._boardCell,event._container.ToCell):
			if i!=null:
				var tt = i.GetTop()
				if tt!=null:
					event._container.P.JumpedPawn.append(tt)
				if tt.Flag!=event.MovePawn.Flag:
					var ttt = DealDamageEvent.new(event.MovePawn,tt,event.MovePawn.AttackNum)
					InsertEvent(ttt)
	var form = event.MovePawn._boardCell
	MainMatch.AddPawnFromMoveContainer(event._container)
	if !event.MovePawn.ImmuneToFire:
		event.MovePawn.FireTurn = 0
	for i in event.MovePawn.AfterMove:
		i.Check(event,self,form)

func Offend(event:OffendEvent):
	var ttt = DealDamageEvent.new(event.MainPawn,event.toPawn,event.MainPawn.AttackNum)
	InsertEvent(ttt)

func DealDamage(event:DealDamageEvent):
	event.To.TakeDamage(event.Damage)
	var ttt = CheckDeathEvent.new(event.To)
	AddEvent(ttt)

func Push(event:PushEvent):
	var tc := MainBoard.GetCellInDri(event.MainPawn._boardCell.BoardPosition,event.Dri,1)
	var tcc := MainBoard.GetCellInDri(event.MainPawn._boardCell.BoardPosition,event.Dri,2)
	if tc!=null and tc.PawnSlot!=null and tcc!=null:
		if tcc.CanAddPawn(tc.PawnSlot):
			var ttt = MoveEvent.new(PawnMoveAbility.MoveType.BeMoved,tc.PawnSlot,event.Dri,1,Vector2i(0,0),null,0)
			InsertEvent(ttt)
		
		elif tc.PawnSlot.CanOffend and tcc.PawnSlot!=null and tcc.PawnSlot.Flag != tc.PawnSlot.Flag:
			var ttt = OffendEvent.new(tc.PawnSlot,event.Dri)
			InsertEvent(ttt)
			
		elif  tcc.PawnSlot!=null:
			var ttt = PushEvent.new(tc.PawnSlot,event.Dri)
			InsertEvent(ttt)

func CheckDeath(event:CheckDeathEvent):
	if event.CheckPawn!=null:
		var f = event.CheckPawn._boardCell
		var tem = event.CheckPawn.AfterDeath
		if event.CheckPawn.Flag == PawnData.PawnFlag.ENEMY:
			MainMatch.EnemyPawnDiedAddMoney(UFN.N2GlobalPosition(event.CheckPawn),event.CheckPawn.Data)
		elif event.CheckPawn.Flag == PawnData.PawnFlag.NUTRIAL:
			MainMatch.NutrialPawnDiedAddMoney(UFN.N2GlobalPosition(event.CheckPawn),event.CheckPawn.Data)
		event.CheckPawn.ToDeath()
		for i in tem:
			i.Check(event,self,f)

func CheckFire(event:CheckFireEvent):
	event.CheckPawn.FireTurn-=1
	if !event.CheckPawn.ImmuneToFire:
		event.CheckPawn.TakcFireDamage(1)
		var ttt = CheckDeathEvent.new(event.CheckPawn)
		AddEvent(ttt)
	
func CheckIce(event:CheckIceEvent):
	event.CheckPawn.IceTurn-=1
	if event.CheckPawn.IceTurn<=0:
		event.CheckPawn.DeIced()





func End():
	Reset()
	CallBack()

func _init(m:Match,b:Board):
	MainMatch = m
	MainBoard = b
	Reset()


func CallBack():
	if FinishCallBack.get_object()!=null:
		FinishCallBack.call(FinishCallBackData)
		FinishCallBackData = null
		FinishCallBack = Callable()

func Reset():
	EventList = []
	EventList.append(null)
	CurentEventNum = 0
	EventCount = 0
