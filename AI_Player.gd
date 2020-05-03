extends RigidBody2D

## Unisgned Byte
class Byte extends Object:
	var bits = [false, false, false, false, false, false, false, false]
	var value = 0
	
	func _init(num: int):
		setVal(num)
		value = num
	
	func setVal(num: int):
		var mask = 1
		var value = 0
		for i in range(0, 8):
			if (num & mask):
				bits[i] = true
			else:
				bits[i] = false
			mask = mask << 1
	
	func getValue():
		return value
	
	func toString():
		var bitStr = ""
		for b in bits:
			bitStr = ("1" if(b==true) else "0") + bitStr
		return bitStr

var pop = []
var popSize = 12
var geneVals = []
var crossoverPoints = (popSize - 2) / 2
var gen = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	for i in range(0, popSize):
		pop.push_back(Byte.new((randi() % 255) + 1))
		#print("pop[" + String(i) + "] = " + pop[i].toString())
	geneValue(self.position)

class GeneSorter:
	static func sortGenes(a, b):
		if (a.getValue() < b.getValue()):
			return true
		return false

func geneValue(ball: Vector2):
	gen += 1
	geneVals.clear()
	var curY = self.position.y
	#print("Population:")
	#for gene in pop:
	#	print(gene.getValue())
	for i in range(0, popSize):
		var tmp = abs((ball.y * pop[i].getValue()) - ball.y)
		geneVals.push_back(tmp)
	geneVals.sort()
	#print("Population:")
	#for gene in geneVals:
	#	print(gene)
	##for gene in geneVals:
		#print(String(gene.getValue()))
	var avg = avgVal()
	var statStr = String(gen) + "," + String(avg) + "," + String(geneVals[0])
	print(statStr)
	geneVals = geneVals.slice(0, 1)
	var g0 = Byte.new(abs((geneVals[0] + ball.y) / ball.y))
	var g1 = Byte.new(abs((geneVals[1] + ball.y) / ball.y))
	geneVals.clear()
	geneVals.push_back(g0)
	geneVals.push_back(g1)
	print("slice[0]: " + String(geneVals[0].getValue()))

func crossover(a: Byte, b: Byte, point: int) -> Byte:
	var masks = [1, 3, 7, 15, 31, 63, 127]
	var newVal = (a.getValue() & masks[point]) | (b.getValue() & (~masks[point]))
	if (newVal == 0):
		newVal = 1
	# Mutate
	if ((geneVals[0].getValue() != 1) && (randi() % 100) < 15):
		newVal = (randi() % 255) + 1
	var tmp = Byte.new(newVal)
	#print(String(point))
	#print(a.toString() + " " + b.toString() + " " + tmp.toString())
	return tmp

func nextGen():
	for i in range(0, crossoverPoints):
		var cPoint = randi() % 7
		geneVals.push_back(crossover(geneVals[0], geneVals[1], cPoint))
		geneVals.push_back(crossover(geneVals[1], geneVals[0], cPoint))
	#pop.clear()
	pop = geneVals.duplicate(true)

func max_index(arr : Array):
	var maxVal = arr[0]
	var maxIndex = 0
	
	for i in range(1, 3):
		if arr[i] > maxVal:
			maxVal = arr[i]
			maxIndex = i
	return maxIndex

# AI determines what move to make based
# on STM
func _on_Ball_Moved_Tile(indices : Vector2):
	indices.y *= 60
	#if (geneVals[0].getValue() != 1):
	geneValue(indices)
	nextGen()
	self.position.y = pop[0].getValue() * indices.y
	#print("position: " + String(self.position.y))

func avgVal():
	var avg = 0
	for gene in geneVals:
		avg += gene
	avg = avg / popSize
	return avg

# Signal handler for punishing AI
# for missing Ball
func _on_Game_punish_AI():
	get_parent().misses += 1.0
	self.position.y = 300.0

# Signal handler for rewarding AI's
# collective moves for a successful
# Ball hit
func _on_AI_Good_Boi(body):
	get_parent().hits += 1.0
	self.position.y = 300.0
