using Godot;

public partial class L18n : OptionButton
{
	[Export]
	private bool isFirst = true;
	public void Update()
	{
		if (isFirst)
		{
			return;
		}
	}
	public void OnChanged(int index)
	{
		var locale = GetItemText(index).Split(" : ")[0];
		GD.Print($"Change locale to {locale}");
		TranslationServer.SetLocale(locale);
		Update();
	}

	public override void _Ready()
	{
		var index = 0;
		foreach (var locale in TranslationServer.GetLoadedLocales())
		{
			var name = TranslationServer.GetTranslationObject(locale).GetMessage("LanguageName");
			AddItem($"{locale} : {name}");
			if (Tr("LanguageName") == name)
			{
				Select(index);
			}
			index++;
		}
		Update();
		isFirst = false;
	}
}
