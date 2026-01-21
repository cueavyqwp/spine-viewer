using Godot;

public partial class Camera : Camera2D
{

	[Signal]
	public delegate void LockStateChangedEventHandler(bool isLocked);
	private bool _isLock;

	/* ================= Export ================= */

	[Export] public float SpeedNormal = 1.0f;
	[Export] public float SpeedFast = 2.0f;
	[Export] public float SpeedSlow = 0.5f;

	[Export] public float ZoomSpeed = 0.05f;
	[Export] public float ZoomMin = 0.1f;
	[Export] public float ZoomMax = 5.0f;

	[Export]
	public bool IsLock
	{
		get => _isLock;
		set
		{
			if (_isLock == value)
				return;

			_isLock = value;
			EmitSignal(SignalName.LockStateChanged, _isLock);
		}
	}

	/* ================= State ================= */

	private float _speedFactor;
	private float _targetZoom;

	private bool _dragging;
	private Vector2 _lastPointerPos;

	/* ================= Lifecycle ================= */

	public override void _Ready()
	{
		_targetZoom = Zoom.X;
	}

	/* ================= Input ================= */

	public override void _Input(InputEvent e)
	{
		HandleToggleInput();
		HandleZoomInput(e);
		HandleDragInput(e);
	}

	private void HandleToggleInput()
	{
		if (Input.IsActionJustPressed("Tab"))
			IsLock = !IsLock;

		if (Input.IsActionJustPressed("Home"))
			Position = Vector2.Zero;
	}

	private void HandleZoomInput(InputEvent e)
	{
		if (e is not InputEventMouseButton mb || !mb.Pressed)
			return;

		if (mb.ButtonIndex == MouseButton.WheelUp)
			_targetZoom *= Mathf.Exp(ZoomSpeed * GetSpeedFactor());
		else if (mb.ButtonIndex == MouseButton.WheelDown)
			_targetZoom *= Mathf.Exp(-ZoomSpeed * GetSpeedFactor());

		_targetZoom = Mathf.Clamp(_targetZoom, ZoomMin, ZoomMax);
	}

	private void HandleDragInput(InputEvent e)
	{
		if (IsLock)
		{
			_dragging = false;
			return;
		}

		switch (e)
		{
			case InputEventMouseButton mb when mb.ButtonIndex == MouseButton.Right:
				_dragging = mb.Pressed;
				_lastPointerPos = mb.Position;
				break;

			case InputEventMouseMotion mm when _dragging:
				DragCamera(mm.Position);
				break;

			case InputEventScreenTouch touch when touch.Index == 0:
				_dragging = touch.Pressed;
				_lastPointerPos = touch.Position;
				break;

			case InputEventScreenDrag drag when drag.Index == 0 && _dragging:
				DragCamera(drag.Position);
				break;
		}
	}

	private void DragCamera(Vector2 currentPos)
	{
		Vector2 delta = currentPos - _lastPointerPos;
		Position -= delta / Zoom;
		_lastPointerPos = currentPos;
	}

	/* ================= Update ================= */

	public override void _Process(double delta)
	{
		if (!IsLock)
			HandleKeyboardMove((float)delta);

		SmoothZoom((float)delta);
	}

	private void HandleKeyboardMove(float delta)
	{
		Vector2 dir = Vector2.Zero;
		dir.X = Input.GetActionStrength("Right") - Input.GetActionStrength("Left");
		dir.Y = Input.GetActionStrength("Down") - Input.GetActionStrength("Up");

		if (dir == Vector2.Zero)
			return;

		Position += dir.Normalized() * GetSpeedFactor();
	}

	private void SmoothZoom(float delta)
	{
		float t = 1f - Mathf.Exp(-8f * delta);
		Vector2 target = Vector2.One * _targetZoom;
		Zoom = Zoom.Lerp(target, t);
	}

	/* ================= Helpers ================= */

	private float GetSpeedFactor()
	{
		float factor = SpeedNormal;

		if (Input.IsActionPressed("Shift"))
			factor *= SpeedSlow;

		if (Input.IsActionPressed("Ctrl"))
			factor *= SpeedFast;

		return factor;
	}
}
