extends Line2D
class_name GrapplingRope 

@export var grapplingGun : PlayerHook = null
@export var NumRopeSegments : int = 40;
@export_range(0.01,5) var RopeBaseMovementSpeed : float = 1
@export_range(0.01,4) var WaveHeightMultiplier : float = 2
@export_range(0,25) var straightenLineSpeed : float = 0.5
@export var HookSound : AudioStreamPlayer2D = null

@onready var linePath : Path2D = $RopeVisualPath2
@onready var waveHeight : float = WaveHeightMultiplier
@onready var m_lineRenderer : Line2D = self

var rope_target : Vector2 = global_position + Vector2(100,0)
var hook_gun_target : Vector2 = Vector2(0,0)
var rope_shot : bool = false
var straightLine : bool = false
var isGrappling : bool = false
var ropeBakedLength : int = 0

var timeToHitTarget :float = 0.2
var shotTime : float = 0

func _ready():
	LinePointsToFirePoint()

func _process(delta):
	if not rope_shot:
		return
	shotTime = clampf(shotTime + delta, 0, timeToHitTarget)
	var delta_pos : Vector2 = hook_gun_target - global_position
	rope_target = Vector2(delta_pos.length(),0)
	DrawRope(delta)

func LinePointsToFirePoint():
	rope_shot=false
	hook_gun_target = Vector2(0,0)
	ropeBakedLength=0
	shotTime = 0
	m_lineRenderer.clear_points()
	for i in range(0,NumRopeSegments+1):
		m_lineRenderer.add_point(Vector2(0,0))
		
func ShootRope(hook_target : Vector2):
	LinePointsToFirePoint()
	#Get a random Curve2D to visualize the rope
	linePath= get_child(randi()%get_child_count()) as Path2D
	rope_shot = true
	straightLine = false;
	waveHeight = WaveHeightMultiplier
	
	hook_gun_target = hook_target
	var delta_pos : Vector2 = hook_target - global_position
	rope_target = Vector2(delta_pos.length(),0)
	global_rotation = delta_pos.angle()	

func HideRope():
	LinePointsToFirePoint()
	isGrappling = false;
	linePath=null
	
func DrawRope(delta):
	if (!straightLine):
		#Rope reached the hook target???
		if abs(m_lineRenderer.get_point_position(NumRopeSegments).x - rope_target.x) < 30:
			straightLine = true;
			#dHookSound.play()
		else:
			DrawRopeWaves();
	else:
		if (!isGrappling):
			grapplingGun.Launch();
			isGrappling = true;
		if (waveHeight > 0):
			waveHeight = clampf(waveHeight - (delta * straightenLineSpeed), 0, WaveHeightMultiplier)
			DrawRopeWaves()
		else:		
			if m_lineRenderer.get_point_count() != 2:
				m_lineRenderer.clear_points()
				m_lineRenderer.add_point(Vector2(0,0))
				m_lineRenderer.add_point(Vector2(0,0))
			DrawRopeNoWaves();

func DrawRopeWaves():
	var back_length = linePath.curve.get_baked_length()
	for vertexIndex in range(0,NumRopeSegments+1):
		#Get the position of the current vertex inside the curve2D and transform it to global coordinates
		var curve_local_offset = back_length * (vertexIndex as float/NumRopeSegments as float)
		var pos_inside_curve = linePath.curve.sample_baked(curve_local_offset) / linePath.curve.get_point_position(linePath.curve.point_count-1).x #X in range [0,100] Y in range [-100,100]
		var final_pos_in_local_coords = pos_inside_curve * rope_target.length()
		var current_pos_in_local_coords = ((final_pos_in_local_coords)*(shotTime/timeToHitTarget))
		#The height of the vertex is modified only when the rope has reached its target and starts straightening
		current_pos_in_local_coords.y = final_pos_in_local_coords.y * waveHeight
		m_lineRenderer.set_point_position(vertexIndex, current_pos_in_local_coords)

func DrawRopeNoWaves():
	m_lineRenderer.set_point_position(0, Vector2(0,0));
	m_lineRenderer.set_point_position(1, rope_target);
