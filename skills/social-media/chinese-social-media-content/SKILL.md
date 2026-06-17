---
name: chinese-social-media-content
description: "Chinese social media content operations — content creation (script splitting, note formatting) and compliance review (banned words, platform rules, risk assessment) for 小红书, 抖音, 微信公众号, and 微博."
version: 1.0.0
author: Hermes Agent
license: MIT
metadata:
  hermes:
    tags: [social-media, chinese, content-creation, compliance, xiaohongshu, douyin, wechat, weibo]
---

# Chinese Social Media Content Operations

End-to-end content operations for major Chinese social media platforms: 小红书 (Xiaohongshu/RED), 抖音 (Douyin), 微信公众号 (WeChat Official Accounts), and 微博 (Weibo). Covers two primary workflows: **content creation** (script splitting, note formatting, post layout) and **compliance review** (banned words, platform rules, risk assessment).

**Default language: Chinese** — all analysis, labels, and suggestions use Chinese unless the user explicitly asks otherwise.

## When to Use

- User asks to split long scripts into 小红书 videos
- User wants to format/polish a 小红书 note layout
- User asks to review content for 违禁词 (banned words) or 限流风险 (shadow-ban risk)
- User is drafting content for any Chinese social platform
- User asks about platform-specific rules, Blue V certification, or account compliance
- User wants to know if their content might be flagged, hidden, or removed

---

# Part 1: Content Creation

## 小红书 Video Script Splitting

When converting a long article into a series of 小红书 short videos:

### Format Requirements

Each video must include:
- **Cover (封面)**: A standalone attention-grabbing title, one line
- **Duration (时长)**: Approximate X min X sec
- **Body (正文)**: Do NOT alter original content, only segment it
- **Hook**: Video 1 and 2 end with a cliffhanger to drive viewers to the next episode
- **Call to Action**: Final video ends with an engagement CTA

### Splitting Logic

Split at natural content breakpoints, typically a three-episode structure:
1. **Episode 1**: Opening hook + first core point
2. **Episode 2**: Transition + second core point
3. **Episode 3**: Full perspective + CTA close

### Format Example

```
视频一：标题（约X分X秒）
封面：封面文字
正文内容...
下期讲XXX，更严重👇

视频二：标题（约X分X秒）
封面：封面文字
接上期。正文内容...
还有一个风险，更隐蔽。

视频三：标题（约X分X秒）
封面：封面文字
正文内容...
结尾行动号召
```

## 小红书 Note Formatting

When converting long-form text into a 小红书 note:

- Use emoji as visual separators (🇺🇸 ⚠️ ❌ 💡 🔑 📌 💬)
- Max 3 lines per paragraph — use frequent line breaks
- Highlight key points with symbols (▪️ ❶ ❷ ③)
- Wrap keywords in 「」 brackets
- Strong opening hook + closing engagement prompt
- Place #tags at the end

### Content Creation Pitfalls

- Never alter the user's original copy — only segment and format
- Preserve the original language style and wording
- Each split segment must be independently complete with a beginning and end

---

# Part 2: Compliance Review

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

## Output Format for Compliance Review

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

## Compliance Pitfalls

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
