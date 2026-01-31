<div align = "center" >
    <h1>spine-viewer</h1>

[简体中文](/README.md) | English

**A Spine4 viewer based on Godot**

</div>

# About

WIP

Use for view `Memorial Lobby` and `Sprites` from Blue Archive

<details>

<summary>How to get Spine files</summary>

JP:
`Android/data/com.YostarJP.BlueArchive/files/AssetBundls`
`YostarGames/BlueArchive_JP/BlueArchive_Data/StreamingAssets/AssetBundles`

GL:
`Android/data/com.nexon.bluearchive/files/PUB/Resource/[Preload/GameData]/Android`
`steamapps/common/BlueArchive/BlueArchive_Data/StreamingAssets/PUB/Resource/[Preload/GameData]/Windows`

Searching `spine`

Start with `assets-_mx-spinelobbies` is Memorial Lobby

Start with `assets-_mx-spinecharacters` Sprites

`CH`+`****` is Characters

`NP`+`****` is NPCs

Copy them into a directory

Download [AssetStudioModCLI](https://github.com/aelurum/AssetStudio)

`AssetStudioModCLI.exe [Your directory] -r -g none -o [Output directory] --filter-by-text .skel,.atlas,.png,ColorAdjustments`

</details>

## Download

Go to the [Releases](https://github.com/cueavyqwp/spine-viewer/releases)

# TODO list

See at [README.md](/README.md#待办事项)

# Export

Go to [here](https://en.esotericsoftware.com/spine-godot#spine-godot-engine-module-downloads), download the `Godot 4.5.1 with C# support` and its Export templates

Unzip, then copy files from `godot-editor-windows-mono/GodotSharp/Tools/nupkgs` into `godot-nuget`

Install [.Net SDK](https://dotnet.microsoft.com/en-us/download)

Donload [unifont-17.0.03.otf](https://www.unifoundry.com/pub/unifont/unifont-17.0.03/font-builds/unifont-17.0.03.otf) font, rename to`unifont.otf` and put it in `assets` directory

Then you can learn how to export it from [Godot Engine documentation](https://docs.godotengine.org/en/stable/tutorials/export/)
