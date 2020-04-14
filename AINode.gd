extends Node

enum Move {UP, STAY, DOWN}

class MyNode extends Object:
## Child nodes/ choices
	var up = null
	var stay = null
	var down = null

	var value = -100.0
	var endLoc = -1
	var comp = 10000

	func _init(ply : int, move : int, pVal : int, ballY : int):
		endLoc = pVal
		if ply > 0:
			
			self.up = MyNode.new(ply-1, Move.UP, pVal-1, ballY)
			comp = self.up.value
			
			if pow(ballY - pVal, 2) < comp:
				self.stay = MyNode.new(ply-1, Move.STAY, pVal, ballY)
				comp = self.stay.value
			if pow(ballY - (pVal + 1), 2) < comp:
				self.down = MyNode.new(ply-1, Move.DOWN, pVal+1, ballY)
				comp = self.down.value
				
			var upI = 1000 if self.up == null else self.up.value
			var stayI = 1000 if self.stay == null else self.stay.value
			var downI = 1000 if self.down == null else self.down.value
				
			if upI < min(stayI, downI):
				self.endLoc = self.endLoc -1
				self.value = upI
			elif stayI < min(upI, downI):
				self.endLoc = self.endLoc
				self.value = stayI
			else:
				self.endLoc = self.endLoc + 1
				self.value = downI
		else:
			self.value = pow(ballY - pVal, 2)