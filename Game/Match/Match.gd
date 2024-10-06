class_name Match
extends Node2D


@export var MoveColor:Color
@export var ScoreCounter:Score
@export var TurnCounter:GameCounter
@export var WinColor:Color
@export var LostColor:Color
@export var MainGame:Game
@export var Checker:CheckContainer
var turnFollow:V2FollowCounter
var ScoreFollow:V2FollowCounter

var GameBoard:Board
var Data:MatchData
var EventSystem:MatchEventSystem
var PawnPack:BackPack

var PlayerMovePerTurn:int = 1
var PlayerMoveCount:int

var AllPawnInBoard:Array[Pawn]
var CurrentAddPawn:Array[Pawn]
var HoverPawn:Pawn

var TurnCount:int = 0
var EnemyInBoard:Array[EnemyGroup]

var OnPlayerOperate:bool = false
var CurrentWinPoint:int
var CurrentLostPoint:int
var MatchMoney:int = 0
var MatchScore:int = 0
var KilledPawnDatas:Array[PawnData]




func InitMatch():
	HideWinAndLose()
	KilledPawnDatas = []
	MatchScore = 0
	MatchMoney = 0
	CurrentWinPoint = 0
	CurrentLostPoint = 0
	TurnCount = 0
	EnemyInBoard = []
	GameBoard.Data = BoardManager.GetBoardData(Data.BoardID)
	var t1 = GameBoard.GenBoard()
	AllPawnInBoard.clear()
	HoverPawn = null
	DelayEventManager.Delay(Callable(self,"InitPawn"),t1)
	TurnCounter.OpponentTurn()
	ScoreCounter.GenPoint(Data.LosePoint,Data.WinPoint)
	ShowUI()
	
func InitPawn():
	var res = SummonEvent.new(self)
	for i in 10:
		var tc = PawnPack.PlayerCell(i)
		if tc.P!=null:
			res.AddData(tc.P.Data,GameBoard.PlayerBlockPosition(i))
	for i in Data.NutrialPawn.size():
		res.AddData(Data.NutrialPawn[i],Data.NutrialPawnPosition[i])
	EventSystem.AddEvent(res)
	InitEnemy(0,Callable(self,"PlayerTurnStart"),null)
	EventSystem.Start(Callable(self,"StartInitEnemyDelay"),null)


var EnemyNeedInit:Array[EnemyGroup]
var EnemyInitCallBack:Callable
var EnemyInitCallBackData
func InitEnemy(turn:int,c:Callable,cdata):
	EnemyNeedInit = []
	EnemyInitCallBack = c
	EnemyInitCallBackData = cdata
	for i in Data.Enemys:
		if i.AddTurn == turn:
			EnemyNeedInit.append(i)

func StartInitEnemyDelay(n):
	DelayEventManager.DelayWithData(Callable(self,"StartInitEnemy"),0.11,null)

func StartInitEnemy(n):
	if EnemyNeedInit.size()<=0:
		EnemyInitCallBack.call(EnemyInitCallBackData)
	else:
		var ttt = SummonEvent.new(self)
		EnemyInBoard.append(EnemyNeedInit.pop_back())
		for i in EnemyInBoard[-1].InitPawnList.size():
			if EnemyInBoard[-1].InitPosition.y%2==1 and EnemyInBoard[-1].Offset[i].y%2==1:
				ttt.AddData(EnemyInBoard[-1].InitPawnList[i],EnemyInBoard[-1].InitPosition+EnemyInBoard[-1].Offset[i]+Vector2i(1,0))
			else:
				ttt.AddData(EnemyInBoard[-1].InitPawnList[i],EnemyInBoard[-1].InitPosition+EnemyInBoard[-1].Offset[i])
		EventSystem.AddEvent(ttt)
		DelayEventManager.Delay(Callable(self,"StartSystemForInitEnemy"),0.11)

func StartSystemForInitEnemy():	
	CurrentAddPawn = []
	EventSystem.Start(Callable(self,"JustFinishInitEnemy"),null)
	
	
func JustFinishInitEnemy(n):
	for i in CurrentAddPawn:
		EnemyInBoard[-1].PawnList.append(i)

	var gp = GameBoard.PlayerBlockPosition(4)
	EnemyInBoard[-1].Init(EventSystem,GameBoard,gp,GameBoard.AllPlayerCells)
	CurrentAddPawn = []
	DelayEventManager.DelayWithData(Callable(self,"StartInitEnemy"),0.11,null)



