extends Node

func Load(sprite: SpineSprite, skel: String, atlas: String):
	var data = SpineSkeletonDataResource.new()
	var skel_res = SpineSkeletonFileResource.new()
	var atlas_res = SpineAtlasResource.new()
	skel_res.load_from_file(skel)
	atlas_res.load_from_atlas_file(atlas)
	data.skeleton_file_res = skel_res
	data.atlas_res = atlas_res
	sprite.skeleton_data_res = data
