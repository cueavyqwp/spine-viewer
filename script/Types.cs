using System.Text.Json.Serialization;
using System.Collections.Generic;
using MemoryPack;

public class PostExposure
{
    public int m_OverrideState = 0;
    public float m_Value = 0;
}

public class Contrast
{
    public int m_OverrideState = 0;
    public float m_Value = 0;
}

public class RGBA
{
    public float r = 1;
    public float g = 1;
    public float b = 1;
    public float a = 1;
}

public class ColorFilter
{
    public int m_OverrideState = 0;
    public RGBA m_Value = new();
}

public class HueShift
{
    public int m_OverrideState = 0;
    public float m_Value = 0;
}

public class Saturation
{
    public int m_OverrideState = 0;
    public float m_Value = 0;
}

public class ColorAdjustFile
{
    public int m_Enabled = 0;
    public PostExposure postExposure = new();
    public Contrast contrast = new();
    public ColorFilter colorFilter = new();
    public HueShift hueShift = new();
    public Saturation saturation = new();
}

[JsonSourceGenerationOptions(IncludeFields = true)]
[JsonSerializable(typeof(ColorAdjustFile))]
public partial class ColorAdjustFileType : JsonSerializerContext { }

public enum MediaType : int
{
    None = 0,
    Audio = 1,
    Video = 2,
    Texture = 3
}

[MemoryPackable]
public partial class Media
{
    public required string Path { get; set; }
    public required string FileName { get; set; }
    public long Bytes { get; set; }
    public long Crc { get; set; }
    public bool IsPrologue { get; set; }
    public bool IsSplitDownload { get; set; }
    public MediaType MediaType { get; set; }
}

[MemoryPackable]
public partial class MediaCatalog
{
    public required Dictionary<string, Media> Table { get; set; }
}
[MemoryPackable]
public partial class TableBundle
{
    public required string Name { get; set; }
    public long Size { get; set; }
    public long Crc { get; set; }
    public bool isInbuild { get; set; }
    public bool isChanged { get; set; }
    public bool IsPrologue { get; set; }
    public bool IsSplitDownload { get; set; }
    public required List<string> Includes { get; set; }
}

public enum TrackId : int
{
    StartIdle,
    Idle,
    IdleR,
    General0,
    General1,
    General2,
    General3,
    TalkA,
    TalkM,
    LookA,
    LookM,
    PatA,
    PatM,
    PinchA,
    PinchM,
    General4,
    General5,
    General6,
    General7,
}

public enum TabId : int
{
    File,
    Lobby,
    Animation,
    Setting
}
