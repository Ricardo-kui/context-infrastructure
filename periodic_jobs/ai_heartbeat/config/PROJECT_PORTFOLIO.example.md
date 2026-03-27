# AI Heartbeat Project Portfolio

用途：告诉 `observer.py` 和 `reflector.py` 应该优先扫描哪些真实研究项目根目录。  
建议：复制为 `PROJECT_PORTFOLIO.local.md`，再填写你的真实项目路径。`*.local.md` 应留在本机，不建议提交。

## 使用规则

- `Root path` 填写项目的绝对路径
- `Project ID` 保持短且稳定，便于在记忆中引用
- `Topic` 写清研究问题，帮助 observer 判断高信号内容
- `Priority files` 可列出优先关注的文件类型或子目录
- `Ignore noise` 可列出应忽略的同步缓存、临时文件或输出目录

## Project Template

### Project 1
- Project ID: example_project
- Root path: D:\path\to\project
- Topic: 这里写研究主题
- Priority files: `.do`, `.ado`, `.R`, `.py`, `.qmd`, `.md`, `.tex`, `.xlsx`, `.csv`
- Watch for: 识别设定, 变量构造, 回归结果, 审稿回复, 汇报材料
- Ignore noise: `~$*.xlsx`, `.tmp`, `logs/`, `output/`
