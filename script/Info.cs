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

		Text = string.Format(
			Tr("Info"),
			_camera.Position.ToString("0.##") + (_cameraLocked ? Tr("CameraLock") : ""),
			Mathf.RoundToInt(Mathf.RadToDeg(_camera.Rotation)),
			_camera.Zoom.X.ToString("0.##"),
			Engine.GetFramesPerSecond()
		);

	}
}
