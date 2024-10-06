class_name UFT


static func TxtToCharData(s:String)->CharData:
	var res:CharData = CharData.new()
	var tem = s.split(" ")
	var d1 = tem[0].to_int()
	var d2 = tem[1].to_int()
	var d3 = tem[2].to_int()
	var d4 = tem[3].to_int()
	res.rect = Rect2(d1,d2,d3-d1,d4-d2)
	res.offset = tem[4].to_int()
	return res
	
	
static func TakeScreenShot(node:Node):
		var viewport = node.get_viewport() # Get the main viewport
		var texture = viewport.get_texture() # Get the viewport's texture
		var img = texture.get_image()
		img.save_png("res://screenshot.png")
