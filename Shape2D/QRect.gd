class_name QRect
extends Line2D


# Called when the node enters the scene tree for the first time.
func _init(r:Rect2,w:float,c:Color) -> void:
	var p = PackedVector2Array()
	p.append(r.position)
	p.append(r.position+Vector2(r.size.x,0))
	p.append(r.position+r.size)
	p.append(r.position+Vector2(0,r.size.y))
	points = p
	width = w
	default_color = c
	closed = true
	joint_mode = 2
	end_cap_mode = 2
	begin_cap_mode = 2
