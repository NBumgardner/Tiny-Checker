class_name SelectLine
extends Node2D

var DotsLine:Array[Sprite2D]
var DotsBack:Array[Sprite2D]
var DotsNum:int = 8
var Start:Vector2
var End:Vector2
var Center:Vector2


func InitDots():
	for i in DotsNum:
		var tb = Sprite2D.new()
		tb.texture = TextureManager.GetTexture("SelectDotBack")
		DotsBack.append(tb)
		tb.z_index = 2
		tb.self_modulate = Color(0,0,0,1)
		add_child(tb)
		var tl = Sprite2D.new()
		tl.texture = TextureManager.GetTexture("SelectDotLine")
		DotsLine.append(tl)
		tl.z_index = 2
		add_child(tl)

func SetColor(c:Color):
	modulate = c

func Appear():
	visible = true
	
func Disappear():
	visible = false

func _init():
	InitDots()

func SetEnd(e:Vector2):
	End = e
	UpdateCenter()
	UpdatePoints()


func SetData(s:Vector2,e:Vector2,c:Color = Color(1,1,1,1)):
	Start = s
	End = e
	UpdateCenter()
	UpdatePoints()
	SetColor(c)

func UpdateCenter():
	Center = (Start+End)/2-Vector2(0,90)
	
func UpdatePoints():
	var dc :float = 1.0/(DotsNum)
	var c:float = dc/2
	for i in DotsNum:
		SetPoint(i,Start.lerp(Center,c).lerp(Center.lerp(End,c),c))
		c+=dc
	
func SetPoint(i:int,p:Vector2):
	DotsLine[i].position = p
	DotsBack[i].position = p

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