func CleanBoard():
	var tem:Array[Pawn] = []
	for i in AllPawnInBoard.size():
		var ttt = AllPawnInBoard.pop_back()
		if ttt!=null and ttt not in tem:
			tem.append(ttt)
	AllPawnInBoard = tem
	#var tt = 0
	#for i in AllPawnInBoard.size():
	#	if AllPawnInBoard[i-tt] == null:
	#		AllPawnInBoard.remove_at(i-tt)
	#		tt+=1

func ResetAllPawn():
	for i in AllPawnInBoard:
		i.JumpedPawn = []
		i.MovedThisTurn = false

#region Player Turn
func PlayerTurnStart(n):
	TurnCounter.PlayerTurn()
	TurnCount+=1
	CleanBoard()
	ResetAllPawn()
	PlayerMoveCount = PlayerMovePerTurn
	for i in AllPawnInBoard:
		if i!=null and i.Data.AddMoveTimesPawn>0:
			PlayerMoveCount+=i.Data.AddMoveTimesPawn
	OnPlayerOperate = true
	print("playerTrunStart")
	PlayerContinue(null)

var JustJumpdPawn:Pawn
var MultipulJump:bool
func PlayerContinue(n):
	print("continue")
	var t = CheckWin()
	if t!=0:
		OnPlayerOperate = false
		DeSelectAll()
		MatchEnd(t)
	else:
		if JustJumpdPawn!=null:
			var mm:PawnMoveAbility = null
			for i in JustJumpdPawn.MoveAbility:
				if i.Type==PawnMoveAbility.MoveType.Jump:
					mm = i
			if mm!=null:
				if GameBoard.GetCellInJumpRange(JustJumpdPawn,mm.MoveRange).size()>0:
					MultipulJump = true
					SoundManager.PlaySound("Pick")
					SelectedPawn = JustJumpdPawn
					SelectedPosition = UFN.N2GlobalPosition(SelectedPawn)
					_selectBox.position = SelectedPosition
					_selectBox.Rect = SelectedPawn.Data.GetSelfRect()
					_selectBox.Appear(0.6,MoveColor)
					var tem = SelectedPosition-Vector2(0,SelectedPawn.GetHeight()/2)
					_selectLine.SetData(tem,tem)
					_selectLine.Appear()
					SelectPawnPossibleMove(SelectedPawn)
					OnPlayerSelectMove = true
					_curentHoverCell = null
					MouseManager.Mode2(0,Color(1,1,1,1))
			else:
				ResetAllPawn()
		OnPlayerOperate = true


var _selectBox:SelectPawn
var OnPlayerSelectMove:bool = false
var SelectedPosition:Vector2
var SelectedPawn:Pawn
var _selectLine:SelectLine

#region SelectCell
var _canJumpCell:Array[BoardCell] = []
var _canWalkCell:Array[BoardCell] = []
var _canFlyCell:Array[BoardCell] = []
var _canPushCell:Array[BoardCell] = []
var _canOffendCell:Array[BoardCell] = []
func SelectBCell(b:BoardCell,c:Color,l:Array[BoardCell]):
	if b!=null:
		l.append(b)
		b.SelectB(c)
func DeselectBAllCell():
	for i in _canJumpCell:
		i.DeselectB()
	_canJumpCell = []
	for i in _canWalkCell:
		i.DeselectB()
	_canWalkCell = []
	for i in _canFlyCell:
		i.DeselectB()
	_canFlyCell = []
	for i in _canPushCell:
		i.DeselectB()
	_canPushCell = []
	for i in _canOffendCell:
		i.DeselectB()
	_canOffendCell = []
func SelectPawnPossibleMove(p:Pawn):
	var tt = p.MoveAbility.size()
	for i in tt:
		var mb:PawnMoveAbility = p.MoveAbility[tt-1-i]
		match mb.Type:
			PawnMoveAbility.MoveType.Walk:
				if !MultipulJump:
					for cell in GameBoard.GetCellInWalkRange(p._boardCell.BoardPosition,mb.MoveRange):
						if  cell!=null:
							if cell.PawnSlot!=null:
								if p.CanPush:
									SelectBCell(cell,PawnManager.DefaultPushHoverColor,_canPushCell)
								if p.CanOffend and cell.PawnSlot.Flag!=PawnData.PawnFlag.FRIEND:
									SelectBCell(cell,PawnManager.DefaultOffendHoverColor,_canOffendCell)
								if !p.CanPush and (!p.CanOffend or !cell.PawnSlot.Flag!=PawnData.PawnFlag.FRIEND) and cell.CanAddPawn(p):
									SelectBCell(cell,mb.HoverColor,_canWalkCell)
							else:
								SelectBCell(cell,mb.HoverColor,_canWalkCell)
			PawnMoveAbility.MoveType.Fly:
				if !MultipulJump:
					for cell in GameBoard.GetCellInFlyRange(p._boardCell.BoardPosition,mb.MoveRange):
						if  cell!=null and cell.CanAddPawn(p):
							SelectBCell(cell,mb.HoverColor,_canFlyCell)
			PawnMoveAbility.MoveType.Jump:
				for cell in GameBoard.GetCellInJumpRange(p,mb.MoveRange):
					if  cell!=null and cell.CanAddPawn(p):
						SelectBCell(cell,mb.HoverColor,_canJumpCell)
