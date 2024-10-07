class_name Game
extends Node2D

@export var Data:GameData
@export var MainMatch:Match
@export var MainMap:Map
@export var MatchShower:Shower
@export var MapShower:Shower
@export var E:GameIsEnd





func StartMapAt(i:int):
	MainMap.CurrentEventCount = i
	MainMap.ActiveMap()
	MapShower.ShowInst()
	MainMap.GotoEvent(MainMap.Events[i][0])

func StartMatch(d:MatchData):
	MainMap.DeactiveMap()
	MainMatch.Data = d
	MainMatch.PawnPack = MainMap.GetBackPack()
	MainMatch.InitMatch()
	MatchShower.Show()


func MatchEnd(m:Match):
	if m.Data.BoardID != 1:
		MainMap.MoneyCount.AddMonry(m.MatchMoney+60)
	else:
		SoundManager.PlaySound("Transform")
	MainMap.ActiveMap()
	MapShower.ShowInst()
	MatchShower.Hide()
	MainMap.StartSelect()
	
func RestartGame():
	MainMap.InitMap()
	MainMap.Bag.ReStart()
	GameStart()
	
func EndGame():
	MapShower.Hide()
	MapShower.Hide()
	E.InitDia()
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MainMap.DeactiveMap()
	MainMap.InitMap()
	test()
	

func GameStart():
	StartMatch(Data.MatchList[0])
	#StartMapAt(0)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func test():
	pass
	#StartMapAt(0)
	#MatchEnd(null)
	#StartMatch(Data.MatchList[0])
