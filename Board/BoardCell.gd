class_name BoardCell
extends Node2D




var PawnSlot:Pawn
var Bounce:V2BounceCounter
var BlockData:BoardBlockData = BoardBlockData.new()
var AphaTrans:FloatLinerCounter = FloatLinerCounter.new()


var curPosition:Vector2
var BoardPosition:Vector2i

var blockOffset:Vector2 = Vector2(0,-7)
var blockYPress:float = 0.7
var blockLength:float = 60



var _block:BoardBlock


#region PawnAddind
func CanAddGenPawn(d:PawnData)->bool:
	if PawnSlot!=null:
		return PawnSlot.CanAddGenPawn(d)
	else:
		return true

func CanAddPawn(p:Pawn)->bool:
	if PawnSlot!=null:
		if p == PawnSlot:
			return true
		return PawnSlot.CanAddPawn(p)
	else:
		return true
		
func AddToPosition(p:Pawn)->Vector2:
	if PawnSlot!=null:
		if p == PawnSlot:
			return UFN.N2GlobalPosition(self)
		return PawnSlot.AddToPosition(p)
	else:
		return UFN.N2GlobalPosition(self)
	
func AddPawn(p:Pawn):
	if p == null:
		return
	if PawnSlot!=null:
		if p == PawnSlot:
			UFN.RemoveParent(p)
			add_child(p)
			PawnSlot = p
			p.position = curPosition
			p.SetCell(self)
			return 
		PawnSlot.AddPawn(p)
	else:
		UFN.RemoveParent(p)
		add_child(p)
		PawnSlot = p
		p.position = curPosition
		if p._boardCell!=null:
			p._boardCell.RemovePawn(p)
		p.SetCell(self)
	
	
func RemovePawn(p:Pawn):
	if PawnSlot!=null:
		if PawnSlot == p:
			p.SetCell(null)
			PawnSlot = null
		else:
			PawnSlot.RemovePawn(p)
			
func GetTop()->Pawn:
	if PawnSlot == null:
		return null
	else:
		return PawnSlot.GetTop()


#endregion

func Clean():
	for i in get_children():
		(i as Node).queue_free()
	PawnSlot = null

#region Block
func CleanBlock():
	if _block!=null:
		_block.queue_free()
		_block = null

func GenBoardBlock():
	CleanBlock()
	var tem = BoardBlock.new()
	tem.Data = BlockData
	add_child(tem)
	tem.position = curPosition+blockOffset
	tem.yPress = blockYPress
	tem.egdeLength = blockLength
	tem.GenSprite()
	modulate = Color(1,1,1,0)
	_block = tem
#endregion

func SelectA(c:Color = Color(1,1,1,1),s:float = 1):
	if _block!=null:
		_block.SelectA(c,s)

func DeselectA():
	if _block!=null:
		_block.DeselectA()

func GetSelectBColor()->Color:
	if _block!=null:
		return _block.selectB.modulate
	else:
		return Color(1,1,1,1)

func SelectB(c:Color = Color(1,1,1,1),s:float = 1):
	if _block!=null:
		_block.SelectB(c,s)

func DeselectB():
	if _block!=null:
		_block.DeselectB()

#region AnimeCounter
func Init():
	Bounce = V2BounceCounter.new()
	Bounce.End = Vector2(0,50)
	Bounce.Cur = Vector2(0,50)
	Bounce.Speed = 0.9
	Bounce.Decay = 0.7
	AphaTrans = FloatLinerCounter.new()
	AphaTrans.LinerTime = 0.2
	AphaTrans.Start = 0
	AphaTrans.End = 0

func Appear():
	AphaTrans.Start = 0
	AphaTrans.End = 1
	AphaTrans.Reset()
	Bounce.End = Vector2(0,0)
	
func Disappear():
	AphaTrans.Start = 1
	AphaTrans.End = 0
	AphaTrans.Reset()
	Bounce.End = Vector2(0,50)





func AddDownSpeed(v:float):
	Bounce.AddVocility(Vector2(0,v))
	
func AddSpeed(v:Vector2):
	Bounce.AddVocility(v)
	
	
	
func _setPosition(p:Vector2):
	curPosition = p
	if _block!=null:
		_block.position = curPosition+blockOffset
	if PawnSlot!=null:
		PawnSlot.position = curPosition
	



func UpdatePosition(dt:float):
	if !Bounce.Finish:
		Bounce.Update(dt)
		_setPosition(Bounce.Data())

func UpdateApha(dt):
	if !AphaTrans.Finish:
		AphaTrans.Update(dt)
		modulate = Color(1,1,1,AphaTrans.Data())

func UpdateData(dt:float):
	UpdatePosition(dt)
	UpdateApha(dt)
#endregion

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Init()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	UpdateData(delta)
