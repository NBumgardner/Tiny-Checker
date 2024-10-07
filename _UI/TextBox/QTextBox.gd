class_name QTextBox
extends Node2D

var Delay:float
var CallBack:Callable
var CallBackData
var Size:Vector2

var text:QText
var Polygon:BezierRoundBoxArea
var Line:BezierRoundBoxBorder
var S:String
var LineColor:Color
var BackColor:Color

var lengthB:FloatBounceCounter
var sizeB:V2BounceCounter
var Clickable:bool
var OnDestory = false
var TextSize:float = 1
var Mute:bool = false
var Speed:float  =1

var NoBounce:bool = false
var PoolNum:int = 30

func _init(s:String,size:Vector2,lineColor:Color,backColor:Color,delay:float = 0,clickable:bool = false, callback:Callable = Callable(),callbackdata= null):
	Size = size
	CallBack = callback
	CallBackData = callbackdata
	Delay = delay
	S = s
	LineColor = lineColor
	Clickable = clickable
	lengthB = FloatBounceCounter.new()
	lengthB.End = 1
	lengthB.Cur = 0
	lengthB.Speed = 0.7
	lengthB.Decay = 0.7
	sizeB = V2BounceCounter.new()
	sizeB.End = Vector2(1,1)
	sizeB.Cur = Vector2(1,1)
	
var Onhover:bool = false	

func UpdateData(dt:float):
	if !lengthB.Finish:
		lengthB.Update(dt)
		SetLength(lengthB.Data())
	else:
		if OnDestory:
			queue_free()
	if !sizeB.Finish:
		sizeB.Update(dt)
		Polygon.scale = sizeB.Data()
		Line.scale = sizeB.Data()
	if Clickable and !OnDestory and  UFM.PointInRect(MouseManager.MousePosition()-UFN.N2GlobalPosition(self),Rect2(Vector2(-20,-Size.y/2),Size)):
		sizeB.End = Vector2(1.2,1.2)
		if !Onhover:
			SoundManager.PlaySound("BHover")
			Onhover = true
		if Input.is_action_just_pressed("MouseL"):
			CB()
	else:
		Onhover = false
		sizeB.End = Vector2(1,1)
	
func SetLength(l:float):
	if l<0:
		l=0
	Polygon.SetSize(Vector2(Size.x*l,Size.y))
	Line.SetSize(Vector2(Size.x*l,Size.y))
	Polygon.position = Vector2(Size.x*l/2-20,0)
	Line.position = Vector2(Size.x*l/2-20,0)


func CB():
	if CallBack.get_object()!=null:
		CallBack.call(CallBackData)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Polygon = BezierRoundBoxArea.new()
	Line = BezierRoundBoxBorder.new()
	Polygon.Radin = 20
	Line.Radin = 20
	Polygon.SetColor(BackColor)
	Line.SetColor(LineColor)
	Line.width = 3
	add_child(Polygon)
	add_child(Line)
	if NoBounce:
		lengthB.Cur = 1

func Destory():
	OnDestory = true
	lengthB.End = -50
	lengthB.Decay = 1.3
	if text!=null:
		text.queue_free()
	for i in get_children():
		if i is not Polygon2D and i is not Line2D:
			i.queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Delay>=0:
		Delay-=delta
		if Delay<=0:
			text = QText.new(S,LineColor,TextSize,false,Mute,PoolNum)
			text.tb.Data.DefaultHead.Speed = Speed
			add_child(text)
			var line = S.count("\n")
			if line<1:
				text.position = Vector2(0,-35*TextSize)
			else:
				text.position = Vector2(0,(-35-line*55/2)*TextSize)
			
	else:
		UpdateData(delta)
