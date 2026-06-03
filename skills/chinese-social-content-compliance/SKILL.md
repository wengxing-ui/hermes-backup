---
name: chinese-social-content-compliance
description: "Review content for compliance on Chinese social platforms (小红书, 抖音, 微信公众号, 微博). Check for banned words, industry restrictions, platform-specific rules, and account type limitations. Provide risk assessments and rewrite suggestions in Chinese."
version: 1.0.0
author: Hermes Agent
license: MIT
metadata:
  hermes:
    tags: [social-media, compliance, chinese, content-review, xiaohongshu, douyin, wechat]
    platforms: [feishu]
---

# Chinese Social Media Content Compliance Review

Review and audit content for compliance on major Chinese social media platforms — 小红书 (Xiaohongshu/RED), 抖音 (Douyin), 微信公众号 (WeChat Official Accounts), and 微博 (Weibo).

**Default language: Chinese** — all analysis, tables, risk labels, and rewrite suggestions use Chinese. Only switch to English if the user explicitly asks.

## When to Use

- User asks to review a post/article for 违禁词 (banned words) or 限流风险 (shadow-ban risk)
- User is drafting content for 小红书 / 抖音 / 公众号 / 微博
- User asks about platform rules, Blue V certification, or account compliance
- User wants to know if their content might be flagged, hidden, or removed

## Review Framework

Analyze content against three risk tiers:

### 🔴 High Risk — Likely removal, account penalty

| Category | Triggers |
|----------|----------|
| **Regulated industries** | Immigration (移民), finance/investment advice, medical claims, education credentials — especially when the account lacks industry certification |
| **Brand/org without Blue V** | Mentioning a company name, service brand, or institutional identity when the account is not a certified enterprise account |
| **Lead generation** | Asking users to comment with personal info, contact details, or "私信我" / "评论区聊聊你的情况" — especially in regulated industries |
| **Asset transfer hints** | Phrasing that could be read as advising users how to move assets, avoid taxes, or restructure holdings to circumvent regulations |
| **Unlicensed professional advice** | Tax planning, legal advice, medical diagnosis, investment recommendations without visible professional credentials |

### 🟡 Medium Risk — Likely shadow-ban or reduced reach

| Category | Triggers |
|----------|----------|
| **Urgency/scarcity pressure** | 制造焦虑的话术: "窗口已经关上" "宜早不宜迟" "错过就没有了" |
| **Tax optimization language** | "避税" "个税" in contexts suggesting tax avoidance rather than neutral information |
| **Sensitive industry adjacency** | Even neutral content in immigration, finance, crypto may be algorithmically down-ranked regardless of phrasing |
| **Content farm patterns** | Dense numbered lists (7+ items), heavy use of emoji numbers (1️⃣2️⃣3️⃣), formulaic structure |

### 🟢 Low Risk — Minor improvements

| Category | Triggers |
|----------|----------|
| Emoji overuse | More than ~5 emoji per paragraph can look spammy |
| Hashtag quality | Too many hashtags or hashtags that don't match the content |
| Readability | Overly long paragraphs, too much jargon |

## Platform-Specific Rules

### 小红书 (Xiaohongshu / RED)

- **Account types**: 个人号 (personal) vs 蓝V企业号 (Blue V enterprise)
- **Blue V**: Requires business license (营业执照). Allows brand mentions, contact tools (私信通/表单). Does NOT exempt content from algorithmic down-ranking in sensitive verticals.
- **Industry certifications**: Immigration (因私出入境中介许可证), finance, healthcare, education each have separate industry qualification requirements. Blue V alone is insufficient for regulated industries.
- **Particularly sensitive verticals**: Immigration/overseas identity, cryptocurrency, medical aesthetics, weight loss products, financial products
- **Comment section**: Do NOT use comments to collect user leads (联系方式/资产情况/移民意向). Use 私信通 (official DM tool) instead.
- **Content style**: Authentic/personal voice performs better than marketing templates. Heavy list-formats (>7 items) can trigger content-farm detection.

### 抖音 (Douyin)

- Content review is faster and more automated than 小红书
- Video captions and spoken words BOTH get scanned
- Medical/health claims are especially tightly controlled
- Livestream rules are separate and stricter than video rules

### 微信公众号 (WeChat Official Accounts)

- Stricter on political/social commentary
- More lenient on long-form educational content
- Subscription accounts (订阅号) vs service accounts (服务号) have different capabilities

### 微博 (Weibo)

- Fastest censorship response; hot-search content gets extra scrutiny
- Entertainment/gossip has more leeway than on other platforms
- Brand mentions are less restricted than 小红书

## Output Format

Always structure the review as:

1. **Risk summary** — one-line overall assessment with risk level emoji (🔴🟡🟢)
2. **Issue table** — each issue with #, problem description, specific text involved, risk explanation
3. **Rewrite suggestions** — side-by-side table: original text → problem → suggested rewrite
4. **Overall assessment** — risk level, reasoning, release recommendation
5. **Next steps** — offer to rewrite the full post or give more specific guidance

## Account Type Context

Always ask or determine the account type before making final recommendations:

- **Personal account (个人号)**: Must avoid ALL commercial/brand language. Even neutral mentions of a company name can trigger penalties.
- **Blue V enterprise (蓝V企业号)**: Can mention own brand. Still subject to industry-specific regulations. Requires industry certifications for regulated verticals.
- **Blue V + industry certification (双认证)**: Most compliant. Still subject to algorithmic down-ranking in sensitive verticals.

## Common Pitfalls

- **"But it's just information sharing!"** — Platforms don't distinguish between educational content and commercial content in regulated industries. If immigration advice comes from an immigration company's account, it's treated as commercial regardless of tone.
- **"I didn't mention the company name"** — Even hashtags like #品牌名 can be detected as brand promotion. Use neutral topic tags instead.
- **"Comments are organic engagement"** — Asking "你的情况是什么？评论区聊聊" in a regulated industry context is treated as lead generation, not engagement.
- **Blue V as a cure-all** — Blue V prevents the most basic violations (undeclared commercial content) but does nothing for industry-specific restrictions or algorithmic down-ranking of sensitive verticals.

## Rewrite Principles

When rewriting for compliance:

1. **Weaken the industry signal** — Replace "移民" with "海外生活规划" or "跨境家庭" where possible
2. **Remove all brand identifiers** — No company names, service marks, branded hashtags
3. **Neutralize urgency** — Replace "窗口关上了" with "提前了解更从容"
4. **Degrade calls-to-action** — Replace lead-gen CTAs with neutral engagement ("你们怎么看？" not "评论区说说你的情况")
5. **Add disclaimers** — For advice-adjacent content: "本文仅为信息分享，具体情况请咨询专业人士"
6. **Preserve value** — Don't strip so much that the content becomes useless. Find the line between informative and promotional.