#endregion

var LastMouseDownPosition:Vector2

func PlayerSelectDown():
	LastMouseDownPosition = MouseManager.MousePosition()
	if PlayerMoveCount>0  and HoverPawn!=null and HoverPawn._boardCell!=null and HoverPawn.Flag == PawnData.PawnFlag.FRIEND  and!HoverPawn.isIced and !HoverPawn.MovedThisTurn:
		MultipulJump = false
		SoundManager.PlaySound("Pick")
		SelectedPawn = HoverPawn
		SelectedPosition = UFN.N2GlobalPosition(SelectedPawn)
		_selectBox.position = SelectedPosition
		_selectBox.Rect = SelectedPawn.Data.GetSelfRect()
		_selectBox.Appear(0.6,MoveColor)
		var tem = SelectedPosition-Vector2(0,SelectedPawn.GetHeight()/2)
		_selectLine.SetData(tem,tem)
		_selectLine.Appear()
		SelectPawnPossibleMove(SelectedPawn)
		OnPlayerSelectMove = true
		_curentHoverCell = null
		MouseManager.Mode2(0,Color(1,1,1,1))

var _curentHoverCell:BoardCell
func CheckHoverCell()->BoardCell:
	return GameBoard.GetCell(GameBoard.PositionToBoardPosition(MouseManager.MousePosition()-UFN.N2GlobalPosition(GameBoard)))

var _selectdPawns:Array[Pawn] = []
func _selectPawn(p:Pawn,c:Color):
	if p!=null:
		p.Hover(0,c)
		_selectdPawns.append(p)
func _deselectAllPawns():
	for i in _selectdPawns:
		i.Dehover()
	_selectdPawns = []


func PlayerSelectUpdate():
	_selectLine.SetEnd(MouseManager.MousePosition())
	var tc = CheckHoverCell()
	if tc!=_curentHoverCell:
		_deselectAllPawns()
		if _curentHoverCell!=null:
			_curentHoverCell.DeselectA()
		if tc!=null:
			if tc in _canJumpCell:
				var c = tc.GetSelectBColor()
				tc.SelectA(c)
				MouseManager.Mode2(0,c)
				_selectLine.SetColor(c)
				for i in GameBoard.GetCellBettween(SelectedPawn._boardCell,tc):
					if i!=null and i.GetTop()!=null and i.GetTop().Flag!=PawnData.PawnFlag.FRIEND:
						_selectPawn(i.GetTop(),c)
			elif tc in _canOffendCell:
				var c = tc.GetSelectBColor()
				tc.SelectA(c)
				MouseManager.Mode2(0,c)
				_selectLine.SetColor(c)
				_selectPawn(tc.GetTop(),c)
			elif tc in _canPushCell:
				var c = tc.GetSelectBColor()
				tc.SelectA(c)
				MouseManager.Mode2(0,c)
				_selectLine.SetColor(c)
				_selectPawn(tc.PawnSlot,c)
			elif tc in _canWalkCell:
				var c = tc.GetSelectBColor()
				tc.SelectA(c)
				MouseManager.Mode2(0,c)
				_selectLine.SetColor(c)
			elif  tc in _canFlyCell:
				var c = tc.GetSelectBColor()
				tc.SelectA(c)
				MouseManager.Mode2(0,c)
				_selectLine.SetColor(c)
		
		_curentHoverCell = tc
	

	
func PlayerSelectUp():
	if (MouseManager.MousePosition()-LastMouseDownPosition).length_squared()<25 and HoverPawn!=null:
		Checker.Check(HoverPawn.Data)
	var t = CheckPlayerOperation()
	DeSelectAll()
	if t!=null:
		if !MultipulJump:
			PlayerMoveCount-=1
		EventSystem.AddEvent(t)
		OnPlayerOperate = false
		EventSystem.Start(Callable(self,"PlayerContinue"),null)
	
