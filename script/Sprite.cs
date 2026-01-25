using Godot;
using System;
using System.IO;

public partial class Sprite : SpineSprite
{
	public Node SpriteLoader;
	public void OnFilesDropped(string[] files)
	{
		string adjustments;
		string skel;
		string atlas;
		if (files.Length == 0)
		{
			return;
		}
		var path = files[0];
		if (!Path.Exists(path))
		{
			GD.Print($"File not found: {path}");
		}
		if (File.Exists(path))
		{
			path = Path.GetDirectoryName(path);
		}
		if (Directory.Exists(path))
		{
			files = Directory.GetFiles(path, "*.skel");
			if (files.Length == 0)
			{
				GD.Print($"File(*.skel) not found in: {path}");
				return;
			}
			skel = files[0];
			GD.Print($"Skel: {skel}");
			atlas = skel.Replace(".skel", ".atlas");
			if (File.Exists(atlas))
			{
				GD.Print($"Atlas: {atlas}");
				try
				{
					foreach (var line in File.ReadAllLines(atlas))
					{
						if (line.EndsWith(".png") && (!File.Exists(Path.Join(path, line))))
						{
							GD.Print($"Img not found: {line}");
							return;
						}
					}
				}
				catch (Exception error)
				{
					GD.Print($"Error during reading file: {error}\nFailed to read the file: {atlas}");
				}
			}
			else
			{
				GD.Print($"File({Path.GetFileName(atlas)}) not found in: {path}");
				return;
			}
			adjustments = Path.Join(path, "ColorAdjustments.json");
			if (File.Exists(adjustments))
			{
				GD.Print($"ColorAdjustments: {adjustments}");
			}
			else
			{
				adjustments = null;
			}
		}
		else
		{
			GD.Print($"Dir not found: {path}");
			return;
		}
		GD.Print($"OK: {skel}");
		Load(skel, atlas, adjustments);
	}
	public void Load(string skel, string atlas, string adjustments = null)
	{
		SpriteLoader.Call("Load", this, skel, atlas);
	}
	public override void _Ready()
	{
		SpriteLoader = GetNode<Node>("/root/SpriteLoader");
		GetTree().Root.FilesDropped += OnFilesDropped;
	}
	public override void _Process(double delta)
	{
	}
}
