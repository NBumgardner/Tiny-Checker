class_name MapEvent
extends Node2D

@export var Icon:Texture
@export var ShowItem:Array[Node2D]

var MainMap:Map
var IconSprite:Sprite2D
var IconBounce:V2BounceCounter

var State:int=0
var allItem:Array[QShow]
var Continue:QTextBox
var Showed:bool = false

	

func EndEvent(n):
	Showed = false
	for i in allItem.size():
		allItem[i].Destory(i*0.1)
	Continue.Destory()
	EndEvenrCallBack()
	
func EndEvenrCallBack():
	MainMap.StartSelect()

func Show():
	Showed = true
	for i in ShowItem.size():
		var ttt = QShow.new(Vector2(0,0),i*0.3)
		ttt.add_child(ShowItem[i])
		allItem.append(ttt)
		add_child(ttt)
	Continue = QTextBox.new("Continue->",Vector2(350,80),Color(1,1,1,1),Color(0,0,0,1),0,true,Callable(self,"EndEvent"),null)
	Continue.position = Vector2(300,-400)
	Continue.z_index = 5
	add_child(Continue)
	MainMap.MoneyCount.Show()
func InitItem():
	pass

var onHover:bool = false

func Hover():
	if onHover == false:
		SoundManager.PlaySound("MHover")
		onHover = true
	IconBounce.End = Vector2(1.2,1.2)
func Dehover():
	onHover = false
	IconBounce.End = Vector2(1,1)

func _init() -> void:
	IconBounce = V2BounceCounter.new()
	IconBounce.End = Vector2(1,1)
	IconBounce.Cur = Vector2(1,1)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in ShowItem:
		remove_child(i)
	InitItem()
	IconSprite = Sprite2D.new()
	IconSprite.texture = Icon
	IconSprite.z_index = -5
	add_child(IconSprite)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !IconBounce.Finish:
		IconBounce.Update(delta)
		IconSprite.scale = IconBounce.Data()
	if Showed and Input.is_action_just_pressed("Space"):
		EndEvent(null)
