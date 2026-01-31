using System.Text.Json.Serialization;

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
