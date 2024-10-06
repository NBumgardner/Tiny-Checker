class_name  ShopEvent
extends MapEvent

var Dia:Qdia

func InitItem():
	var td = MapEventManager.GetShopItem3()
	var te = Qdia.new(Vector2(1200,120),0.7,Vector2(4,-237),Vector2(523,117),QdiaData.new("Good to see you. Come check out these powerful pieces.",TextureManager.GetTexture("ShopC1")),1.5)
	for i in 3:
		var tem :ShopItem= (load("res://Game/Map/Event/Shop/ShopItem.tscn")as PackedScene).instantiate()
		tem.Init(MainMap.Bag,MainMap.MoneyCount,td[i])
		tem.position = Vector2(-474+i*290,209)
		ShowItem.append(tem)
		tem.Dia = te
	
	ShowItem.append(te)
	Dia = te
