using System;
using Godot;

public partial class Main : Node2D
{
	[Export]
	bool ShowHUD = true;
	bool Lock = false;
	Control UI;
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
		UI = GetNode<Control>("CanvasLayer/UI");
		GetViewport().SizeChanged += () =>
		{
			if (Lock)
			{
				return;
			}
			Lock = true;
			Vector2 Size = DisplayServer.ScreenGetSize();
			Vector2 Scale = new()
			{
				X = Size.X / (float)ProjectSettings.GetSetting("display/window/size/viewport_width"),
				Y = Size.Y / (float)ProjectSettings.GetSetting("display/window/size/viewport_height")
			};
			GetTree().Root.ContentScaleFactor = Math.Min(Scale.X, Scale.Y);
			Lock = false;
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
