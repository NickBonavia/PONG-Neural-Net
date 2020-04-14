extends KinematicBody2D

signal Moved_Tile(indices)

# Declare member variables here. Examples:
export (float) var speed = 100
export (int) var degrees = 30
onready var theta = randAngle()
onready var velocity = Vector2((1 - 2*(randi()%2)) * speed, 10)
onready var rotVeloc = rotateVec2(velocity)
onready var locIndex = Vector2(int(self.position.x/60), int(self.position.y/60))
onready var prevSect = locIndex.x 

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Generates a random angle within a range
func randAngle() ->float:
	return (1 - 2*(randi()%2)) * (randi()%degrees)*(PI/180)

# Apply a 2D rotation transform a Vector2
func rotateVec2(vec : Vector2) -> Vector2:
	return Vector2(vec.x*cos(theta) - vec.y*sin(theta), vec.x*sin(theta) + vec.y*cos(theta))

# Resets Ball to original position
func resetBall():
	self.position = Vector2(300, 300)
	theta = randAngle()
	rotVeloc = rotateVec2(velocity)

# Calculate Ball physics and update
func _physics_process(delta):
	var collision = move_and_collide(rotVeloc * delta)
	if collision:
		rotVeloc = rotVeloc.bounce(collision.normal)
		
		if collision.collider.has_method("hit"):
			collision.collider.hit()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var tmp = Vector2(0, 0)
	tmp.x = round(self.position.x/60)
	tmp.y = round(self.position.y/60)
	
	# If position has changed, emit signal for AI_Player
	if (tmp.x != locIndex.x) || (tmp.y != locIndex.y):
		if tmp.x != prevSect:
			prevSect = tmp.x
			emit_signal("Moved_Tile", tmp)
		locIndex = tmp