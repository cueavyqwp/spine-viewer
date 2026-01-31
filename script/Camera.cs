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

	[Export] public float AngleSpeedNormal = float.Pi / 180f * 5f;
	[Export] public float AngleSpeedFast = float.Pi / 180f * 10f;
	[Export] public float AngleSpeedSlow = float.Pi / 180f * 1f;

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
	private int _angleDeg;
	private bool _dragging;
	private Vector2 _lastWorldMousePos;

	/* ================= Lifecycle ================= */

	public override void _Ready()
	{
		_targetZoom = Zoom.X;
		_angleDeg = Mathf.RoundToInt(Mathf.RadToDeg(Rotation));
	}

	/* ================= Input ================= */

	public override void _Input(InputEvent @event)
	{
		HandleToggleInput();
		HandleWheelInput(@event);
		HandleDragInput(@event);
	}

	private void HandleToggleInput()
	{
		if (Input.IsActionJustPressed("Tab"))
			IsLock = !IsLock;

		if (Input.IsActionJustPressed("Home"))
			Position = Vector2.Zero;
	}

	private void HandleWheelInput(InputEvent @event)
	{
		if (@event is not InputEventMouseButton mouseButton || !mouseButton.Pressed)
			return;

		bool altPressed = Input.IsKeyPressed(Key.Alt);

		// ===== 按住 Alt 则调整旋转角度 =====
		if (altPressed)
		{
			int step = Mathf.RoundToInt(Mathf.RadToDeg(GetAngleSpeedFactor()));

			if (mouseButton.ButtonIndex == MouseButton.WheelUp)
				_angleDeg -= step;
			else if (mouseButton.ButtonIndex == MouseButton.WheelDown)
				_angleDeg += step;

			// === 自动取余（0 ~ 359）===
			_angleDeg = ((_angleDeg % 360) + 360) % 360;

			// 转回弧度给 Camera2D
			Rotation = Mathf.DegToRad(_angleDeg);
			return;
		}

		// ===== 普通缩放逻辑不变 =====
		if (mouseButton.ButtonIndex == MouseButton.WheelUp)
			_targetZoom *= Mathf.Exp(ZoomSpeed * GetSpeedFactor());
		else if (mouseButton.ButtonIndex == MouseButton.WheelDown)
			_targetZoom *= Mathf.Exp(-ZoomSpeed * GetSpeedFactor());

		_targetZoom = Mathf.Clamp(_targetZoom, ZoomMin, ZoomMax);
	}

	private void HandleDragInput(InputEvent @event)
	{
		if (IsLock)
		{
			_dragging = false;
			return;
		}

		switch (@event)
		{
			case InputEventMouseButton mouseButton when mouseButton.ButtonIndex == MouseButton.Right:
				_dragging = mouseButton.Pressed;
				if (_dragging)
					_lastWorldMousePos = GetGlobalMousePosition();
				break;

			case InputEventMouseMotion when _dragging:
				DragCamera();
				break;

			case InputEventScreenTouch touch when touch.Index == 0:
				_dragging = touch.Pressed;
				if (_dragging)
					_lastWorldMousePos = GetGlobalMousePosition();
				break;

			case InputEventScreenDrag drag when drag.Index == 0 && _dragging:
				DragCamera();
				break;
		}
	}

	private void DragCamera()
	{
		Vector2 currentWorldMousePos = GetGlobalMousePosition();
		Vector2 delta = currentWorldMousePos - _lastWorldMousePos;

		Position -= delta;
	}

	/* ================= Update ================= */

	public override void _Process(double delta)
	{
		if (!IsLock && !_dragging)
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

		Position += dir.Normalized() * GetSpeedFactor() * delta * 100f;
	}

	private void SmoothZoom(float delta)
	{
		float weight = 1f - Mathf.Exp(-8f * delta);
		Vector2 target = Vector2.One * _targetZoom;
		Zoom = Zoom.Lerp(target, weight);
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
	private float GetAngleSpeedFactor()
	{
		float factor = AngleSpeedNormal;

		if (Input.IsActionPressed("Shift"))
			factor = AngleSpeedSlow;

		if (Input.IsActionPressed("Ctrl"))
			factor = AngleSpeedFast;

		return factor;
	}
}
