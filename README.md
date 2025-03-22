<div align = "center" >
    <h1>spine-viewer</h1>

**基于Godot的Spine4查看器**

</div>

# 关于

目前还在开发中

用于查看蔚蓝档案(Blue Archive)里的`纪念大厅`与`角色立绘`

# 下载

点击[发行版](https://github.com/cueavyqwp/spine-viewer/releases)即可

# 功能

- 基本
  - [x] 查看功能
  - [ ] 纪念大厅背景(部分纪念大厅人物与背景被分成了两个文件)(计划加入)
  - [ ] 导出视频(计划加入)
- 互动
  - [ ] 眼部追踪(开发中)
  - [ ] 摸头(计划加入)
  - [ ] ~~捏脸~~(暂不加入)

# 导出

首先从[这里](https://zh.esotericsoftware.com/spine-godot#%E4%B8%8B%E8%BD%BD-spine-godot-%E5%BC%95%E6%93%8E%E6%A8%A1%E5%9D%97)下载带有spine-godot运行时的Godot4.3与对应的导出模板

然后下载[unifont-16.0.02.otf](https://www.unifoundry.com/pub/unifont/unifont-16.0.02/font-builds/unifont-16.0.02.otf)字体,重命名为`unifont.otf`放到`assets`文件夹下

## 导出到安卓

导出到安卓平台时还需额外配置安卓SDK

然后在`导出`>`选项`>`权限`那里启用`Manage External Storage` `Read External Storage`与`Write External Storage`
