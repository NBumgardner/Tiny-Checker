class_name BackPack
extends Node2D

@export var SlotSize:Vector2i = Vector2i(6,5):
	set(value):
		SlotSize = value
		_startPosition = StartPosition()
@export var BlockLength :float= 50:
	set(value):
		BlockLength = value
		_blockLengthSqrt3 = value*sqrt(3)
@export var BlockYPress :float= 0.8
@export var PlayerBlockStart:Vector2i = Vector2i(1,1)
@export var InitPlayerPawn:Array[int]


var Slots:Array[Array] = []

var _blockLengthSqrt3 = BlockLength*sqrt(3)
var _startPosition:Vector2 = StartPosition()

var OnScreen:bool = true:
	set(value):
		OnScreen = value
		if value == false:
			PutPawnBack()



func PlayerBlockPosition(i:int)->Vector2i:
	if i<=3:
		return PlayerBlockStart+Vector2i(i,0)
	elif i<=6:
		if PlayerBlockStart.y%2==0:
			return PlayerBlockStart+Vector2i(i-4,1)
		else:
			return PlayerBlockStart+Vector2i(i-4+1,1)
	elif i<=8:
		return PlayerBlockStart+Vector2i(i-7+1,2)
	else:
		if PlayerBlockStart.y%2==0:
			return PlayerBlockStart+Vector2i(1,3)
		else:
			return PlayerBlockStart+Vector2i(2,3)

		
func PlayerCell(i:int)->BackPackCell:
	var tem = PlayerBlockPosition(i)
	return Slots[tem.y][tem.x]

func StartPosition()->Vector2:
	return Vector2((SlotSize.x-0.5)*_blockLengthSqrt3/-2,(SlotSize.y-1)*3.0/2*BlockLength/-2)

func BoardPositionToPosition(v:Vector2i)->Vector2:
	var off = 0
	if v.y%2 == 1:
		off = _blockLengthSqrt3 / 2
	return Vector2(v.x*_blockLengthSqrt3+off,BlockLength*1.5*v.y*BlockYPress)+_startPosition

func PositionToBoardPosition(v:Vector2)->Vector2i:
	var t = _positionToBoardPosition(v+Vector2(0,20))
	for i in 10:
		if PlayerBlockPosition(i) == t:
			return t
	return _positionToBoardPosition(v)

func _positionToBoardPosition(v:Vector2)->Vector2i:
	v-=_startPosition
	var yi:int=floori((v.y+3.0/4*BlockLength*BlockYPress)/(3.0/2*BlockLength*BlockYPress)) 
	var off:float = 0
	if yi%2==0:
		off+=_blockLengthSqrt3/2
	var xi:int = floori((v.x+off)/_blockLengthSqrt3)
	return Vector2i(xi,yi)


func GetSlot(v:Vector2i)->BackPackCell:
	if v.x<0 or v.x>=SlotSize.x or v.y<0 or v.y>=SlotSize.y:
		return null
	else:
		return Slots[v.y][v.x]


func InitSlot():
	for i in SlotSize.y:
		Slots.append([])
		for j in SlotSize.x:
			var tem = BackPackCell.new()
			add_child(tem)
			tem.position = BoardPositionToPosition(Vector2i(j,i))
			tem.GenEmpty(BlockYPress,BlockLength)
			#tem.GenPlayerBlock(0,BlockYPress,BlockLength)
			Slots[i].append(tem)
			
	for i in 10:
		var p = PlayerBlockPosition(i)
		(Slots[p.y][p.x] as BackPackCell).GenPlayerBlock(i,BlockYPress,BlockLength)

func InitPawn():
	var t = 9
	for i in InitPlayerPawn:
		var tem = BackPackPawn.new()
		tem.Data = PawnManager.GetPlayerPawn(i)
		tem.GenSprite()
		PlayerCell(t).AddPawn(tem)
		t-=1


func InitData():
	InitSlot()
	InitPawn()
	aphaC = FloatLinerCounter.new()
	aphaC.LinerTime = 1
	aphaC.Start = 1
	aphaC.End = 1
	position = Vector2(1000,1400)
	positionF = V2BounceCounter.new()
	positionF.End =Vector2(1000,1400)
	positionF.Cur = Vector2(1000,1400)
	positionF.Speed = 1
	positionF.Decay = 0.8
	OnScreen = false

func _ready() -> void:
	InitData()

var selectData:PawnData
var selectPawn:BackPackPawn

func UpdateSelect():
	var td:PawnData = null
	var tp:BackPackPawn = null
	for i in Slots:
		for j in i:
			var c = j as BackPackCell
			if c.P!=null:
				var t =c.P.GetMouseInData()
				if t!=null:
					td = t
					tp = c.P
	if selectData!=td:
		if selectPawn!=null :
			selectPawn.Unselect()
		if td!=null:
			tp.SelectData(td)
			SoundManager.PlaySound("Select")
	selectData = td
	selectPawn = tp

