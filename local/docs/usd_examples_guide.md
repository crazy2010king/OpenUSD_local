# OpenUSD 示例程序完全指南

本文档详细介绍OpenUSD工程中的所有示例程序，包括功能原理、适用场景、运行方法和扩展开发指南。

## 概述

OpenUSD（Universal Scene Description）是Pixar开发的通用场景描述框架，广泛应用于影视、游戏、建筑等行业的3D内容制作流水线。本指南梳理了OpenUSD官方提供的所有可在当前平台运行的示例程序，帮助开发者快速理解和上手USD开发。

## 平台兼容性

当前测试平台：
- 硬件：Intel i7-14700K + NVIDIA RTX 4070 SUPER 12GB
- 系统：Ubuntu 22.04 LTS
- 依赖：Python 3.10, GCC 11.4, Qt 5.15, OpenUSD 24.03+

✅ = 完全支持，可直接运行
⚠️ = 需要额外依赖
❌ = 不支持当前平台

| 分类 | 示例名称 | 兼容性 | 说明 |
|------|----------|--------|------|
| **执行框架** | computingValues | ✅ | USD执行框架基础示例 |
| **执行框架** | definingComputations | ✅ | 自定义计算节点示例 |
| **执行框架** | workDispatchExample | ⚠️ | 需要libdispatch，仅Darwin平台 |
| **执行框架** | workTaskflowExample | ⚠️ | 需要Taskflow库 |
| **核心USD** | usdResolverExample | ✅ | 自定义资产解析器示例 |
| **核心USD** | usdRecursivePayloadsExample | ✅ | 递归Payload加载示例 |
| **核心USD** | usdDancingCubesExample | ✅ | 程序化生成动画场景示例 |
| **核心USD** | usdObj | ✅ | OBJ格式导入导出插件示例 |
| **核心USD** | usdGeomExamples | ✅ | USD几何节点使用示例 |
| **核心USD** | usdMakeFileVariantModelAsset | ✅ | 文件变体创建示例 |
| **核心USD** | usdSchemaExamples | ✅ | 自定义USD Schema示例 |
| **核心USD** | usdSemanticsExamples | ✅ | 语义标签使用示例 |
| **核心USD** | usdviewPlugins | ✅ | usdview插件开发示例 |
| **核心USD** | wasmFetchResolver | ⚠️ | 需要Emscripten SDK |
| **成像渲染** | hdParticleField | ✅ | Hydra粒子场渲染示例 |
| **成像渲染** | hdTiny | ✅ | 极简Hydra渲染器实现示例 |
| **成像渲染** | hdui | ⚠️ | 需要完整Qt开发环境 |
| **物理引擎** | usdPhysicsBoxOnBox | ✅ | 盒子堆叠物理模拟示例 |
| **物理引擎** | usdPhysicsBoxOnQuad | ✅ | 盒子碰撞平面示例 |
| **物理引擎** | usdPhysicsDistanceJoint | ✅ | 距离关节示例 |
| **物理引擎** | usdPhysicsGroupFiltering | ✅ | 碰撞组过滤示例 |
| **物理引擎** | usdPhysicsJoints | ✅ | 多种关节类型示例 |
| **物理引擎** | usdPhysicsNestedArticulation | ✅ | 嵌套关节链示例 |
| **物理引擎** | usdPhysicsPairFiltering | ✅ | 碰撞对过滤示例 |
| **物理引擎** | usdPhysicsSpheresWithMaterial | ✅ | 带材质的球体物理示例 |

---

## 示例详细说明

### 一、执行框架示例

#### 1. computingValues
**功能原理**：展示USD Exec执行框架的基础使用方法，演示如何创建计算网络、设置输入输出、执行计算并获取结果。

**适用场景**：
- 学习USD执行框架基础概念
- 开发基于USD的程序化计算流水线
- 实现参数化资产生成系统

