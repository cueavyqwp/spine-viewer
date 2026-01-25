using Godot;

public partial class FileSelect : FileDialog
{
	public override void _Ready()
	{
		CancelButtonText = Tr("FileDialogCancel");
	}
	public void ShowDialog(FileModeEnum mode = FileModeEnum.OpenAny, string filter = null, string root = "")
	{
		FileMode = mode;
		FileNameFilter = filter;
		RootSubfolder = root;
		OkButtonText = Tr($"FileDialogOK{(int)mode}");
		Title = Tr($"FileDialogTitle{(int)mode}");
		Show();
	}
}
