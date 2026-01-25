using Godot;

public partial class Loader : Node2D
{
	TabContainer Table;
	public override void _Ready()
	{
		Table = GetNode<TabContainer>("");
		GetTree().Root.FilesDropped += (files) =>
		{
			GD.Print(files);
		};
	}
}
