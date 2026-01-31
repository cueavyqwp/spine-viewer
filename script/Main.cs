using System;
using Godot;

public partial class Main : Node2D
{
	[Export]
	bool ShowHUD = true;
	[Export]
	Control UI;
	public Vector2 BaseSize = new((float)ProjectSettings.GetSetting("display/window/size/viewport_width"), (float)ProjectSettings.GetSetting("display/window/size/viewport_height")
	);
	private Vector2 LastSize = Vector2.Zero;
	public void ChangeHUD()
	{
		ShowHUD = !ShowHUD;
		if (ShowHUD)
		{
			UI.Show();
		}
		else
		{
			UI.Hide();
		}
	}
	public override void _Ready()
	{
		GetViewport().SizeChanged += () =>
		{
			if (LastSize == DisplayServer.WindowGetSize())
			{
				return;
			}
			Vector2 Size = DisplayServer.WindowGetSize();
			LastSize = Size;
			Vector2 Scale = Size / BaseSize;
			GetTree().Root.ContentScaleFactor = Math.Min(Scale.X, Scale.Y);
		};
	}

	public override void _Notification(int what)
	{
		if (what == NotificationWMCloseRequest)
		{
			GetTree().Quit(0);
		}
	}
	public override void _Input(InputEvent @event)
	{
		if (Input.IsActionJustPressed("HUD"))
		{
			ChangeHUD();
		}
		if (Input.IsActionJustPressed("Fullscreen"))
		{
			if (DisplayServer.WindowGetMode() == DisplayServer.WindowMode.Fullscreen)
			{
				DisplayServer.WindowSetMode(DisplayServer.WindowMode.Windowed);
			}
			else
			{
				DisplayServer.WindowSetMode(DisplayServer.WindowMode.Fullscreen);
			}
		}
	}
}