**运行方法**：
```bash
cd local/examples/exec/computingValues
mkdir build && cd build
cmake .. -DCMAKE_PREFIX_PATH=/path/to/USD
make -j8
./computingValues
```

**效果展示**：
程序会输出计算网络的执行结果，展示不同输入参数下的计算输出。

**扩展开发**：
可以在此基础上添加自定义计算节点，实现更复杂的参数化计算逻辑，比如程序化生成模型变体。

---

#### 2. definingComputations
**功能原理**：演示如何定义自定义计算节点，如何注册到USD执行框架，以及如何在计算网络中使用自定义节点。

**适用场景**：
- 开发自定义计算节点插件
- 扩展USD执行框架功能
- 集成第三方算法库到USD流水线

**运行方法**：
```bash
cd local/examples/exec/definingComputations
mkdir build && cd build
cmake .. -DCMAKE_PREFIX_PATH=/path/to/USD
make -j8
./definingComputations
```

**效果展示**：
程序会创建包含自定义节点的计算网络，执行后输出自定义节点的计算结果。

**扩展开发**：
可以参考此示例实现业务相关的自定义计算节点，比如材质计算、模型变形等功能。

---

### 二、核心USD示例

#### 1. usdResolverExample
**功能原理**：展示如何实现自定义的USD资产解析器，支持自定义路径解析逻辑，比如从资产库、数据库或云存储中加载USD资产。

**适用场景**：
- 开发公司内部资产库集成
- 实现版本控制的资产解析
- 云资产管理系统集成

**运行方法**：
```bash
cd local/examples/core/usdResolverExample
mkdir build && cd build
cmake .. -DCMAKE_PREFIX_PATH=/path/to/USD
make -j8
export PXR_PLUGINPATH_NAME=$PWD:$PXR_PLUGINPATH_NAME
# 测试自定义解析器
usdcat test:asset.usda
```

**效果展示**：
自定义解析器会将"test:"前缀的路径解析为本地文件路径，成功加载并输出资产内容。

**扩展开发**：
可以修改解析逻辑，对接内部资产管理系统，支持根据ID、版本号等信息自动解析资产路径。

---

#### 2. usdDancingCubesExample
**功能原理**：演示如何程序化生成USD场景，创建大量动画立方体，实现复杂的动画效果。

**适用场景**：
- 程序化场景生成
- 大规模资产批量创建
- 动画效果程序化制作

**运行方法**：
```bash
cd local/examples/core/usdDancingCubesExample
mkdir build && cd build
cmake .. -DCMAKE_PREFIX_PATH=/path/to/USD
make -j8
./usdDancingCubesExample
usdview dancingCubes.usda
```

**效果展示**：
生成包含数百个动画立方体的USD场景，所有立方体按照正弦波规律运动，形成"跳舞"的效果。

**扩展开发**：
可以修改生成逻辑，创建不同的动画效果，比如城市建筑群生成、粒子效果等。

---

#### 3. usdSchemaExamples
**功能原理**：展示如何定义自定义USD Schema，包括自定义属性、API接口、继承关系等，以及如何使用自定义Schema创建和操作USD资产。

**适用场景**：
- 定义公司内部的资产标准
- 扩展USD数据模型
- 开发行业特定的USD扩展（如建筑、游戏、影视等）

**运行方法**：
```bash
cd local/examples/core/usdSchemaExamples
mkdir build && cd build
cmake .. -DCMAKE_PREFIX_PATH=/path/to/USD
make -j8
# 运行测试
./testSimpleSchema
```

**效果展示**：
程序会创建使用自定义Schema的USD资产，验证自定义属性和API的正确性。

**扩展开发**：
可以参考此示例定义自己的业务Schema，比如角色资产、道具资产、场景资产等自定义数据结构。

---

### 三、成像渲染示例

