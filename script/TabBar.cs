using Godot;

public partial class TabBar : TabContainer
{
	public override void _Ready()
	{
		for (int index = 0; index < GetTabCount(); index++)
		{
			SetTabTitle(index, Tr(GetTabTitle(index)));
		}
	}
}