func CheckPlayerOperation()->MatchEvent:
	JustJumpdPawn = null
	if SelectedPawn!=null:
		if _curentHoverCell in _canJumpCell:
			JustJumpdPawn = SelectedPawn
			SelectedPawn.MovedThisTurn = true
			return MoveEvent.new(PawnMoveAbility.MoveType.Jump,SelectedPawn,GameBoard.GetDri(SelectedPawn._boardCell,_curentHoverCell),
			GameBoard.GetDis(SelectedPawn._boardCell,_curentHoverCell),Vector2i(0,0),null,100)
		if _curentHoverCell in _canOffendCell:
			SelectedPawn.MovedThisTurn = true
			return OffendEvent.new(SelectedPawn,GameBoard.GetDri(SelectedPawn._boardCell,_curentHoverCell))
		if _curentHoverCell in _canPushCell:
			SelectedPawn.MovedThisTurn = true
			return PushEvent.new(SelectedPawn,GameBoard.GetDri(SelectedPawn._boardCell,_curentHoverCell))
		if _curentHoverCell in _canWalkCell:
			SelectedPawn.MovedThisTurn = true
			return MoveEvent.new(PawnMoveAbility.MoveType.Walk,SelectedPawn,GameBoard.GetDri(SelectedPawn._boardCell,_curentHoverCell),
			GameBoard.GetDis(SelectedPawn._boardCell,_curentHoverCell),Vector2i(0,0),null,50)
		if _curentHoverCell in _canFlyCell:
			SelectedPawn.MovedThisTurn = true
			return MoveEvent.new(PawnMoveAbility.MoveType.Fly,SelectedPawn,0,0,
			_curentHoverCell.BoardPosition,null,200)
	return null
	
func PlayerEndTurn():
	DeSelectAll()
	PlayerTurnEnd()
	
func DeSelectAll():
	OnPlayerSelectMove = false
	SelectedPawn = null
	_selectBox.DisAppear()
	DeselectBAllCell()
	_selectLine.Disappear()
	if _curentHoverCell!=null:
		_curentHoverCell.DeselectA()
	_deselectAllPawns()
	MouseManager.Mode1()	
	
	
func UpdatePlayerTurn(dt:float):
	if Input.is_action_just_pressed("MouseL"):
		if (MouseManager.MousePosition()-UFN.N2GlobalPosition(TurnCounter)).length_squared()<10000:
			PlayerEndTurn()
		else:
			PlayerSelectDown()
	if OnPlayerSelectMove:
		PlayerSelectUpdate()
	if Input.is_action_just_released("MouseL"):
		PlayerSelectUp()
	if Input.is_action_just_pressed("Space"):
		PlayerEndTurn()
	
func CheckPlayerTurnEndAbility():
	for i in AllPawnInBoard:
		if i!=null and i.Flag!=PawnData.PawnFlag.ENEMY:
			for a in i.AfterTurn:
				a.Check(i,EventSystem)

func CheckPlayerFire():
	for i in AllPawnInBoard:
		if i!=null and i.Flag!=PawnData.PawnFlag.ENEMY:
			if i.FireTurn>0:
				var ttt = CheckFireEvent.new(i)
				EventSystem.AddEvent(ttt)
	
func CheckPlayerIce():
	for i in AllPawnInBoard:
		if i!=null and i.Flag!=PawnData.PawnFlag.ENEMY:
			if i.IceTurn>0:
				var ttt = CheckIceEvent.new(i)
				EventSystem.AddEvent(ttt)
				
func CheckEnemyTurnEndAbility():
	for i in AllPawnInBoard:
		if i!=null and i.Flag==PawnData.PawnFlag.ENEMY:
			for a in i.AfterTurn:
				a.Check(i,EventSystem)
				
func CheckEnemyFire():
	for i in AllPawnInBoard:
		if i!=null and i.Flag==PawnData.PawnFlag.ENEMY:
			if i.FireTurn>0:
				var ttt = CheckFireEvent.new(i)
				EventSystem.AddEvent(ttt)
	
func CheckEnemyIce():
	for i in AllPawnInBoard:
		if i!=null and i.Flag==PawnData.PawnFlag.ENEMY:
			if i.IceTurn>0:
				var ttt = CheckIceEvent.new(i)
				EventSystem.AddEvent(ttt)

