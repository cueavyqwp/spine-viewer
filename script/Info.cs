using Godot;

public partial class Info : Label
{
	private Camera _camera;
	private bool _cameraLocked;

	public override void _Ready()
	{
		_camera = GetTree().GetRoot().GetCamera2D() as Camera;

		if (_camera != null)
		{
			_cameraLocked = _camera.IsLock;
			_camera.LockStateChanged += OnCameraLockChanged;
		}
	}

	private void OnCameraLockChanged(bool locked)
	{
		_cameraLocked = locked;
	}

	public override void _Process(double delta)
	{
		if (_camera == null)
			return;

		Text = Tr("Info")
			.Replace("${pos}", _camera.Position.ToString("0.##")
				+ (_cameraLocked ? Tr("CameraLock") : ""))
			.Replace("${zoom}", _camera.Zoom.X.ToString("0.##"))
			.Replace("${fps}", Engine.GetFramesPerSecond().ToString());
	}
}
