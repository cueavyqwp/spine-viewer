using Godot;
using AssetsTools.NET;
using AssetsTools.NET.Extra;
using System.IO;
using MemoryPack;
using System.Data.Common;
using System.IO.Hashing;
using ICSharpCode.SharpZipLib.Zip;
using ICSharpCode.SharpZipLib.Core;
using System.Collections.Generic;

public partial class FileLoader : Control
{
    [Export]
    public OptionButton Option;
    [Export]
    public AudioStreamPlayer ASP;

    public string GamePath;
    public Dictionary<string, string> AudioMapping;

    void OnTextChanged(string Text)
    {
        if (!Directory.Exists(Text) || !File.Exists(Path.Combine(Text, "BlueArchive.exe")) || !Directory.Exists(Path.Combine(Text, "BlueArchive_Data")))
            return;
        GamePath = Text;
        GD.Print($"[FileLoader] Game dir: {Text}");
        var Catalog = LoadMediaCatalog(GamePath);
        if (Catalog is null)
        {
            GD.Print($"[FileLoader] Cannot read MediaCatalog");
            return;
        }
        Option.Clear();
        AudioMapping = LoadAudioMapping(Catalog);
        foreach (var item in AudioMapping)
        {
            Option.AddItem(item.Key);
        }
    }

    MediaCatalog LoadMediaCatalog(string FilePath = null)
    {
        if (FilePath is null)
        {
            if (GamePath is null)
            {
                GD.Print($"[FileLoader] Game dir not found");
                return null;
            }
            else
            {
                FilePath = GamePath;
            }
        }
        MediaCatalog Catalog = MemoryPackSerializer.Deserialize<MediaCatalog>(File.ReadAllBytes(Path.Combine(FilePath, "BlueArchive_Data", "StreamingAssets", "MediaPatch", "Catalog", "MediaCatalog.bytes")));
        return Catalog;
    }
    Dictionary<string, string> LoadAudioMapping(MediaCatalog Catalog)
    {
        Dictionary<string, string> map = [];
        foreach (var item in Catalog.Table)
        {
            if (!item.Key.Contains("voc_jp") || !item.Value.FileName.Contains(".zip"))
                continue;
            var path = Path.Combine(GamePath, "BlueArchive_Data", "StreamingAssets", "MediaPatch", $"{XxHash64.HashToUInt64(item.Value.FileName.ToUtf8Buffer())}_{item.Value.Crc}");
            map[item.Value.FileName.GetBaseName().ToLower()] = path;
        }
        return map;
    }
    void OnItemSelected(int index)
    {
        var name = Option.GetItemText(index);
        string path;
        AudioMapping.TryGetValue(name, out path);
        var zf = new ZipFile(File.OpenRead(path))
        {
            Password = Crypto.GetZipPassWord(name + ".zip")
        };
        foreach (ZipEntry ze in zf)
        {
            if (ze.IsDirectory)
                continue;
            var zs = zf.GetInputStream(ze);
            var ms = new MemoryStream();
            zs.CopyTo(ms);
            AudioStreamOggVorbis ogg = AudioStreamOggVorbis.LoadFromBuffer(ms.ToArray());
            ASP.Stream = ogg;
            ASP.Play();
            break;
        }
    }
}