func PlayerTurnEnd():
	TurnCounter.OpponentTurn()
	JustJumpdPawn = null
	print("playerTrunEnd")
	OnPlayerOperate = false
	CheckPlayerTurnEndAbility()
	CheckPlayerFire()
	CheckEnemyIce()
	EventSystem.Start(Callable(self,"EnemyTurnStart"),null)
#endregion


func EnemyTurnStart(n):
	print("EnemyTurnStart")
	
	InitEnemy(TurnCount,Callable(self,"StartEnemyGroups"),null)
	StartInitEnemy(null)
	

func StartEnemyGroups(n):
	if EnemyInBoard.size()>0:
		for i in EnemyInBoard.size()-1:
			EnemyInBoard[i].CallBack = Callable(EnemyInBoard[i+1],"MovePawn")
		EnemyInBoard[-1].CallBack = Callable(self,"EnemyEndTurn")
		DelayEventManager.DelayWithData(Callable(EnemyInBoard[0],"MovePawn"),0,null)
	else:
		DelayEventManager.DelayWithData(Callable(self,"EnemyEndTurn"),0,null)

func EnemyEndTurn(n):	
	print("EnemyTurnEnd")
	CheckEnemyTurnEndAbility()
	CheckEnemyFire()
	CheckPlayerIce()
	EventSystem.Start(Callable(self,"FinalTurnEnd"),null)
	
func FinalTurnEnd(n):
	var t = CheckWin()
	if t!=0:
		MatchEnd(t)
	else:
		DelayEventManager.DelayWithData(Callable(self,"PlayerTurnStart"),0.5,null)
	

func CheckWin()->int:
	CurrentWinPoint = 0
	for i in GameBoard.AllEnemyCells:
		if i!=null and i.PawnSlot!=null and i.PawnSlot.Flag == PawnData.PawnFlag.FRIEND:
			CurrentWinPoint+=i.PawnSlot.GetValue()
	ScoreCounter.SetR(CurrentWinPoint,WinColor)
	if CurrentWinPoint>=Data.WinPoint:
		return 1
	var totalValue = 0
	for i in AllPawnInBoard:
		if i!=null and i.Flag == PawnData.PawnFlag.FRIEND:
			totalValue+=i.GetSelfValue()
	ScoreCounter.SetNum( totalValue)
	if totalValue<Data.WinPoint:
		return -1
	ScoreCounter.SetNum( totalValue)
	CurrentLostPoint = 0
	for i in GameBoard.AllPlayerCells:
		if i!=null and i.PawnSlot!=null and i.PawnSlot.Flag == PawnData.PawnFlag.ENEMY:
			CurrentLostPoint+=i.PawnSlot.GetValue()
	ScoreCounter.SetL(CurrentLostPoint,LostColor)
	if CurrentLostPoint>=Data.LosePoint:
		return -1
	
	print("Win:"+str(CurrentWinPoint)+"  Lost:"+str(CurrentLostPoint)+"   Left:"+str(totalValue)+"   money:"+str(MatchMoney))
	return 0
			


func MatchEnd(w:int):
	if w>=0:
		ShowWin()
	else:
		ShowLose()



func AddPawnFromMoveContainer(m:MoveContainer):
	if m == null:
		return 
	if m.P!=null and m.ToCell!=null :
		_addPawnToBoardCell(m.P,m.ToCell)
		if m.Summon:
			var tem = m.P
			while tem!=null:
				AllPawnInBoard.append(tem)
				CurrentAddPawn.append(tem)
				tem = tem.PawnSlot
	m.P = null
	m.queue_free()
	SoundManager.PlaySound("Move")

func _addPawnToBoardCell(p:Pawn,c:BoardCell):
	c.AddPawn(p)
	c.AddDownSpeed(9)


func EnemyPawnDiedAddMoney(p:Vector2,d:PawnData):
	MatchMoney+=d.MoneyPoint
	MatchScore+=d.MoneyPoint*10
	KilledPawnDatas.append(d)
	
func NutrialPawnDiedAddMoney(p:Vector2,d:PawnData):
	MatchMoney+=d.MoneyPoint
	MatchScore+=d.MoneyPoint
	KilledPawnDatas.append(d)

#region Hover
func CheckHoverPawn()->Pawn:
	for i in GameBoard.CellsNearMouse():
		if i!=null:
			var tem:Pawn = i.PawnSlot
			while tem!=null:
				if UFM.PointInRect(MouseManager.MousePosition()-UFN.N2GlobalPosition(tem),tem.Data.GetSelfRect()):
					return tem
				tem = tem.PawnSlot
	return null

