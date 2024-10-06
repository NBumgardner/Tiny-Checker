class_name Map
extends Node2D

@export var Bag:BackPack
@export var MoneyCount:Money
@export var MainGame:Game
@export var EventLayer:Node2D
@export var Data:MapData
@export var MoveTime:float = 2
@export var MoveCurve:Curve


var ScreenCenter:Vector2 = Vector2(1920/2,1080/2)
var Events:Array[Array]
var CurrentEventCount:int = 0

var OnPlayerSelect:bool
var OnMove:bool
var MoveCount:float
var MoveTo:MapEvent

func InitMap():
	MoneyCount.SetMonry(100)
	OnMove = false
	OnPlayerSelect = false
	for i in Events:
		for j in i:
			j.queue_free()
	Events = []
	CurrentEventCount = 0
	var res:Array[MapEvent]
	var tem:FightEvent
	res = []
	for i in Data.Event12:
		res.append(MapEventManager.GetEvent(i))
	Events.append(res)
	res = []
	tem = FightEvent.new()
	tem.Data =MainGame.Data.MatchList[1]
	tem.Icon = TextureManager.GetTexture("FightIcon")
	res.append(tem)
	Events.append(res)
	
	res = []
	for i in Data.Event23:
		res.append(MapEventManager.GetEvent(i))
	Events.append(res)
	res = []
	tem = FightEvent.new()
	tem.Data =MainGame.Data.MatchList[2]
	tem.Icon = TextureManager.GetTexture("FightIcon")
	res.append(tem)
	Events.append(res)
	
	res = []
	for i in Data.Event34:
		res.append(MapEventManager.GetEvent(i))
	Events.append(res)
	res = []
	tem = FightEvent.new()
	tem.Data =MainGame.Data.MatchList[3]
	tem.Icon = TextureManager.GetTexture("FightIcon")
	res.append(tem)
	Events.append(res)
	
	res = []
	for i in Data.Event45:
		res.append(MapEventManager.GetEvent(i))
	Events.append(res)
	res = []
	tem = FightEvent.new()
	tem.Data =MainGame.Data.MatchList[4]
	tem.Icon = TextureManager.GetTexture("FightIcon")
	res.append(tem)
	Events.append(res)
	
	res = []
	for i in Data.Event56:
		res.append(MapEventManager.GetEvent(i))
	Events.append(res)
	res = []
	tem = FightEvent.new()
	tem.Data =MainGame.Data.MatchList[5]
	tem.Icon = TextureManager.GetTexture("FightIcon")
	res.append(tem)
	Events.append(res)

	res = []
	for i in Data.Event67:
		res.append(MapEventManager.GetEvent(i))
	Events.append(res)
	res = []
	tem = FightEvent.new()
	tem.Data =MainGame.Data.MatchList[6]
	tem.Icon = TextureManager.GetTexture("FightIcon")
	res.append(tem)
	Events.append(res)
	
	res = []
	for i in Data.Event78:
		res.append(MapEventManager.GetEvent(i))
	Events.append(res)
	res = []
	tem = FightEvent.new()
	tem.Data =MainGame.Data.MatchList[7]
	tem.Icon = TextureManager.GetTexture("FightIcon")
	res.append(tem)
	Events.append(res)
	
	res = []
	for i in Data.Event89:
		res.append(MapEventManager.GetEvent(i))
	Events.append(res)
	res = []
	tem = FightEvent.new()
	tem.Data =MainGame.Data.MatchList[8]
	tem.Icon = TextureManager.GetTexture("FightIcon2")
	res.append(tem)
	Events.append(res)
	InitEventLayer()

func InitEventLayer():
	EventLayer.position = ScreenCenter
	
	var dis = 300
	for i in Events:
		InitEventLine(dis,i)
		dis+=400
		
func InitEventLine(dx:float,a:Array[MapEvent]):
	var t1 = 250*(a.size()-1)
	var t = -t1/2
	for i in a:
		if i!=null:
			i.MainMap = self
			EventLayer.add_child(i)
			i.position = Vector2(dx,t)
			t+=250


func StartSelect():
	MoneyCount.Hide()
	if CurrentEventCount<Events.size():
		OnPlayerSelect = true
		if CurrentEventCount>0:
			for i in Events[CurrentEventCount-1]:
				(i as CanvasItem).modulate = Color(0.5,0.5,0.5,1)
	else:
		MainGame.EndGame()
	
func UpdateSelectEvent():
	for i in Events[CurrentEventCount]:
		var e = i as MapEvent
		e.MainMap = self
		if (MouseManager.MousePosition()-UFN.N2GlobalPosition(e)).length_squared()<6400:
			e.Hover()
			if Input.is_action_just_pressed("MouseL"):
				GotoEvent(e)
		else:
			e.Dehover()
	
var Mform:Vector2
var Mto:Vector2

func GotoEvent(e:MapEvent):
	SoundManager.PlaySound("MoveToEvent")
	OnPlayerSelect = false
	OnMove = true
	MoveCount = 0
	MoveTo = e
	CurrentEventCount+=1
	Mform = EventLayer.position
	Mto = Mform-UFN.N2GlobalPosition(MoveTo)+ScreenCenter

func UpdateGoToEvent(dt:float):
	if MoveCount<MoveTime:
		MoveCount+=dt
		if MoveCount>MoveTime:
			MoveCount = MoveTime
		EventLayer.position = Mform.lerp(Mto,MoveCurve.sample(MoveCount/MoveTime))
	else:
		OnMove = false
		MoveTo.Show()







func GetBackPack()->BackPack:
	return Bag
	
func ActiveMap():
	Bag.Active = true
	
func DeactiveMap():
	Bag.Active = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if OnPlayerSelect and !Bag.OnScreen:
		UpdateSelectEvent()
	if OnMove:
		UpdateGoToEvent(delta)
