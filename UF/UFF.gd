class_name UFF


static func PathJoin(p:String,f:String)->String:
	return p+"/"+f


static func IsImport(n:String)->bool:
	if n.length()<7:
		return false
	if n[-1] == "t" and n[-2] == "r" and n[-3] == "o" and n[-4] == "p" and n[-5] == "m" and n[-6] == "i" and n[-7] == ".":
		return true
	else:
		return false



static func IsType(n:String,t:String):
	var off = n.length()-t.length()
	if off<0:
		return false
	for i in t.length():
		if n[i+off] != t[i]:
			return false
	return true