#### 1. hdTiny
**功能原理**：展示Hydra渲染器的极简实现，包含完整的渲染委托、渲染通道、渲染器插件等核心组件，是学习Hydra开发的最佳入门示例。

**适用场景**：
- 学习Hydra渲染框架
- 开发自定义渲染器插件
- 集成第三方渲染引擎到USD流水线

**运行方法**：
```bash
cd local/examples/imaging/hdTiny
mkdir build && cd build
cmake .. -DCMAKE_PREFIX_PATH=/path/to/USD
make -j8
export PXR_PLUGINPATH_NAME=$PWD:$PXR_PLUGINPATH_NAME
# 测试渲染器
./testenv/testHdTiny
```

**效果展示**：
极简渲染器会渲染一个简单的三角形，输出渲染结果图像。

**扩展开发**：
可以基于此框架扩展实现完整的渲染器，比如集成OpenGL/Vulkan渲染，或者对接第三方渲染引擎如Blender Cycles、Unity等。

---

#### 2. hdParticleField
**功能原理**：演示如何在Hydra中实现粒子场渲染，展示自定义prim类型的渲染支持。

**适用场景**：
- 粒子效果渲染开发
- 体积数据可视化
- 科学计算数据渲染

**运行方法**：
```bash
cd local/examples/imaging/hdParticleField
mkdir build && cd build
cmake .. -DCMAKE_PREFIX_PATH=/path/to/USD
make -j8
export PXR_PLUGINPATH_NAME=$PWD:$PXR_PLUGINPATH_NAME
usdview particleField.usda
```

**效果展示**：
在usdview中渲染动态粒子场效果，可以看到粒子随时间运动的动画。

**扩展开发**：
可以扩展支持更多体积数据类型，比如流体模拟数据、烟雾效果、医疗影像数据等的可视化。

---

### 四、物理引擎示例

所有物理示例均为USD场景文件，演示USD Physics Schema的使用方法，配合usdview和物理引擎插件可以直接运行模拟。

#### 1. usdPhysicsBoxOnBox
**功能原理**：展示基本的刚体碰撞模拟，一个盒子从空中掉落到另一个静止的盒子上，演示重力、碰撞、摩擦等物理效果。

**运行方法**：
```bash
usdview local/examples/physics/usdPhysicsBoxOnBox.usda
# 在usdview中点击播放按钮开始物理模拟
```

**效果展示**：
上方盒子掉落后与下方盒子碰撞，最终静止堆叠在一起。

---

#### 2. usdPhysicsJoints
**功能原理**：展示多种类型的物理关节，包括铰链关节、球形关节、棱柱关节等，演示关节的约束效果。

**适用场景**：
- 角色骨骼绑定
- 机械结构模拟
- 交互物体开发

---

## 常见问题

### 1. 编译时找不到USD头文件或库
**解决方案**：
确保`CMAKE_PREFIX_PATH`指向正确的USD安装目录，或者设置`USD_ROOT`环境变量。

### 2. 运行时找不到插件
**解决方案**：
设置`PXR_PLUGINPATH_NAME`环境变量指向编译生成的插件目录，确保插件的`plugInfo.json`文件存在且路径正确。

### 3. usdview中无法显示物理模拟
**解决方案**：
确保USD编译时开启了物理引擎支持（`PXR_BUILD_PHYSICS=ON`），并且安装了PhysX SDK。

### 4. 渲染示例运行时报错
**解决方案**：
确保显卡驱动正常安装，支持OpenGL 4.5以上，或者Vulkan 1.0以上。

---

## 参考资源

- [OpenUSD官方文档](https://openusd.org/docs/)
- [USD 教程](https://openusd.org/tutorials/)
- [Hydra 开发指南](https://openusd.org/docs/api/hd_page_front.html)
- [USD Physics 文档](https://openusd.org/docs/api/usd_physics_page_front.html)
- [OpenUSD GitHub仓库](https://github.com/PixarAnimationStudios/OpenUSD)
