extends Node2D


var sprite = preload("res://Font/RenderTest/spriteItem.tscn")
var polygon = preload("res://Font/RenderTest/polygonItem.tscn")
var mesh = preload("res://Font/RenderTest/MeshItem.tscn")
var polygon2 = preload("res://Font/RenderTest/polygonItem2.tscn")
var line = preload("res://Font/RenderTest/LineItem.tscn")

var TT:int = 20
var ct:int = 0
var res = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var item = line
	var ma = Vector2i(60,60)
	
	for i in ma.x:
		for j in ma.y:
			var tem = item.instantiate()
			add_child(tem)
			(tem as Node2D).position = Vector2(1920/ma.x*i,1080/ma.y*j)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	ct+=1
	res += delta
	if ct == TT:
		ct = 0
		print(20/res)
		res = 0
		
		
	
