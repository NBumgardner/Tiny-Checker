class_name BackPackPawn
extends Node2D



@export var Data:PawnData
var cell:BackPackCell
var parentPawn:BackPackPawn
var _select:SelectPawn 




func CanAddPawn(p:BackPackPawn):
	return Data.CanAddData(p.Data)


func AddPawn(p:BackPackPawn):
	SoundManager.PlaySound("Combine")
	p.RemoveFrom()
	Data.AddData(p.Data)
	p.queue_free()
	GenSprite()
	
func GetSubPawn(d:PawnData)->BackPackPawn:
	if d == Data:
		return self
	
	var t = Data
	while  t.PawnSlot!=null:
		if t.PawnSlot == d:
			var tem = BackPackPawn.new()
			tem.Data = t.RemoveData()
			tem.parentPawn = self
			GenSprite()
			tem.GenSprite()
			return tem
		t = t.PawnSlot
	return null
	
	
func RemoveFrom():
	if cell!=null:
		cell.RemovePawn()
	cell = null
	parentPawn = null

func BackToFrom():
	if parentPawn!=null:
		parentPawn.AddPawn(self)
	elif cell!=null:
		cell.AddPawn(self)
	else:
		queue_free()

func Clean():
	for i in get_children():
		if i is not SelectPawn:
			(i as Node).queue_free()


func GenSprite():
	Clean()
	var _height = 0
	var t = Data
	while t!=null:
		for i in t.PartsData:
			var tem = PawnPart.new()
			tem.Data = i
			add_child(tem)
			tem.GenSprite()
			tem.position = Vector2(0,-_height)
			_height+=tem.GetHeight()+7
		t = t.PawnSlot


func _ready() -> void:
	var tem = SelectPawn.new()
	add_child(tem)
	_select = tem


func Select(r:Rect2):
	_select.Rect = r
	_select.Appear()
	
func Unselect():
	_select.DisAppear()
	
func GetMouseInData()->PawnData:
	var tem = Data
	var ch = 0
	while tem!=null:
		if UFM.PointInRect(MouseManager.MousePosition()-UFN.N2GlobalPosition(self)+Vector2(0,ch),tem.GetSelfRect()):
			return tem
		ch+=tem.GetSelfHeight()
		tem = tem.PawnSlot
	return null
	
	
func SelectData(d:PawnData):
	var tem = Data
	var ch = 0
	while tem!=null:
		if tem == d:
			var r = tem.GetSelfRect()
			Select(Rect2(r.position-Vector2(0,ch),r.size))
			return
		ch +=tem.GetSelfHeight()
		tem = tem.PawnSlot
			

var mouseDownPosition :Vector2

func CheckClick():
	if cell == null:
		var t = GetMouseInData()
		if t!=null:
			t=t.Copy()
			t.PawnSlot = null
			CheckerManager.Ckeck(t)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("MouseL"):
		mouseDownPosition = MouseManager.MousePosition()
		
	if Input.is_action_just_released("MouseL"):
		if(MouseManager.MousePosition()-mouseDownPosition).length_squared()<25:
			CheckClick()
