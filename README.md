# JD Shopping Skill

京东浏览器自动化辅助 skill，用于在用户自己的可见浏览器会话中进行低频、慢速、可监督的京东登录、搜索、比选和加购操作。它只辅助加购，不下单、不结算、不付款。

## 一句话安装

```bash
target="${CODEX_HOME:-$HOME/.codex}/skills/jd-shopping" && mkdir -p "$(dirname "$target")" && { [ -d "$target/.git" ] && git -C "$target" pull --ff-only || { rm -rf "$target" && git clone --depth 1 https://github.com/kt-aicoding/skill-jd.git "$target"; }; }
```

这条命令会安装或更新 `jd-shopping` skill 目录，但不会读取或修改浏览器登录态、Cookie、订单、地址或支付信息。

## 名称

- 安装名：`jd-shopping`
- 仓库名：`skill-jd`
- 调用方式：`Use $jd-shopping ...`

## 适用场景

- 打开京东并让用户手动完成登录、二维码、短信、滑块或设备验证。
- 在已登录京东会话中搜索商品、查看少量候选、打开商品页。
- 根据用户已确认的目标选择明确 SKU，并将商品加入购物车。
- 对常见低风险商品使用保守默认参数，例如数量 1、普通包装、无付费延保、无分期、无安装服务。
- 复用专用 Playwright 会话，尽量避免关闭页面、重开浏览器或触发风控。

## 不做什么

- 不绕过验证码、滑块、短信、人脸、设备校验或任何风控。
- 不读取、保存、输出或提交密码、短信码、Cookie、Token、地址、电话、订单、发票或支付信息。
- 不点击 `立即购买`、`去结算`、`提交订单`、`付款`、`确认支付`、`分期付款` 等按钮。
- 不做批量抓取、批量加购、抢购、刷接口、代理轮换或指纹规避。
- 不替用户决定高价值商品、处方药剂量、实名信息、配送地址、发票、保险、延保或其他会影响支出/合规的选项。

## 文件结构

```text
.
├── SKILL.md
├── agents/
│   └── openai.yaml
└── scripts/
    └── pw-jd.sh
```

## 依赖

- Codex skills 目录：默认 `${CODEX_HOME:-$HOME/.codex}/skills`
- Node.js/npm：用于提供 `npx`
- 本机已安装 Playwright skill，并存在：

```text
${CODEX_HOME:-$HOME/.codex}/skills/playwright/scripts/playwright_cli.sh
```

## 验证安装

```bash
python3 "${CODEX_HOME:-$HOME/.codex}/skills/.system/skill-creator/scripts/quick_validate.py" "${CODEX_HOME:-$HOME/.codex}/skills/jd-shopping"
```

验证 wrapper 是否会拒绝破坏性命令：

```bash
scripts/pw-jd.sh close
```

预期会拒绝关闭浏览器。只有在用户明确要求清理会话时，才可以临时设置 `JD_ALLOW_DESTRUCTIVE=1`。

## 使用方式

```text
Use $jd-shopping to log in manually, search JD products, and add an approved item to cart without checkout.
```

常见请求示例：

```text
Use $jd-shopping 打开京东并让我登录。
Use $jd-shopping 搜索一根适合 iPhone 14 Pro 的充电线，优先京东自营，合适就加购 1 件。
Use $jd-shopping 检查刚才的商品是否加到购物车，不要结算。
```

## 安全设计

- 使用专用 Playwright 会话名 `jd`，避免污染默认浏览器会话。
- 默认使用可见浏览器，不在后台静默处理登录、购物车、处方药或支付相邻页面。
- wrapper 默认拒绝 `close`、`close-all`、`kill-all`、`delete-data`、Cookie 清理和存储清理，减少误关页面导致登录态丢失。
- 登录后优先在页面内搜索和跳转，避免频繁直开 URL 导致站点重新校验。
- 每次关键操作前后都应重新 snapshot，避免使用过期元素引用。
- 建议在搜索、打开商品、选择 SKU、加购后等待 4-10 秒，不做连续快速点击。

## 数据脱敏说明

本仓库不包含：

- 京东账号、手机号、地址、订单、购物车、物流、发票或支付信息。
- Cookie、Token、localStorage、sessionStorage、浏览器用户数据目录。
- Playwright trace、截图、页面快照、控制台日志、网络请求体。
- 个人购物记录、药品处方、实名信息或任何结算资料。

README 和 skill 示例均为通用说明，不包含真实用户账户或商品交易记录。

## 免责声明

本 skill 只用于用户本人账号的低频个人购物辅助。使用时应遵守京东平台规则、商品销售规则以及当地法律法规。涉及处方药、医疗用品、实名信息、支付、发票或订单提交时，必须由用户本人判断并手动完成。
