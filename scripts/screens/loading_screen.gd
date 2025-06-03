class_name LoadingScreen
extends Control

const muestras:= 30
const min_fPS:=50
const max_process:=20
const max_fis_ms:=10
const max_rend_ms:=10

var buffer_fps: Array = []
var sum_fps: float = 0.0
var buffer_process: Array = []
var sum_process: float = 0.0
var buffer_fis: Array = []
var sum_fis: float = 0.0
var buffer_rend: Array = []
var sum_rend: float = 0.0

const path_world_scene:="res://scenes/world.tscn"
var world_resource: PackedScene = null
var resource_loaded: bool = false

var temporary_world: Node = null
var scene_verification: bool = false
