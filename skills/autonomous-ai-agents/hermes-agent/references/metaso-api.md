# 秘塔（MetaSo）搜索 API 接入

> 用户口述为"蜜塔"，实际产品名为"秘塔"（metaso.cn）。搜索时注意纠正。

## 基本信息

| 项目 | 内容 |
|------|------|
| 官网 | https://metaso.cn |
| API 协议 | MCP（Model Context Protocol） |
| MCP 端点 | `https://metaso.cn/api/mcp` |
| 认证方式 | `Authorization: Bearer <API_KEY>` |
| API Key 格式 | `mk-` 开头 |
| 定价 | 每次查询 0.03 元人民币 |
| 功能 | 搜索、网页全文获取、问答 |

## 获取 API Key

1. 打开 https://metaso.cn 注册/登录
2. 进入任意一个「专题」页面
3. 在专题设置中开启 API Key
4. 复制 `mk-` 开头的完整密钥

## Hermes MCP 配置

在 `~/.hermes/config.yaml` 中添加：

```yaml
mcp_servers:
  metaso:
    url: "https://metaso.cn/api/mcp"
    headers:
      Authorization: "Bearer mk-xxxxxxxxxxxxxxxx"
    timeout: 180
    connect_timeout: 60
```

## 依赖

需要安装 `mcp` Python 包：

```bash
# 在 Hermes 环境中
/usr/bin/python3 -m pip install mcp --break-system-packages
```

MCP 工具会以 `mcp_metaso_*` 的前缀注册到 Hermes 中。

## 注意事项

- 秘塔专门针对中文搜索优化，与博查搭配使用效果最好
- API 需要用户自行在 metaso.cn 获取 Key，无法代为操作
- 配置修改后需要重启 Gateway（`/restart`）才能生效
- 工具注册、连接生命周期、故障恢复等详见 `skills/mcp/native-mcp/SKILL.md`
