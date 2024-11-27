extends Node3D

# 顔、髪、目、口のパーツリスト
@export var face_list: Array[String] = [
	"res://CharacterMaker3D/models/face/face_1.glb",
	"res://CharacterMaker3D/models/face/face_2.glb",
	"res://CharacterMaker3D/models/face/face_3.glb"
]
@export var hair_list: Array[String] = [
	"res://CharacterMaker3D/models/hair/hair_1.glb",
	"res://CharacterMaker3D/models/hair/hair_2.glb",
	"res://CharacterMaker3D/models/hair/hair_3.glb"
]
@export var eyes_list: Array[String] = [
	"res://CharacterMaker3D/models/eyes/eyes_1/eyes_1.fbx",
	"res://CharacterMaker3D/models/eyes/eyes_2/eyes_2.glb",
	"res://CharacterMaker3D/models/eyes/eyes_2/eyes_2.glb"
]
@export var mouth_list: Array[String] = [
	"res://CharacterMaker3D/models/mouth/mouth_1.obj",
	"res://CharacterMaker3D/models/mouth/mouth_2.obj"
]

# 現在の選択インデックス
var face_idx: int = 0	# 顔インデックス
var hair_idx: int = 0	# 髪インデックス
var eyes_idx: int = 0	# 目インデックス
var mouth_idx: int = 0	# 口インデックス

# パーツノードへの参照
@onready var face_node: Node3D = $Character/Face
@onready var hair_node: Node3D = $Character/Hair
@onready var eyes_node: Node3D = $Character/Eyes
@onready var mouth_node: Node3D = $Character/Mouth

func _ready():
	# 初期パーツを読み込み
	_update_character()
	
# 顔パーツを変更
func _on_face_letf_prossed():
	face_idx = (face_idx - 1 + face_list.size()) % face_list.size()
	_update_character()

func _on_face_right_pressed():
	face_idx = (face_idx + 1) % face_list.size()
	_update_character()

# 髪パーツを変更
func _on_hair_left_pressed():
	hair_idx = (hair_idx - 1 + hair_list.size()) % hair_list.size()
	_update_character()

func _on_hair_right_pressed():
	hair_idx = (hair_idx + 1) % hair_list.size()
	_update_character()

# 目パーツを変更
func _on_eyes_left_pressed():
	eyes_idx = (eyes_idx - 1 + eyes_list.size()) % eyes_list.size()
	_update_character()

func _on_eyes_right_pressed():
	eyes_idx = (eyes_idx + 1) % eyes_list.size()
	_update_character()

# 口パーツを変更
func _on_mouth_left_pressed():
	mouth_idx = (mouth_idx - 1 + mouth_list.size()) % mouth_list.size()
	_update_character()

func _on_mouth_right_pressed():
	mouth_idx = (mouth_idx + 1) % mouth_list.size()
	_update_character()

# キャラクターのパーツを更新
func _update_character():
	_load_mesh(face_node, face_list[face_idx])
	# 髪パーツを更新
	_load_mesh(hair_node, hair_list[hair_idx])
	# 目パーツを更新
	_load_mesh(eyes_node, eyes_list[eyes_idx])
	# 口パーツを更新
	_load_mesh(mouth_node, mouth_list[mouth_idx])

# 指定ノードに新しいMeshInstance3Dをロード
func _load_mesh(parent_node: Node3D, mesh_path: String):
	# 子ノードをクリア
	for child in parent_node.get_children():
		child.queue_free()

	# ファイルをロード
	var resource = load(mesh_path)

	# リソースの種類に応じて処理を分岐
	if resource is PackedScene:
		# PackedSceneの場合、インスタンス化してノードに追加
		var new_instance = resource.instantiate()
		parent_node.add_child(new_instance)
	elif resource is ArrayMesh:
		# ArrayMeshの場合、MeshInstance3Dとしてノードに追加
		var new_mesh_instance = MeshInstance3D.new()
		new_mesh_instance.mesh = resource
		parent_node.add_child(new_mesh_instance)
	else:
		# サポート外の形式の場合、エラーを出力
		push_error("Unsupported resource type: " + mesh_path)

