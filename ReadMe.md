# Unity-3ds Max HLSL Shader Bridge

![Max](Max.gif)



3ds Max支持自定义的HLSL Shader，但是官方给出来的着色器样例大多基于DX9，而现在Max默认的渲染器是DX11，虽然可以把渲染器版本降低到DX9，但是我想大家应该都不愿意这么做。

DX11版本的HLSL着色器语法改变比较大，我这里写了几个基本的Max Shader供参考。

我使用了Unity风格的CG语言来编写。



一共包含三个实例着色器：

Texture：仅仅是采样并显示贴图。

SimpleToon：Roystan的Unity Toon着色器的Max版本~

PBR_IBL：Epic Games Unreal Engine的PBR IBL的Max版本~



注：这些着色器也可以参考：官方的HLSL着色器在3ds Max安装目录下的 hardwareshaders文件夹下可以找到，里面是Max本身用到的DX Shader。 



注意点（就目前我所总结的）

**Max Shader能做到什么？**

1. 多Pass渲染（在卡通渲染描边时用到）
2. Blend、Cull、Stencil Mask等状态
3. lights信息获取（用于前向渲染）
4. 几何、细分着色器（DX11 SM5.0）

**Max Shader不能做到什么？**

1. 渲染次序控制
2. GBuffer无法获取（MaxPipeline中提供了GBuffer，用户直接是获取不到的）

存疑：

1. shadow Map（模拟模型的自阴影时用到，但是按照Nvidia的Shadowmap写法是无法通过编译的，切换到DX9也无法正常着色）。