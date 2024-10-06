class_name Pawn
extends Node2D


@export var Data:PawnData

var PawnSlot:Pawn
var Flag:PawnData.PawnFlag
var CanOffend:bool:
	get:
		if PawnSlot == null:
			return CanOffend
		else:
			return CanOffend or PawnSlot.CanOffend
var CanPush:bool
var MoveAbility:Array[PawnMoveAbility]
var AfterTakeDamage:Array[PawnAfterTakeDamageAbility]
var AfterMove :Array[PawnAfterMoveAbility]
var AfterDeath:Array[PawnAfterDeathAbility]
var AfterTurn:Array[PawnAfterTurnAbility]
var JumpedPawn:Array[Pawn]
var HP:int
var Sheild:int
var AttackNum:int
var FireTurn:int
var IceTurn:int
var ImmuneToFire:bool
var ImmuneToIca:bool
var MovedThisTurn:bool


var DisPlayName:String

var Parts:Array[PawnPart]
var _height
var _pawnPartDistant:float = 7
var _boardCell:BoardCell
var _select:SelectPawn 
var PawnParrent:Pawn

var InMatch:Match


#region PawnAdding
func CanAddGenPawn(d:PawnData)->bool:
	if PawnSlot!=null:
		return PawnSlot.CandAddGenPawn(d)
	else:
		return Data.CanAddData(d)

func CanAddPawn(p:Pawn)->bool:
	if p == self:
		return false
	if PawnSlot!=null:
		if p == PawnSlot:
			return true
		return PawnSlot.CanAddPawn(p)
	else:
		return Data.CanAddData(p.Data)
		
func AddToPosition(p:Pawn)->Vector2:
	if PawnSlot!=null:
		if p == PawnSlot:
			return UFN.N2GlobalPosition(self)-Vector2(0,GetHeight())
		return PawnSlot.AddToPosition(p)
	else:
		return UFN.N2GlobalPosition(self)-Vector2(0,GetHeight())
	
func AddPawn(p:Pawn):
	if p == null:
		return
	if PawnSlot!=null:
		if p == PawnSlot:
			UFN.RemoveParent(p)
			add_child(p)
			p.SetCell(_boardCell)
			p.position = Vector2(0,-GetHeight())
			PawnSlot = p
			p.PawnParrent = self
			return
		PawnSlot.AddPawn(p)
	else:
		UFN.RemoveParent(p)
		add_child(p)
		if p._boardCell!=null:
			p._boardCell.RemovePawn(p)
		p.SetCell(_boardCell)
		p.position = Vector2(0,-GetHeight())
		PawnSlot = p
		p.PawnParrent = self
		
func RemovePawn(p:Pawn):
	if p == self:
		return
	if PawnSlot!=null:
		if PawnSlot == p:
			p.SetCell(null)
			PawnSlot = null
		else :
			PawnSlot.RemovePawn(p)
	
func SetCell(c:BoardCell):
	_boardCell = c
	if PawnSlot!=null:
		PawnSlot.SetCell(c)
		
func SetMatch(m:Match):
	InMatch = m
	if PawnSlot!=null:
		PawnSlot.SetMatch(m)
		
		
		
func GetTop()->Pawn:
	if PawnSlot == null:
		return self
	else:
		return PawnSlot.GetTop()
		
#endregion
		

#region TakeDamage
func TakeDamage(d:int):
	if isIced:
		DeIced()
		return 
	
	SoundManager.PlaySound(Data.HitSound)
	for i in d*3:
		GenPartical()
	if Sheild>=d:
		Sheild-=d
	else:
		d-=Sheild
		Sheild = 0
		HP-=d
	
	UpdateState()
func UpdateState():
	for i in Parts:
		i.Damage((Data.MaxHP-HP)*4/Data.MaxHP)

func GenPartical():
	if _boardCell!=null:
		for i in Parts:
			var tp = UFN.N2GlobalPosition(i)-UFN.N2GlobalPosition(_boardCell)-Vector2(0,i.Data.GetHeight())
			var t = PawnManager.GetDamagePartical(i.Data.LineColor,i.Data.pawnColor,tp)
			_boardCell.add_child(t)
			
func ToDeath():
	SoundManager.PlaySound(Data.DeathSound)
	for i in 10:
		GenPartical()
	var tem = _boardCell
	tem.RemovePawn(self)
	if PawnSlot!=null:
		tem.AddPawn(PawnSlot)
	queue_free()
	
	
func Heal(d:int):
	SoundManager.PlaySound("Heal")
	for i in 5:
		var t = PawnManager.GenHeartPartical(UFN.N2GlobalPosition(self)-UFN.N2GlobalPosition(_boardCell)-Vector2(0,GetHeight()/3))
		_boardCell.add_child(t)
	HP+=d
	if HP>Data.MaxHP:
		HP = Data.MaxHP
	UpdateState()
	
	
	
func TakeFire(turn:int):
	for i in 13:
		var t = PawnManager.GenFirePartical(UFN.N2GlobalPosition(self)-UFN.N2GlobalPosition(_boardCell)-Vector2(0,GetHeight()/3))
		_boardCell.add_child(t)
		SoundManager.PlaySound("Fire")
	FireTurn+=turn

func TakcFireDamage(d:int):
	TakeFire(0)
	TakeDamage(d)


var isIced:bool = false
var IceSprite1:Sprite2D
var IceSprite2:Sprite2D