func UpdateHover():
	var p = CheckHoverPawn()
	if p!=HoverPawn:
		if p!=null:
			if OnPlayerOperate and (PlayerMoveCount>0  and p._boardCell!=null and p.Flag == PawnData.PawnFlag.FRIEND  and!p.isIced and !p.MovedThisTurn):
				p.Hover(1,MoveColor)
			else:
				p.Hover()
		if HoverPawn!=null:
			HoverPawn.Dehover()
		HoverPawn = p
#endregion
			
			
func InitData():
	var tem = Board.new()
	GameBoard = tem
	add_child(tem)
	EventSystem = MatchEventSystem.new(self,GameBoard)
	_selectBox = SelectPawn.new()
	_selectBox.Rect = Rect2(-20,-30,40,60)
	add_child(_selectBox)
	_selectLine = SelectLine.new()
	add_child(_selectLine)
	_selectLine.Disappear()
	turnFollow = V2FollowCounter.new()
	turnFollow.Speed = 0.4
	turnFollow.End = Vector2(245,1208)
	turnFollow.Cur = Vector2(245,1208)
	TurnCounter.position = Vector2(245,1208)
	ScoreFollow = V2FollowCounter.new()
	ScoreFollow.Speed = 0.4
	ScoreFollow.End = Vector2(954,-80)
	ScoreFollow.Cur = Vector2(954,-80)
	ScoreCounter.position = Vector2(954,-80)
	InitWinAndLose()

func UpdateUI(dt:float):
	if !turnFollow.Finish:
		turnFollow.Update(dt)
		TurnCounter.position = turnFollow.Data()
	if !ScoreFollow.Finish:
		ScoreFollow.Update(dt)
		ScoreCounter.position = ScoreFollow.Data()

func ShowUI():
	ScoreFollow.End = Vector2(954,80)
	turnFollow.End = Vector2(245,951)
func HideUI():
	ScoreFollow.End = Vector2(954,-80)
	turnFollow.End = Vector2(245,1208)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	InitData()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !OnPlayerSelectMove or MultipulJump:
		UpdateHover()
	if OnPlayerOperate:
		UpdatePlayerTurn(delta)
	UpdateUI(delta)
	updateWinAndLose(delta)

@export var WinSprite:Sprite2D
@export var LoseSprite:Sprite2D
var winSize:FloatBounceCounter
var loseSize:FloatBounceCounter
var winTextBox:QTextBox
var loseTextBox:QTextBox
func InitWinAndLose():
	winSize = FloatBounceCounter.new()
	winSize.End = 0
	winSize.Cur= 0
	loseSize = FloatBounceCounter.new()
	loseSize.End = 0
	loseSize.Cur= 0
func  setWinSize(s:float):
	if s<0:
		s = 0
	WinSprite.scale = Vector2(s,s)
func setLoseSize(s:float):
	if s<0:
		s=0
	LoseSprite.scale = Vector2(s,s)
func updateWinAndLose(dt:float):
	if !winSize.Finish:
		winSize.Update(dt)
		setWinSize(winSize.Data())
	if !loseSize.Finish:
		loseSize.Update(dt)
		setLoseSize(loseSize.Data())
func HideWinAndLose():
	winSize.End = 0
	winSize.Cur = 0
	setWinSize(0)
	loseSize.End = 0
	loseSize.Cur = 0
	setLoseSize(0)
func ShowWin():
	winSize.End = 1
	winTextBox = QTextBox.new("Continue->",Vector2(350,80),Color(1,1,1,1),Color(0,0,0,1),0,true,Callable(self,"MatchWin"),null)
	winTextBox.position = Vector2(825,800)
	winTextBox.z_index = 18
	add_child(winTextBox)
func MatchWin(n):
	if winTextBox!=null:
		winTextBox.Destory()
	MainGame.MatchEnd(self)
func ShowLose():
	loseSize.End = 1
	loseTextBox = QTextBox.new("Restart->",Vector2(350,80),Color(1,1,1,1),Color(0,0,0,1),0,true,Callable(self,"MatchLose"),null)
	loseTextBox.position = Vector2(825,800)
	loseTextBox.z_index = 18
	add_child(loseTextBox)
func MatchLose(n):
	if loseTextBox!=null:
		loseTextBox.Destory()
	MainGame.RestartGame()
