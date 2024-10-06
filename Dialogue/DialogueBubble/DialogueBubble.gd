class_name DialogueBubble
extends Node2D


@export var FullSize:Vector2 = Vector2(1600,400)
@export var Radin:float = 50
@export var Board1:Vector2 = Vector2(10,10)
@export var Board2:Vector2 = Vector2(50,50)
@export var BoardText:Vector2 = Vector2(90,70)



@export var BounceSpeed:Vector2 = Vector2(1,1)
@export var BounceFrequance:Vector2 = Vector2(1,1)
@export var BounceDecay:Vector2 = Vector2(1,1)


@export var BackGround:BezierRoundBoxArea
@export var Borader:BezierRoundBoxBorder
@export var Patten:BezierRoundBoxArea
@export var Text:TextBox



var BubbleBounce : V2BounceCounter
var ScaleCycle:V2CycleCounter



func SetSize(v:Vector2):
	BubbleBounce.End = v


func _setSize(v:Vector2):
	BackGround.SetSize(v)
	Borader.SetSize(v-Board1)
	Patten.SetSize(v-Board2)
	SetTextSize(v)

func SetTextSize(v:Vector2):
	var tx = v.x/FullSize.x
	var ty = v.y/FullSize.y
	if tx<0:
		tx = 0
	if ty<0:
		ty = 0
	Text.scale = Vector2(tx,ty)
	

func SetRadin(r:float):
	BackGround.SetRadin(r)
	Borader.SetRadin(r)
	Patten.SetRadin(r)


func Show():
	SetSize(FullSize)
func Hide():
	SetSize(Vector2(-45,-45))
	Text.Hide()


func InitData():
	BubbleBounce = V2BounceCounter.new()
	BubbleBounce.Speed =1
	BubbleBounce.Frequnce = 1
	BubbleBounce.Decay = 1
	#BubbleBounce.BounceRange =1
	BubbleBounce.Cur = Vector2(0,0)
	SetRadin(Radin)
	_setSize(Vector2(0,0))
	Text.Area.position = -0.5*(FullSize-BoardText)
	Text.Area.size = (FullSize-BoardText)
	ScaleCycle = V2CycleCounter.new()
	ScaleCycle.Origin = Vector2(1,1)
	ScaleCycle.MaxRange = Vector2(1+10/FullSize.x,1+10/FullSize.y)
	ScaleCycle.Phase = PI/2
	ScaleCycle.CycleTime = 4
	

func _ready() -> void:
	InitData()


func UpdateData(dt:float):
	if !BubbleBounce.Finish:
		BubbleBounce.Update(dt)
	ScaleCycle.Update(dt)
	_setSize(BubbleBounce.Data()*ScaleCycle.Data())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	UpdateData(delta)
