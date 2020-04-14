extends RigidBody2D

signal hitBall

# Declare member variables here
# Old from Lab #1
var prevPos = Vector2(-1, -1)
var STM : Dictionary
var stateStack : Array
var BETA = 0.35

# New vars for Lab #2

onready var w1 = NumGD.fileToMatrix("matrix1.out")
onready var w2 = NumGD.fileToMatrix("matrix2.out")
onready var w3 = NumGD.fileToMatrix("matrix3.out")

# Called when the node enters the scene tree for the first time.
func _ready():
	#self.contact_monitor = true
	#self.contacts_reported = 1
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

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
	# get input and normalize values
	var input = NumGD.Matrix.new([1, 2])
	input.setVal(0, 0, indices[0]/10)
	input.setVal(0, 1, indices[1]/10)
	
	var move = input.dot(w1).sigmoid().dot(w2).sigmoid().dot(w3).sigmoid()
	
	self.position.y = move.getVal(0, 0) * 600
#	if (stateStack.size() > 100):
#		stateStack.clear()
#		$"../Ball".resetBall()
#
#	var paddlePos = round(self.position.y/60)
#	var transition
#
#	if prevPos == Vector2(-1, -1):
#		prevPos = indices
#		return
#	var state = str([prevPos, indices, int(paddlePos)])
#	if STM.has(state):
#		transition = STM[state]
#
#	else:
#		var prob = 1.0/3.0
#		var newState = [prob, prob, prob]
#
#		if (paddlePos + 1) > 10:
#			newState[0] = 0
#			newState[1] = 1.0/2.0
#			newState[2] = 1.0/2.0
#		elif (paddlePos - 1) < 0:
#			newState[0] = 1.0/2.0
#			newState[1] = 1.0/2.0
#			newState[2] = 0
#
#		transition = newState
#		STM[state] = transition
#
#	var maxIndex = max_index(transition)
#
#	if transition[0] == transition[1] and transition[1] == transition[2]:
#		maxIndex = randi() % 3
#
#	if maxIndex == 0:
#		# move down
#		self.position.y += 60
#	elif maxIndex == 2:
#		# move up
#		self.position.y -= 60
#	stateStack.push_front(state)
#	prevPos = indices

# Signal handler for punishing AI
# for missing Ball
func _on_Game_punish_AI():
	## This code isn't used anymore
	## so we pass instead of exec.
	## Left for historical purpose.
	pass
	get_parent().misses += 1.0
	self.position.y = (randi()%10) * 60
	
	while !stateStack.empty():
		
		var transition = stateStack.pop_front()
		var state = STM[transition]
		var maxInd = max_index(state)
		var maxVal = state[maxInd]
		var punishment = (BETA/2.0) * (maxVal * maxVal)
		
		state[maxInd] = maxVal - punishment
		
		var hasZero = -1
		for i in range(0, 3):
			if i == maxInd:
				continue
			elif state[i] == 0:
				hasZero = i
		
		if hasZero >= 0:
			punishment *= 2
		
		for i in range(0, 3):
			if i == maxInd or i == hasZero:
				continue
			else:
				state[i] += punishment/2.0
		
		STM[transition] = state
		
	prevPos = Vector2(-1, -1)

# Signal handler for rewarding AI's
# collective moves for a successful
# Ball hit
func _on_AI_Good_Boi(body):
	## This code isn't used anymore
	## so we pass instead of exec.
	## Left for historical purpose.
	pass
	# if not training just return
	if $"../".play != false:
		return
	
	## make sure we collided with Ball
	if !body.is_in_group("ball"):
		return
	
	get_parent().hits += 1.0
	print("I'm Learning", stateStack.size())
	
	while !stateStack.empty():
		var transition = stateStack.pop_front()
		var state = STM[transition]
		var maxInd = max_index(state)
		var maxVal = state[maxInd]
		var reward = BETA * (1 - maxVal) * (1 - maxVal)
		
		state[maxInd] = maxVal + reward
		
		var hasZero = -1
		for i in range(0, 3):
			if i == maxInd:
				continue
			elif state[i] == 0:
				hasZero = i
		
		if hasZero >= 0:
			reward *= 2
		
		for i in range(0, 3):
			if i == maxInd or i == hasZero:
				continue
			else:
				state[i] -= reward/2.0
		
		STM[transition] = state
		
