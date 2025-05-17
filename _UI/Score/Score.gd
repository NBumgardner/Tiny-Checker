class_name Score
extends Node2D


var Num:QText
var Size:Vector2 = Vector2(60,40)
var LPoint:Array[ScorePoint]
var RPoint:Array[ScorePoint]
var curL:int
var curR:int

func SetNum(n):
	if n>=10:
		Num.position = Vector2(-30,-30)
	else:
		Num.position = Vector2(-17,-30)
	Num.SetText(str(int(n)))

func SetL(n:int,c:Color):
	if n>curL:
		SoundManager.PlaySound("LosePoint")
	curL = n
	for i in LPoint.size():
		if i<n:
			LPoint[i].SetColor(c)
		else:
			LPoint[i].SetColor(Color(0,0,0,1))

func SetR(n:int,c:Color):
	if n>curR:
		SoundManager.PlaySound("WinPoint")
	curR = n
	for i in RPoint.size():
		if i<n:
			RPoint[i].SetColor(c)
		else:
			RPoint[i].SetColor(Color(0,0,0,1))

func GenPoint(l:int,r:int):
	for i in LPoint:
		i.queue_free()
		LPoint = []
	for i in RPoint:
		i.queue_free()
		RPoint = []
	for i in l:
		var ttt = ScorePoint.new()
		ttt.size = Size
		ttt.Left = true
		add_child(ttt)
		ttt.position = Vector2(-80-i*(Size.x+9),0)
		LPoint.append(ttt)
	for i in r:
		var ttt = ScorePoint.new()
		ttt.size = Size
		ttt.Left = false
		add_child(ttt)
		ttt.position = Vector2(80+i*(Size.x+9),0)
		RPoint.append(ttt)
	curL = 0
	curR = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var ttt = BezierRoundBoxArea.new()
	ttt.SetSize(Vector2(120,80))
	ttt.SetRadin(20)
	ttt.SetColor(Color(0,0,0,1))
	add_child(ttt)
	ttt = BezierRoundBoxBorder.new()
	ttt.SetSize(Vector2(120,80))
	ttt.SetRadin(20)
	ttt.width = 3
	add_child(ttt)
	ttt = QText.new("",Color(1,1,1,1),1)
	add_child(ttt)
	Num = ttt
	ttt.position = Vector2(-17,-30)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
