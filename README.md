<div align = "center" >
    <h1>spine-viewer</h1>

**基于Godot的Spine4查看器**

</div>

# 关于

目前还在开发中

用于查看蔚蓝档案(Blue Archive)里的`记忆大厅`与`角色立绘`

<details>

<summary>获取Spine文件</summary>

日服:
`Android/data/com.YostarJP.BlueArchive/files/AssetBundls`
`YostarGames/BlueArchive_JP/BlueArchive_Data/StreamingAssets/AssetBundles`

国际服:
`Android/data/com.nexon.bluearchive/files/PUB/Resource/[Preload/GameData]/Android`
`steamapps/common/BlueArchive/BlueArchive_Data/StreamingAssets/PUB/Resource/[Preload/GameData]/Windows`

然后搜索`spine`

`assets-_mx-spinelobbies` 前缀的为记忆大厅

`assets-_mx-spinecharacters` 前缀的为立绘

以其名称或`CH`+`四位数字`开头的为已实装(或会实装)角色

以其名称或`NP`+`四位数字`开头的为NPC(或未实装)角色

把搜索到的文件复制到一个文件夹下备用

下载[AssetStudioModCLI](https://github.com/aelurum/AssetStudio)

`AssetStudioModCLI.exe [文件夹] -r -g none -o [输出文件夹] --filter-by-text .skel,.atlas,.png,ColorAdjustments`

</details>

## 下载

点击[发行版](https://github.com/cueavyqwp/spine-viewer/releases)即可

# 待办事项

- 基本
  - [x] 查看功能
  - [ ] 导出视频(计划加入)
- 互动
  - [ ] 眼部追踪
  - [ ] 摸头
  - [ ] 捏脸

# 不足之处

- 没有特效
- 眼部追踪轮廓不贴合

# 已知问题

# 导出

首先从[这里](https://zh.esotericsoftware.com/spine-godot#%E4%B8%8B%E8%BD%BD-spine-godot-%E5%BC%95%E6%93%8E%E6%A8%A1%E5%9D%97)下载`Godot 4.5.1 带 C# 支持`与对应的导出模板

解压下载下来的编辑器,将`godot-editor-windows-mono/GodotSharp/Tools/nupkgs`下的包复制到`godot-nuget`文件夹内

安装[.Net SDK](https://dotnet.microsoft.com/zh-cn/download)

然后下载[unifont-17.0.03.otf](https://www.unifoundry.com/pub/unifont/unifont-17.0.03/font-builds/unifont-17.0.03.otf)字体,重命名为`unifont.otf`放到`assets`文件夹下

启动编辑器

`编辑器` > `管理导出模板...` > `从文件安装`

`项目` > `导出...`
