extends Node

func _ready():
	## Test Vector functions
	var left : Vector = Vector.new([1, 2, 3])
	var right : Vector = Vector.new([1, 2, 3])
	var tmp = left.add(right)
	tmp.print()
	tmp = left.sub(right)
	tmp.print()
	tmp = left.mult(right)
	tmp.print()
	tmp = left.div(right)
	tmp.print()
	tmp = left.dot(right)
	tmp.print()
	tmp.setVal(0, 99)
	tmp.print()
	var tmpMat = Matrix.new()
	tmpMat.setVal(0, 4, 99)
	tmpMat.print()

class Vector extends Object:
	var size : int = 0 setget ,getSize
	var vals : Array  = [] setget ,getVals
	
	func getSize() -> int:
		return size
	func setVal(ind : int, val):
		if (ind >= 0):
			vals[ind] = val
	func appendVal(val):
		vals.append(val)
		size += 1

	func getVals() -> Array:
		return vals
	
	func _init(nums : Array = []):
		size = nums.size()
		vals = nums
	
	func add(rop : Vector) -> Vector:
		assert(size == rop.size)
		var result = Vector.new()
		for i in range(0, size):
			result.vals.append(vals[i] + rop.vals[i])
		return result
	
	func sub(rop : Vector) -> Vector:
		assert(size == rop.size)
		var result = Vector.new()
		for i in range(0, size):
			result.vals.append(vals[i] - rop.vals[i])
		return result
	
	func mult(rop : Vector) -> Vector:
		assert(size == rop.size)
		var result = Vector.new()
		for i in range(0, size):
			result.vals.append(vals[i] * rop.vals[i])
		return result
	
	func div(rop : Vector) -> Vector:
		assert(size == rop.size)
		var result = Vector.new()
		for i in range(0, size):
			result.vals.append(vals[i] / rop.vals[i])
		return result
	
	func dot(rop : Vector) -> Vector:
		assert(size == rop.size)
		var result = Vector.new([0.0])
		for i in range(0, size):
			result.vals[0] += vals[i] * rop.vals[i]
		return result

	func print():
		print(vals)

class Matrix extends Object:
	var size : Array = [0, 0] setget ,getSize
	var vals : Array = [] setget ,getVals
	
	func getSize() -> Array:
		return size
	func getVals(row : int = -1) -> Array:
		if (row >= 0):
			return vals[row]
		else:
			return vals
	func getVal(row : int, col : int):
		return vals[row].val(col)
	
	func _init(matSize : Array = [10, 10]):
		size = matSize
		for i in range(0, matSize[0]):
			var newVec = Vector.new()
			for k in range(0, matSize[1]):
				newVec.appendVal(0)
			vals.append(newVec)
	
	func setVal(row : int, col : int, val):
		vals[row].setVal(col, val)
	
	func dot(rop : Matrix) -> Matrix:
		assert(size == rop.size)
		var result : Matrix = Matrix.new([size[0], rop[3]])
		for i in range(0, size[0]):
			var curRow = vals[i]
			for j in range(0, rop.size[0]):
				
	
	func print():
		print(" ")
		for i in range(0, size[0]):
			vals[i].print()
		print(" ")