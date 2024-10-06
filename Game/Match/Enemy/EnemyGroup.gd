class_name EnemyGroup
extends Resource


@export var AddTurn:int
@export var InitPosition:Vector2i
@export var InitPawnList:Array[PawnData]
@export var Offset:Array[Vector2i]
@export var MoveTimes:int = 1
@export var WaitTurn:int = 0

var CallBack:Callable
var CallBackData = null

var System:MatchEventSystem
var MainBoard:Board
var GoalPoint:Vector2i
var PlayerCell:Array[BoardCell]

var PawnList:Array[Pawn]
var MoveTimesLeft:int
var CurrentPawn:int
var waitCount:int = 0


func Init(s:MatchEventSystem,b:Board,gp:Vector2i,pc:Array[BoardCell]):
	System = s
	MainBoard = b
	GoalPoint = gp
	PlayerCell = pc


func MovePawn(n):
	if waitCount<WaitTurn:
		waitCount+=1
		DelayEventManager.Delay(Callable(self,"End"),0)
	else:
		waitCount = 0
		MoveTimesLeft = MoveTimes
		CurrentPawn = -1
		PawnList.shuffle()
		Continue(n)

func Continue(n):
	if MoveTimesLeft>0 and CurrentPawn<PawnList.size()-1:
		CurrentPawn+=1
		DelayEventManager.Delay(Callable(self,"MovePiece"),0)
	else:
		DelayEventManager.Delay(Callable(self,"End"),0)
	
func MovePiece():
	var ttt = TryAttact()
	if ttt!=null:
		System.AddEvent(ttt)
		MoveTimesLeft-=1
		System.Start(Callable(self,"Continue"),null)
	else:
		var tttt = TryMoveToGoal()
		if tttt!=null:
			System.AddEvent(tttt)
			MoveTimesLeft-=1
			System.Start(Callable(self,"Continue"),null)
		else:
			Continue(null)
	
	
func TryAttact()->MatchEvent:
	var cp:Pawn = PawnList[CurrentPawn]
	if cp == null:
		return null
	if cp.AttackNum<=0:
		return null
	if cp.isIced:
		return null
	if cp._boardCel ==null:
		return null
	var JumpDis:int = 0
	for i in cp.MoveAbility:
		if i.Type == PawnMoveAbility.MoveType.Jump:
			JumpDis = i.MoveRange
	if cp.CanOffend:		
		for i in MainBoard.GetCellInWalkRange(cp._boardCell.BoardPosition,1):
			if i!=null and i.GetTop()!=null and i.GetTop().Flag == PawnData.PawnFlag.FRIEND:
				var ttt = OffendEvent.new(cp,MainBoard.GetDri(cp._boardCell,i))
				return ttt
	for i in MainBoard.GetCellInJumpRange(cp,JumpDis):
		for j in MainBoard.GetCellBettween(cp._boardCell,i):
			if j!=null and j.GetTop()!=null and j.GetTop().Flag == PawnData.PawnFlag.FRIEND:
				var ttt = MoveEvent.new(PawnMoveAbility.MoveType.Jump,cp,MainBoard.GetDri(cp._boardCell,i),MainBoard.GetDis(cp._boardCell,i),Vector2i(0,0),null,100)
				return ttt
	
	
	return null

func TryMoveToGoal()->MatchEvent:
	var cp:Pawn = PawnList[CurrentPawn]
	if cp == null:
		return null
	if cp.AttackNum<=0:
		return null
	if cp.isIced:
		return null
	if cp._boardCel ==null:
		return null
	var FlyDis:int = 0
	var WalkDis:int = 0
	var JumpDis:int = 0
	for i in cp.MoveAbility:
		if i.Type == PawnMoveAbility.MoveType.Fly:
			FlyDis = i.MoveRange
		elif i.Type == PawnMoveAbility.MoveType.Walk:
			WalkDis = i.MoveRange
		elif i.Type == PawnMoveAbility.MoveType.Jump:
			JumpDis = i.MoveRange
	var GoalCell:BoardCell = MainBoard.GetCell(GoalPoint)
	var CurDis = MainBoard.GetActuralDis2(cp._boardCell,GoalCell)		
	var FlyRes:BoardCell = null
	var FlyMin = CurDis
	var JumpRes:BoardCell = null
	var JumpMin = CurDis
	var WalkRes:BoardCell = null
	var WalkMin = CurDis
	if FlyDis>0:
		for i in MainBoard.GetCellInFlyRange(cp._boardCell.BoardPosition,FlyDis):
			if i!=null and i.CanAddPawn(cp):
				var tem = MainBoard.GetActuralDis2(i,GoalCell)
				if tem<FlyMin:
					FlyRes = i
					FlyMin = tem
	if WalkDis>0:
		for i in MainBoard.GetCellInWalkRange(cp._boardCell.BoardPosition,WalkDis):
			if i!=null and i.CanAddPawn(cp):
				var tem = MainBoard.GetActuralDis2(i,GoalCell)
				if tem<WalkMin:
					WalkRes = i
					WalkMin = tem
	if JumpDis>0:
		for i in MainBoard.GetCellInJumpRange(cp,JumpDis):
			if i!=null and i.CanAddPawn(cp):
				var tem = MainBoard.GetActuralDis2(i,GoalCell)
				if tem<JumpMin:
					JumpRes = i
					JumpMin = tem
	print("jump:"+str(JumpMin)+" walk:"+str(WalkMin))
	if JumpMin<=WalkMin and JumpMin<=FlyMin and JumpRes!=null:
		return MoveEvent.new(PawnMoveAbility.MoveType.Jump,cp,MainBoard.GetDri(cp._boardCell,JumpRes),MainBoard.GetDis(cp._boardCell,JumpRes),Vector2i(0,0),null,100)
	if WalkMin<=JumpMin and WalkMin<=FlyMin and WalkRes!=null:
		return MoveEvent.new(PawnMoveAbility.MoveType.Walk,cp,MainBoard.GetDri(cp._boardCell,WalkRes),MainBoard.GetDis(cp._boardCell,WalkRes),Vector2i(0,0),null,50)
	if FlyMin<=JumpMin and FlyMin<=WalkMin and FlyRes!=null:
		return MoveEvent.new(PawnMoveAbility.MoveType.Fly,cp,0,0,FlyRes.BoardPosition,null,200)
	
	return null


func End():
	if CallBack.get_object()!=null:
		CallBack.call(CallBackData)
	
	
