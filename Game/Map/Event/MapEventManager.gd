extends Node


@export var ShopNormalItem:Array[ShopItemData]
@export var ShopGreatItem:Array[ShopItemData]

var EventDic:Dictionary




func GetEvent(name:String)->MapEvent:
	if EventDic.has(name):
		return (EventDic[name] as PackedScene).instantiate()
		
	return null
	

func GetShopItem3()->Array[ShopItemData]:
	var res:Array[ShopItemData] = []
	res.append(UFM.GetRandonItem(ShopGreatItem))
	res.append(UFM.GetRandonItem(ShopNormalItem))
	res.append(UFM.GetRandonItem(ShopNormalItem))
	return res



func _ready() -> void:
	EventDic["Shop"] = load("res://Game/Map/Event/Shop/Shop.tscn")
