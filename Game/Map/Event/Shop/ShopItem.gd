class_name ShopItem
extends Node

@export var Sold:Sprite2D
@export var c:Color
@export var defaultData:ShopItemData

var MoneyCount:Money
var Price:int
var SoldPawn:PawnData
var ShowPawn:BackPackPawn
var text:QTextBox
var Bag:BackPack

var Dia:Qdia

func Init(bag:BackPack,m:Money,data:ShopItemData):
	defaultData = data
	MoneyCount = m
	Bag = bag

func TrySold(n):
	if !Bag.OnScreen:
		if MoneyCount.GetMoney(Price):
			Solded()

func Solded():
	if Dia!=null:
		Dia.SetData(QdiaData.new("Wise choice!",TextureManager.GetTexture("ShopC2")))
	text.Destory()
	Bag.AddPawn(SoldPawn,UFN.N2GlobalPosition(ShowPawn))
	ShowPawn.queue_free()
	Sold.visible = true
	
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Price = defaultData.price
	SoldPawn = defaultData.P
	text = QTextBox.new(str(Price),Vector2(120,60),c,Color(0,0,0,1),0,true,Callable(self,"TrySold"),null)
	text.position = Vector2(-70,35)
	add_child(text)
	ShowPawn = BackPackPawn.new()
	ShowPawn.Data = SoldPawn
	ShowPawn.GenSprite()
	ShowPawn.position = Vector2(0,-20)
	add_child(ShowPawn)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
