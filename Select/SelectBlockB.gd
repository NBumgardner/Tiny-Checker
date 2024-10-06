class_name SelectBlockB
extends SelectBlockA



func InitSprite():
	var tem1 = Sprite2D.new()
	tem1.texture = TextureManager.GetTexture("SelectBB")
	tem1.z_index = 0
	add_child(tem1)
	TA = tem1
	tem1 = Sprite2D.new()
	tem1.texture = TextureManager.GetTexture("SelectRB")
	tem1.z_index = 0
	add_child(tem1)
	RA = tem1
	tem1 = Sprite2D.new()
	tem1.texture = TextureManager.GetTexture("SelectLB")
	tem1.z_index = 0
	add_child(tem1)
	LA = tem1
	_lq3 = BoardManager.GetLQ3()
	_l = BoardManager.GetL()
	_yp = BoardManager.GetYP()

	
func SetHex(t:float):
	TA.position = Vector2(0,_l*t*_yp+3)
	RA.position = Vector2(_lq3+4,-_l*_yp)*t/2
	LA.position = Vector2(-_lq3-4,-_l*_yp)*t/2
