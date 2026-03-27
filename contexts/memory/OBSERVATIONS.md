# Memory Observations

这是三层记忆系统的 L1 层主日志。每日观察由 `periodic_jobs/ai_heartbeat/src/v0/observer.py` 自动写入，每周由 `reflector.py` 整理和蒸馏。

相关文件：

- `contexts/memory/reflector_weekly_template.md`：周反思模板（L2）
- `contexts/memory/WEEKLY_REFLECTIONS.md`：每周反思落盘日志（L2）
- `contexts/memory/PREFERENCE_REGISTRY.md`：长期偏好注册表（L2.5）
- `contexts/memory/MEMORY_PROMOTION_PROTOCOL.md`：从观察晋升到偏好/规则/公理的协议

## 格式说明

每个日期条目格式如下：

```
Date: YYYY-MM-DD

🔴 High: [方法论/约束] 描述
🟡 Medium: [项目状态/决策] 描述
🟢 Low: [任务流水] 描述
```

### 优先级定义

- **🔴 High**：跨项目通用的经验教训、硬性约束、影响系统架构的重大决策。永久保留，候选晋升为 preference、rule、axiom 或 skill。
- **🟡 Medium**：活跃项目的关键进展、技术决策背景、未来几周仍需参考的信息。
- **🟢 Low**：日常任务流水、瞬时 debug 记录、临时上下文。定期垃圾回收。

## Observer 记录要求

写 L1 观察时优先记录：

- 做了什么决定
- 依据了什么证据
- 明确否掉了什么方案
- 哪一部分可能值得每周晋升

如果一条观察具备长期复用价值，尽量在行内显式写出：

- `Pattern candidate:`
- `Preference candidate:`
- `Upgrade target: weekly | preference | rule | axiom | skill`

如果观察来自仓库外的真实研究项目根目录，优先使用绝对 Windows 路径，并在必要时附上项目 ID。

## 如何加载记忆

不要全文加载这个文件（可能很大）。按需检索：

```bash
# 搜索特定主题
grep -n "关键词" contexts/memory/OBSERVATIONS.md

# 搜索最近 N 天
grep -A 20 "Date: $(date -v-7d +%Y-%m-%d)" contexts/memory/OBSERVATIONS.md
```

或使用语义搜索（`rules/skills/semantic_search.md`）做跨日期语义检索。

## 与长期偏好的关系

- `OBSERVATIONS.md` 只负责保留原始判断痕迹，不直接承担长期规范职能
- 每周反思先写入 `WEEKLY_REFLECTIONS.md`，形成可追溯的 L2 证据链
- 再由周反思结果判断哪些稳定模式应进入 `PREFERENCE_REGISTRY.md`
- 再由偏好注册表决定是否晋升到 `rules/`、`axioms/` 或 `skills/`

---

<!-- 以下是记录区域，由 observer.py 自动追加 -->
