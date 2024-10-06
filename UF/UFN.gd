class_name UFN


static func N2GlobalPosition(n:Node2D)->Vector2:
	var res :Vector2 = n.position
	var tem = n.get_parent()
	while tem is Node2D:
		res+=tem.position
		tem = tem.get_parent()
	return res


static  func N2GlobalScale(n:Node2D)->Vector2:
	var res :Vector2 = n.scale
	var tem = n.get_parent()
	while tem is Node2D:
		res*=tem.scale
		tem = tem.get_parent()
	return res
	
	
static func RemoveParent(n:Node):
	var t = n.get_parent()
	if t!=null:
		t.remove_child(n)
