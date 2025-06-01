<div align = "center" >
    <h1>spine-viewer</h1>

**基于Godot的Spine4查看器**

</div>

# 关于

目前还在开发中

用于查看蔚蓝档案(Blue Archive)里的`纪念大厅`与`角色立绘`

<details>

<summary>获取日服Spine文件</summary>

**注意:自安卓11起Android/data变得不好访问,可以尝试连接电脑访问,[Shizuku](https://github.com/RikkaApps/Shizuku)+[MT文件管理器](https://mt2.cn/),或者使用模拟器**

转到`Android/data/com.YostarJP.BlueArchive/files/AssetBundls`目录下

然后搜索`spine`,把搜索到的文件复制到一个文件夹下备用

打开[AssetStudio](https://github.com/aelurum/AssetStudio)

先更改导出设置`Options`>`Export options`将`Group exported assets by`选为 `container path full (with name)`

`File`>`Load folder`然后选择文件夹

过滤文件`Filter Type`只选中`TextAsset`与`Texture2D`

然后导出`Export`>`Filtered assets`

在导出的文件夹`Assets/_MX`下会有三个文件夹

- `SpineBackground` 背景
- `SpineCharacters` 立绘
- `SpineLobbies` 纪念大厅

</details>

## 下载

点击[发行版](https://github.com/cueavyqwp/spine-viewer/releases)即可

# 功能

- 基本
  - [x] 查看功能
  - [ ] 纪念大厅背景(部分纪念大厅人物与背景被分成了多个文件)(计划加入)
  - [ ] 导出视频(计划加入)
- 互动
  - [x] 眼部追踪
  - [x] 摸头
  - [ ] ~~捏脸~~(暂不计划加入)

# 不足之处

- 没有特效
- 眼部追踪轮廓不贴合

# 导出

首先从[这里](https://zh.esotericsoftware.com/spine-godot#%E4%B8%8B%E8%BD%BD-spine-godot-%E5%BC%95%E6%93%8E%E6%A8%A1%E5%9D%97)下载带有spine-godot运行时的Godot4.4.1与对应的导出模板

然后下载[unifont-16.0.03.otf](https://www.unifoundry.com/pub/unifont/unifont-16.0.03/font-builds/unifont-16.0.03.otf)字体,重命名为`unifont.otf`放到`assets`文件夹下

## 导出到安卓

导出到安卓平台时还需额外配置JDK与安卓SDK

然后在`导出`>`选项`>`权限`那里启用`Manage External Storage` `Read External Storage`与`Write External Storage`
