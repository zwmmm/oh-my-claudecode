---
model: claude-haiku
---

# Git Rollback 详细指南

交互式回滚 Git 分支到历史版本，支持 reset 和 revert 两种模式。

> 💡 **建议**: 执行本命令前,建议先运行 `/clear` 命令清理上下文,以获得更好的分析效果。

## 目录

- [选项说明](#选项说明)
- [交互流程](#交互流程)
- [reset vs revert](#reset-vs-revert)
- [安全护栏](#安全护栏)
- [适用场景](#适用场景)

---

## 选项说明

| 选项 | 说明 |
|------|------|
| `--branch <branch>` | 要回滚的分支；缺省时交互选择 |
| `--target <rev>` | 目标版本（commit Hash、Tag、reflog 引用）；缺省时交互选择 |
| `--mode reset\|revert` | `reset`：硬回滚历史；`revert`：生成反向提交保持历史完整 |
| `--depth <n>` | 在交互模式下列出最近 n 个版本（默认 20） |
| `--dry-run` | **默认开启**，只预览即将执行的命令 |
| `--yes` | 跳过所有确认直接执行，适合 CI/CD 脚本 |

---

## 交互流程

1. **同步远端** → `git fetch --all --prune`
2. **列分支** → `git branch -a`（本地＋远端，过滤受保护分支）
3. **选分支** → 用户输入或传参
4. **列版本** → `git log --oneline -n <depth>` + `git tag --merged` + `git reflog -n <depth>`
5. **选目标** → 用户输入 commit hash / tag
6. **选模式** → `reset` 或 `revert`
7. **最终确认** （除非 `--yes`）
8. **执行回滚**
   - `reset`：`git switch <branch> && git reset --hard <target>`
   - `revert`：`git switch <branch> && git revert --no-edit <target>..HEAD`
9. **推送建议** → 提示是否 `git push --force-with-lease`（reset）或普通 `git push`（revert）

---

## reset vs revert

### reset 模式

**特点**：
- 改变历史，将分支指针直接移动到目标版本
- 后续版本的提交会从历史中消失
- 需要强推（`--force-with-lease`）才能更新远程

**适用场景**：
- 私有分支，无其他人依赖
- 希望完全移除某些提交
- 紧急回滚且愿意承担强推风险

**命令**：
```bash
git switch <branch>
git reset --hard <target>
git push --force-with-lease
```

### revert 模式

**特点**：
- 保持历史完整，生成反向提交
- 不改变历史，只是添加新的提交
- 可以正常推送

**适用场景**：
- 共享分支，有其他人依赖
- 需要保留完整的操作记录
- 公开发布的版本

**命令**：
```bash
git switch <branch>
git revert --no-edit <target>..HEAD
git push
```

---

## 安全护栏

1. **备份**：执行前自动在 reflog 中记录当前 HEAD，可用 `git switch -c backup/<timestamp>` 恢复
2. **保护分支**：如检测到 `main` / `master` / `production` 等受保护分支且开启 `reset` 模式，将要求额外确认
3. **--dry-run 默认开启**：防止误操作
4. **--force 禁止**：不提供 `--force`；如需强推，请手动输入 `git push --force-with-lease`

---

## 适用场景

| 场景 | 建议调用 |
|------|----------|
| 热修补丁上线后发现 bug，需要回到 Tag `v1.2.0` | `--branch release/v1 --target v1.2.0 --mode reset` |
| 运维同事误推了 debug 日志提交，需要生成反向提交 | `--branch main --target 3f2e7c9 --mode revert` |
| 调研历史 bug，引导新人浏览分支历史 | 全交互，dry-run |

---

## 使用示例

```bash
# 纯交互：列出分支 → 选分支 → 列最近 20 个版本 → 选目标 → 选择模式 → 确认
# 默认 dry-run

# 指定分支，其他交互
# --branch feature/calculator

# 指定分支与目标 commit，并用 hard-reset 一键执行（危险）
git switch main
git reset --hard 1a2b3c4d
# 需要手动确认后执行 git push --force-with-lease

# 只想生成 revert 提交（非破坏式回滚），预览即可
git log --oneline -n 20  # 查看历史
# 确认目标后
git revert --no-edit v2.0.5..HEAD
```

---

## 注意事项

1. **嵌入式仓库** 常有大体积二进制文件；回滚前请确保 LFS/子模块状态一致
2. 若仓库启用了 CI 强制校验，回滚后可能自动触发流水线；确认管控策略以免误部署旧版本
3. `reset` 会改变历史，需要强推并可能影响其他协作者，谨慎使用
4. `revert` 更安全，生成新提交保留历史，但会增加一次记录
