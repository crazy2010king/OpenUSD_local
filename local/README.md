# OpenUSD 示例程序集合

本目录包含OpenUSD工程的示例程序梳理、移植和测试工具。

## 目录结构

```
local/
├── docs/                    # 文档目录
│   ├── usd_examples_guide.md    # 示例程序说明文档
│   └── images/                  # 文档配图
├── examples/                 # 移植后的示例程序
│   ├── core/                     # 核心功能示例
│   ├── imaging/                  # 渲染成像示例
│   ├── physics/                  # 物理引擎示例
│   └── exec/                     # 执行框架示例
├── scripts/                  # 脚本目录
│   ├── build_examples.sh          # 编译构建脚本
│   ├── run_all_examples.sh        # 统一调度运行脚本
│   └── test_examples.py           # 测试验证脚本
└── README.md                 # 本文件
```

## 快速开始

1. 编译所有示例：
```bash
bash scripts/build_examples.sh
```

2. 运行测试验证：
```bash
python3 scripts/test_examples.py
```

3. 运行示例程序：
```bash
bash scripts/run_all_examples.sh
```

## 平台信息

- 硬件：Intel i7-14700K + NVIDIA RTX 4070 SUPER 12GB
- 系统：Ubuntu 22.04 LTS
- 依赖：Python 3.10, GCC 11.4, Qt 5.15, OpenUSD dev
