extends Line2D
class_name GrapplingRope 

#Tutorial_GrapplingGun grapplingGun;
@export var grapplingGun : PlayerHook = null
@export var percision : int = 40;
@export_range(0,25) var straightenLineSpeed : float = 0.5
@export_range(0.01,4) var StartWaveSize : float = 2
@export_range(0.01,5) var ropeProgressionSpeed : float = 1
@export var isGrappling : bool = true

@export var linePath : Path2D = null
var m_lineRenderer : Line2D = self
var waveSize : float = 0
var strightLine : bool = false;
var Dest : Vector2 = global_position + Vector2(100,0)
var rope_shot : bool = false

func _ready():
	LinePointsToFirePoint()
	waveSize = StartWaveSize;

func ShootRope(hook_target : Vector2):
	rope_shot = true
	LinePointsToFirePoint()
	strightLine = false;
	waveSize = StartWaveSize
	m_lineRenderer.visible = true;
	
	var delta_pos : Vector2 = hook_target - global_position
	Dest = Vector2(delta_pos.length(),0)
	global_rotation = delta_pos.angle()	

func HideRope():
	m_lineRenderer.visible = false;
	isGrappling = false;

func LinePointsToFirePoint():
	m_lineRenderer.clear_points()
	for i in range(0,percision+1):
		m_lineRenderer.add_point(Vector2(0,0));

func _process(delta):
	if not rope_shot:
		return
	DrawRope(delta)
	
func DrawRope(delta):
	if (!strightLine):
		#Rope reached the hook target???
		var last_point_pos = m_lineRenderer.get_point_position(percision)
		if abs(last_point_pos.x - Dest.x) < 10:
			strightLine = true;
		else:
			DrawRopeWaves();
	else:
		#if (!isGrappling):
			##grapplingGun.Grapple();
			#isGrappling = true;
		if (waveSize > 0):
			waveSize = clampf(waveSize - (delta * straightenLineSpeed), 0, StartWaveSize)
		else:
			#rope_shot=false
			waveSize = 0;
		DrawRopeWaves();
			#if (m_lineRenderer.positionCount != 2):
				#m_lineRenderer.positionCount = 2
			#DrawRopeNoWaves();

func DrawRopeWaves():
	var back_length = linePath.curve.get_baked_length()
	for vertexIndex in range(0,percision+1):
		var curve_local_offset = back_length * (vertexIndex as float/percision as float)
		var pos_inside_curve = linePath.curve.sample_baked(curve_local_offset) / 100 #X in range [0,100] Y in range [-100,100]
		var height = pos_inside_curve.y * waveSize
		var point_world_pos = pos_inside_curve * Dest.length()
		height = point_world_pos.y * waveSize
		#point_world_pos.y=0
		
		var pointCount = m_lineRenderer.get_point_count()
		var originalPos = m_lineRenderer.get_point_position(vertexIndex)
		var modifiedPos = originalPos.lerp(point_world_pos, ropeProgressionSpeed)
		modifiedPos.y = height
		m_lineRenderer.set_point_position(vertexIndex, modifiedPos)

func DrawRopeNoWaves():
	pass
	#m_lineRenderer.SetPosition(0, grapplingGun.firePoint.position);
	#m_lineRenderer.SetPosition(1, grapplingGun.hook_target);

