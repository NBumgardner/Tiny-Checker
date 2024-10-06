class_name QLine
extends Line2D


func _init(p:PackedVector2Array,w:float,c:Color,loop:bool = false):
	points = p
	width = w
	default_color = c
	closed = loop
	joint_mode = 2
	end_cap_mode = 2
	begin_cap_mode = 2
