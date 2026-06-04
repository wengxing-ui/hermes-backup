---
name: professional-research-workflow
description: "专业问题回答流程：必须先搜索核查再回复，每条回复附官方依据（出处、条款原文、官方链接）。"
version: 1.0.0
author: Hermes Agent
license: MIT
platforms: [linux, macos, windows]
metadata:
  hermes:
    tags: [research, verification, compliance, legal, professional]
    related_skills: [native-mcp]
---

# 专业问题核查回答流程

用户从事专业工作，所有涉及专业知识、法律法规、政策条文、行业规范等问题的回答，必须经过严格的实时核查流程。

## 触发条件

当用户提问涉及以下任意一项时，触发此流程：
- 法律法规、司法解释、行政法规
- 政策文件、部门规章、行业标准
- 专业知识、学术概念、技术规范
- 统计数据、市场数据、研究报告
- 任何需要引用权威来源的内容

## 回答流程（严格按顺序）

### 第一步：飞书文档优先检索

先搜索用户的飞书知识库和云文档。如果飞书文档中有相关内容，优先使用。

### 第二步：搜索引擎交叉验证

使用已绑定的三个搜索引擎同时核查：

- 博查（中文搜索主力，search_backend=bocha）
- 秘塔（MCP接入，6个工具：web_search、web_reader、chat、topic_list、topic_search、topic_file_content）
- Tavily（网页内容提取，backend=tavily）

交叉验证：至少两个来源互相印证后才可采信。

### 第三步：回答格式——每条事实必须附三要素

回复中的每一句话如果涉及事实性陈述，必须附带：

1. 出处来源：明确说明信息来自哪个官方机构、网站或文档
2. 条款原文：如果是法律法规，必须写明第几条第几款，并引用原文
3. 官方链接：提供可访问的官方网址或文档链接

格式示例：
"根据《XXX法》第X条第X款规定：'[原文引用]'（来源：XXX官网，链接：https://...）"

## 禁止行为

- 禁止不搜索直接用训练数据回答专业问题
- 禁止只用一个来源就下结论
- 禁止引用内容不附带出处和链接
- 禁止对法律法规做主观解读而不引用原文
- 禁止使用非官方来源（个人博客、自媒体等）作为唯一依据

## 当前搜索工具清单

| 工具 | 用途 | 接入方式 |
|------|------|----------|
| 博查 (Bocha) | 中文搜索 | search_backend=bocha |
| 秘塔 (MetaSo) | 网页搜索+阅读+问答+专题 | MCP HTTP (metaso.cn/api/mcp) |
| Tavily | 网页内容提取 | backend=tavily |

秘塔通过MCP接入，注册了6个工具：mcp_metaso_metaso_web_search、mcp_metaso_metaso_web_reader、mcp_metaso_metaso_chat、mcp_metaso_metaso_topic_list、mcp_metaso_metaso_topic_search、mcp_metaso_metaso_topic_file_content。