func TakeIce(turn:int):
	if !isIced and !ImmuneToIca:
		isIced = true
		IceTurn+=turn
		SoundManager.PlaySound("Ice")
		IceSprite1 = Sprite2D.new()
		IceSprite1.texture = TextureManager.GetTexture("IceBack")
		add_child(IceSprite1)
		IceSprite2 = Sprite2D.new()
		IceSprite2.texture = TextureManager.GetTexture("IceLine")
		add_child(IceSprite2)
		
	
func DeIced():
	if isIced:
		SoundManager.PlaySound("IceBreak")
		IceSprite1.queue_free()
		IceSprite1 = null
		IceSprite2. queue_free()
		IceSprite2 = null
		IceTurn = 0
		isIced = false
		for i in 6:
			var t = PawnManager.GetIcePartical(UFN.N2GlobalPosition(self)-UFN.N2GlobalPosition(_boardCell)-Vector2(0,GetHeight()/3))
			_boardCell.add_child(t)



#endregion

func GetHeight():
	if PawnSlot!=null:
		return Data.GetHeight()+PawnSlot.GetHeight()
	return Data.GetHeight()
	
func GetValue()->float:
	if PawnSlot!=null:
		return Data.Value+PawnSlot.GetValue()
	else:
		return Data.Value

func GetSelfValue()->float:
	return Data.Value

func Clean():
	for i in get_children():
		(i as Node).queue_free()
	PawnSlot = null


func GenSprite():
	Clean()
	Parts = []
	var tp:Pawn = null
	if Data.PawnSlot!=null:
		tp = Pawn.new()
		tp.Data = Data.PawnSlot
		Data.PawnSlot = null
		tp.GenSprite()
	
	
	_height = 0
	for i in Data.PartsData:
		var tem = PawnPart.new()
		tem.Data = i
		Parts.append(tem)
		add_child(tem)
		tem.GenSprite()
		tem.position = Vector2(0,-_height)
		_height+=tem.GetHeight()+_pawnPartDistant
	if tp!=null:
		AddPawn(tp)
		
	var t  = SelectPawn.new()
	t.Rect = Data.GetSelfRect()
	_select = t
	add_child(t)
	
	Flag = Data.Flag
	MoveAbility = []
	AfterDeath = []
	AfterMove = []
	AfterTakeDamage = []
	AfterTurn = []
	CanOffend = Data.CanOffend
	CanPush = Data.CanPush
	if Data.CanJump:
		var tem = PawnMoveAbility.new()
		tem.Type = PawnMoveAbility.MoveType.Jump
		tem.MoveRange = 1
		tem.HoverColor = PawnManager.DefaultJumpHoverColor
		MoveAbility.append(tem)
	if Data.CanWalk:
		var tem = PawnMoveAbility.new()
		tem.Type = PawnMoveAbility.MoveType.Walk
		tem.MoveRange = 1
		tem.HoverColor = PawnManager.DefaultMoveHoverColor
		MoveAbility.append(tem)
	for i in Data.MoveAbility:
		MoveAbility.append(i)
	for i in Data.AfterDeath:
		AfterDeath.append(i)
	for i in Data.AfterMove:
		AfterMove.append(i)
	for i in Data.AfterTakeDamage:
		AfterTakeDamage.append(i)
	for i in Data.AfterTurn:
		AfterTurn.append(i)
	JumpedPawn = []
	HP = Data.MaxHP
	Sheild = Data.InitSheild
	AttackNum = Data.AttackNum
	DisPlayName = Data.DisPlayName
	FireTurn = Data.InitFireTurn
	IceTurn = Data.InitIceTurn
	if IceTurn>0:
		TakeIce(0)
	ImmuneToFire = Data.ImmuneToFire
	ImmuneToIca = Data.ImmuneToIce

func Hover(f:float = 1,c:Color = Color(1,1,1,1)):
	_select.Appear(f,c)
	SoundManager.PlaySound("Select")
	
func Dehover():
	_select.DisAppear()			
				

var _savedPosition:Vector2
var onWubble:bool = false
var WubbleTime:float = 0.2
var WubbleTimeRate:float = 1
var WubbleCount:float = 0
var EndPoint:Vector2




func StartWubble(dri:int):
	WubbleCount = 0
	_savedPosition = position
	EndPoint = _savedPosition+PawnManager.DirVector[dri]*0.5
	onWubble = true
	
	
func UpdateWubble(dt:float):
	WubbleCount +=dt
	var t = WubbleTime*WubbleTimeRate
	if WubbleCount>=t:
		WubbleCount = t
		EndWubble()
	position = _savedPosition.lerp(EndPoint,PawnManager.WubbleCurve.sample(WubbleCount/t))
	
	
func EndWubble():
	position = _savedPosition
	onWubble = false
	
var FireInterTime:float = 0.4
var FireCount:float = 0
func UpdateFire(dt:float):
	FireCount+=dt
	if FireCount>FireInterTime:
		FireCount = 0
		if _boardCell!=null:
			var t = PawnManager.GenFirePartical(UFN.N2GlobalPosition(self)-UFN.N2GlobalPosition(_boardCell)-Vector2(0,GetHeight()/3))
			_boardCell.add_child(t)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if onWubble:
		UpdateWubble(delta)
	if FireTurn>0:
		UpdateFire(delta)
