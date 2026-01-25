using Godot;
using System;
using System.Collections.Generic;
using System.IO;
using static TrackId;
public partial class Sprite : SpineSprite
{
	public Node SpriteLoader;
	public AudioStreamPlayer BGMPlayer;
	public AudioStreamPlayer TalkPlayer;
	public string DirPath = null;
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
						if (line.EndsWith(".png") && (!File.Exists(Path.Combine(path, line))))
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
			adjustments = Path.Combine(path, "ColorAdjustments.json");
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
		GD.Print($"OK: {skel}\n");
		DirPath = path;
		Load(skel, atlas, adjustments);
	}
	public void Load(string skel, string atlas, string adjustments = null)
	{
		SpriteLoader.Call("load", this, skel, atlas);
		// TODO: ColorAdjustments
	}
	public void UnLoad()
	{
		SkeletonDataRes = new();
		DirPath = null;
	}
	public void Init()
	{
		GD.Print("See as: ", IsLobby ? "Lobby" : "Basic");
		if (HasAnimation("Idle_01"))
		{
			GD.Print("Playing: Idle_01");
			AnimationState.SetAnimation("Idle_01", trackId: (int)Idle);
		}
	}
	public SpineAnimationState AnimationState => GetAnimationState();
	public Godot.Collections.Array<SpineAnimation> Animations => new(SkeletonDataRes.GetAnimations());
	public List<string> AnimationNames
	{
		get
		{
			List<string> AnimationNames = [];
			foreach (var animation in Animations)
			{
				AnimationNames.Add(animation.GetName());
			}
			return AnimationNames;
		}
	}
	public void OnEvent(SpineSprite sprite, SpineAnimationState state, SpineTrackEntry entry, SpineEvent @event)
	{
		if (DirPath is null || !Directory.Exists(DirPath) || !@event.GetData().GetEventName().StartsWith("sound/"))
		{
			return;
		}
		var path = Path.Combine(DirPath, "sound", @event.GetData().GetAudioPath().ToLower().Replace(".wav", ".ogg"));
		if (!File.Exists(path))
		{
			GD.Print($"Sound not found: {path}");
			return;
		}
		var data = File.ReadAllBytes(path);
		AudioStreamOggVorbis ogg = AudioStreamOggVorbis.LoadFromBuffer(data);
		TalkPlayer.Stream = ogg;
		TalkPlayer.Play();
	}
	public bool HasAnimation(string name) => AnimationNames.Contains(name);
	public bool IsLoad => SkeletonDataRes != null;
	public bool IsLobby => HasAnimation("Start_Idle_01");
	public override void _Ready()
	{
		SpriteLoader = GetNode<Node>("/root/SpriteLoader");
		BGMPlayer = GetNode<AudioStreamPlayer>("BGM");
		TalkPlayer = GetNode<AudioStreamPlayer>("Talk");
		GetTree().Root.FilesDropped += OnFilesDropped;
	}
	public override void _Process(double delta)
	{
	}
}
