class_name LoadingScreen
extends Control

const muestras:= 30
const min_fPS:=50
const max_process:=5
const max_phys:=5
const max_rend:=5

var buffer_fps: Array = []
var sum_fps: float = 0.0
var buffer_process: Array = []
var sum_process: float = 0.0
var buffer_phys: Array = []
var sum_phys: float = 0.0
var buffer_rend: Array = []
var sum_rend: float = 0.0

const path_world_scene:="res://scenes/world.tscn"
var world_resource: PackedScene = null
var resource_loaded: bool = false

var temporary_world: Node = null
var scene_verification: bool = false

func _ready():
	var viewport_rid = get_viewport().get_viewport_rid()
	RenderingServer.viewport_set_measure_render_time(viewport_rid, true)
	
	ResourceLoader.load_threaded_request(self.path_world_scene)
	set_process(true)

func _process(_delta):
	if not self.resource_loaded:
		var state = ResourceLoader.load_threaded_get(self.path_world_scene)
		if state == null:
			print("Error linea 37")
			return
		if state is PackedScene:
			self.world_resource = state
			self.resource_loaded = true
			self._instantiate_temporary_scene()
			self._validate_loaded_scene()
		else:
			print("Error entrando al mundo")
			get_tree().change_scene_to_file("res://scenes/save_menu.tscn")
			return
		return
	
	if not self.scene_verification:
		self._validate_loaded_scene()
		return
	
	self._measure_metrics()
	if self.buffer_fps.size() < self.muestras:
		return
	
	var avg_fps = self.sum_fps/self.muestras
	var avg_process = self.sum_process/self.muestras
	var avg_phys = self.sum_phys/self.muestras
	var avg_rend = self.sum_rend/self.muestras
	
	if avg_fps > self.min_fPS \
	and avg_process < self.max_process \
	and avg_phys < self.max_phys \
	and avg_rend < self.max_rend:
		set_process(false)
		if self.temporary_world and self.temporary_world.is_inside_tree():
			self.temporary_world.queue_free()
		get_tree().change_scene_to_file(self.path_world_scene)

func _instantiate_temporary_scene():
	if self.world_resource == null:
		return
	self.temporary_world = self.world_resource.instantiate()
	$OffScreenViewport.add_child(self.temporary_world)

func _validate_loaded_scene():
	if self.temporary_world == null:
		return
	if not self.temporary_world.is_inside_tree():
		return
	self.scene_verification = true
	self.temporary_world.queue_free()
	self.temporary_world = null
	self._clean_buffers()

func _measure_metrics():
	var current_fps: float = Engine.get_frames_per_second()
	var current_process_us: float = Performance.get_monitor(Performance.TIME_PROCESS)
	var current_phys_us: float = Performance.get_monitor(Performance.TIME_PHYSICS_PROCESS)
	
	var offscreen_rid = $OffScreenViewport.get_viewport_rid()
	var render_cpu_us = RenderingServer.viewport_get_measured_render_time_cpu(offscreen_rid)
	var frame_setup_us = RenderingServer.get_frame_setup_time_cpu()
	var total_render_time_us = render_cpu_us + frame_setup_us
	
	var current_process_ms = current_process_us/1000.0
	var current_phys_ms = current_phys_us/1000.0
	var total_render_time_ms = total_render_time_us/1000.0
	
	self.buffer_fps.append(current_fps)
	self.sum_fps+=current_fps
	
	self.buffer_process.append(current_process_ms)
	self.sum_process+=current_process_ms
	
	self.buffer_phys.append(current_phys_ms)
	self.sum_phys+=current_phys_ms
	
	self.buffer_rend.append(total_render_time_ms)
	self.sum_rend+=total_render_time_ms
	
	if self.buffer_fps.size() > self.muestras:
		self.sum_fps-=buffer_fps.get(0)
		self.buffer_fps.remove_at(0)
		
		self.sum_process-=self.buffer_process.get(0)
		self.buffer_process.remove_at(0)
		
		self.sum_phys-=self.buffer_phys.get(0)
		self.buffer_phys.remove_at(0)
		
		self.sum_rend-=self.buffer_rend.get(0)
		self.buffer_rend.remove_at(0)

func _clean_buffers():
	self.sum_fps = 0; self.buffer_fps.clear()
	self.sum_process = 0; self.buffer_process.clear()
	self.sum_phys = 0; self.buffer_phys.clear()
	self.sum_rend = 0; self.buffer_rend.clear()
