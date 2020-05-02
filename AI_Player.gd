extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

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
	self.position.y = AINode.MyNode.new(4, -1, round(self.position.y/60), indices.y).endLoc * 60
	print(self.position.y)

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