var _takenPawn:BackPackPawn
var _holding:bool = false

func HoldPawn():
	if _takenPawn!=null:
		_takenPawn.position = MouseManager.MousePosition()-UFN.N2GlobalPosition(self)
		_holding = true

func TakePawn():
	if selectPawn!=null:
		_takenPawn = selectPawn.GetSubPawn(selectData)
		if _takenPawn!=null:
			UFN.RemoveParent(_takenPawn)
			add_child(_takenPawn)
			SoundManager.PlaySound("Pick")
	
func RelesePawn():
	_holding = false
	if hoverCell!=null:
		hoverCell.Dehover()
		hoverCell = null
	if _takenPawn ==null:
		return
	var t = PositionToBoardPosition(MouseManager.MousePosition()-UFN.N2GlobalPosition(self))
	CheckerManager.Ckeck(_takenPawn.Data)
	var c = GetSlot(t)
	if c == null:
		PutPawnBack()
		return 
	if !c.CanAddPawn(_takenPawn):
		PutPawnBack()
		return 
	c.AddPawn(_takenPawn)
	_takenPawn = null
	
func PutPawnBack():
	if _takenPawn!=null:
		_takenPawn.BackToFrom()
		_takenPawn = null

var hoverCell:BackPackCell
func HoverCell():
	var c = GetSlot(PositionToBoardPosition(MouseManager.MousePosition()-UFN.N2GlobalPosition(self)))
	if c!=hoverCell:
		if hoverCell!=null:
			hoverCell.Dehover()
		if c!=null:
			c.Hover()
	hoverCell = c
	
var aphaC:FloatLinerCounter
var positionF:V2BounceCounter
@export var Cover:Sprite2D
func UpdateBagPack(dt:float):
	if !aphaC.Finish:
		aphaC.Update(dt)
		Cover.modulate = Color(1,1,1,aphaC.Data())
	if ! positionF.Finish:
		positionF.Update(dt)
		position = positionF.Data()
		
func UpdateHoverBagPack():
	if !isShow:
		var tt = 1080 -MouseManager.MousePosition().y
		if tt<200:
			Hover()
			if Input.is_action_just_pressed("MouseL"):
				Show()
		else:
			Dehover()
	else:
		var t = MouseManager.MousePosition()
		if (t.x<600 or t.x>1400 or t.y<400):
			Dehover()
			if Input.is_action_just_pressed("MouseL"):
				Hide()
		else:
			Hover()
		
var isShow:bool = false

func Show():
	SoundManager.PlaySound("OpenBag")
	isShow = true
	OnScreen = true
	aphaC.Start = 1
	aphaC.End = 0
	aphaC.Reset()
	positionF.End = Vector2(1000,750)
	
func Hide():
	SoundManager.PlaySound("CloseBag")
	isShow = false
	OnScreen = false
	aphaC.Start = 0
	aphaC.End = 1
	aphaC.Reset()
	positionF.End = Vector2(1000,1400)

var Onhover:bool = false

func Hover():
	if !Onhover:
		SoundManager.PlaySound("BHover")
		Onhover = true
	if OnScreen:
		positionF.End = Vector2(1000,750)
	else:
		positionF.End = Vector2(1000,1300)
func Dehover():
	Onhover = false
	if OnScreen:
		positionF.End = Vector2(1000,850)
	else:
		positionF.End = Vector2(1000,1400)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
var Active:bool = true

func Wubble():
	SoundManager.PlaySound("GetPawn")
	positionF.AddVocility(Vector2(0,-30))

func AddPawn(p:PawnData,pawnPosition:Vector2 = Vector2(1920/2,1080/2)):
	var tem:PawnToBag = (load("res://BackPack/PawnToBag.tscn")as PackedScene).instantiate()
	tem.Init(self,p,pawnPosition,Vector2(1920/2,1080))
	get_parent().add_child(tem)
	
	var tp = BackPackPawn.new()
	tp.Data = p
	tp.GenSprite()
	
	for i in 10:
		var tems = GetSlot(PlayerBlockPosition(i))
		if tems.CanAddPawn(tp):
			tems.AddPawn(tp)
			return
			
	for i in Slots:
		for j in i:
			if (j as BackPackCell).CanAddPawn(tp):
				(j as BackPackCell).AddPawn(tp)
				return
			
			
	tp.queue_free()
	
	

func _process(delta: float) -> void:
	if Active:
		if OnScreen:
			UpdateSelect()
			if Input.is_action_just_pressed("MouseL"):
				TakePawn()
			HoldPawn()
			if _holding:
				HoverCell()
			if Input.is_action_just_released("MouseL"):
				RelesePawn()
		UpdateBagPack(delta)
		UpdateHoverBagPack()
	
