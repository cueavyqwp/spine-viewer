using Godot;
using System;
using System.Collections.Generic;
using System.IO;
using System.Text.Json;
using static TrackId;

public partial class Sprite : SpineSprite
{
	public Node SpriteLoader;
	[Export]
	public OptionButton OptionAnimation;
	[Export]
	public CheckButton IdleButton;
	[Export]
	public CheckButton LoopButton;
	[Export]
	public AudioStreamPlayer BGMPlayer;
	[Export]
	public AudioStreamPlayer TalkPlayer;
	public double LastIdleR;
	Dictionary<string, string> OptionDict = [];
	public bool IsLobbyTable = true;
	public string DirPath = null;
	public void OnFilesDropped(string[] files)
	{
		ColorAdjustFile adjustment = null;
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
				try
				{
					adjustment = JsonSerializer.Deserialize(File.ReadAllText(adjustments), ColorAdjustFileType.Default.ColorAdjustFile);
					GD.Print($"ColorAdjustments: {adjustments}");
				}
				catch (Exception error)
				{
					GD.Print($"Error during reading file: {error}\nFailed to read the file: {adjustments}");
					return;
				}
			}
		}
		else
		{
			GD.Print($"Dir not found: {path}");
			return;
		}
		GD.Print($"OK: {skel}\n");
		DirPath = path;
		Load(skel, atlas, adjustment);
	}
	public void UpDateLastIdleR() => LastIdleR = LastIdleR == -1 ? -1 : Time.GetUnixTimeFromSystem();
	public void Load(string skel, string atlas, ColorAdjustFile adjustment = null)
	{
		SpriteLoader.Call("load", this, skel, atlas);
		if (HasAnimation("Idle_01_R"))
		{
			LastIdleR = Time.GetUnixTimeFromSystem();
		}
		else
		{
			LastIdleR = -1;
		}
		// TODO: ColorAdjustments
	}
	public void UnLoad()
	{
		SkeletonDataRes = null;
		LastIdleR = -1;
		DirPath = null;
	}
	public void Init()
	{
		GD.Print("See as: ", IsLobby ? "Lobby" : "Basic");
		UpdateOption();
		TryIdle();
	}
	public SpineAnimationState AnimationState => GetAnimationState();
	public SpineSkeleton Skeleton => GetSkeleton();
	public Godot.Collections.Array<SpineAnimation> Animations => IsLoad ? new(SkeletonDataRes.GetAnimations()) : new();
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
		SkeletonDataRes = null;
		SpriteLoader = GetNode<Node>("/root/SpriteLoader");
		GetTree().Root.FilesDropped += OnFilesDropped;
	}
	public void TryIdle()
	{
		if (HasAnimation("Idle_01"))
		{
			AnimationState.SetAnimation("Idle_01", trackId: (int)Idle);
		}
	}
	public void Reset()
	{
		UpDateLastIdleR();
		AnimationState?.ClearTracks();
		Skeleton?.SetToSetupPose();
	}
	public void UpdateOption()
	{
		OptionAnimation.Clear();
		OptionDict.Clear();
		foreach (var name in AnimationNames)
		{
			string value;
			if (name.Contains("_A"))
			{
				value = name.Replace("_A", "");
			}
			else if (name.Contains("_M") && AnimationNames.Contains(name.Replace("_M", "_A")))
			{
				continue;
			}
			else
			{
				value = name;
			}
			OptionDict.Add(value, name);
			OptionAnimation.AddItem(value);
		}
	}
	public void TabChanged(int Tab)
	{
		switch (Tab)
		{
			case 0:
				{
					GD.Print("Table: Lobby");
					IsLobbyTable = true;
					Reset();
					TryIdle();
					return;
				}
			case 1:
				{
					GD.Print("Table: Animation");
					IsLobbyTable = false;
					UpdateOption();
					var index = OptionAnimation.GetSelectedId();
					if (index != -1)
					{
						ItemSelected(index);
					}
					return;
				}
		}
	}
	public void ItemSelected(int index)
	{
		if (IsLobbyTable)
		{
			return;
		}
		var name = OptionDict[OptionAnimation.GetItemText(index)];
		var loop = LoopButton.ButtonPressed;
		Reset();
		if (IdleButton.ButtonPressed && name != "Idle_01" && name != "Start_Idle_01" && name != "Dummy" && HasAnimation("Idle_01"))
		{
			AnimationState.SetAnimation("Idle_01", loop, (int)Idle);
		}
		AnimationState.SetAnimation(name, loop, (int)General0);
		if (name.Contains("_A"))
		{
			AnimationState.SetAnimation(name.Replace("_A", "_M"), loop, (int)General1);
		}
	}
	public override void _Process(double delta)
	{
		if (IsLobby && LastIdleR > 0 && Time.GetUnixTimeFromSystem() - LastIdleR > 20)
		{
			AnimationState.SetAnimation("Idle_01_R", false, (int)IdleR);
		}
	}
}
