# Security Analysis GitHub Action

This repository includes an automated security analysis workflow that scans code for vulnerabilities and creates GitHub issues for each finding.

## 🔧 What It Does

- **CodeQL Analysis**: Scans Python and JavaScript code for security vulnerabilities
- **Bandit Analysis**: Python-specific security linter for common security issues
- **Automatic Issues**: Creates GitHub issues for each security finding with detailed information
- **Smart Scheduling**: Runs on code changes, pull requests, and weekly
- **Fork-Friendly**: Works in forked repositories without additional setup

## 🚨 Important: Disabled by Default

The workflow is **disabled by default** to prevent accidental runs in forks and personal accounts.

## ✅ How to Enable

1. **Edit the workflow file**: `.github/workflows/security-analysis.yml`

2. **Change this line**:
   ```yaml
   SECURITY_ANALYSIS_ENABLED: false
   ```
3. **To this**:

   ```yaml
   SECURITY_ANALYSIS_ENABLED: true
   ```

4. **Commit and push** your changes

## 🎯 Manual Run (Even When Disabled)

1. Go to **Actions** tab in your repository
2. Select **"Security Analysis (SAST)"**
3. Click **"Run workflow"**
4. Check **"Force run even if disabled"**
5. Click **"Run workflow"**

## 📋 What You'll Get

### Issue Labels

- `security` - All security findings
- `codeql` - CodeQL findings
- `bandit` - Bandit findings
- `python`/`javascript` - Language-specific
- `automated` - Auto-generated

### Severity Levels

- 🔴 **High**: Address immediately (SQL injection, XSS, RCE)
- 🟡 **Medium**: Address in next cycle (input validation, config issues)
- 🟢 **Low**: Address when convenient (code quality with security implications)

### Issue Content

Each issue includes:

- Severity level and rule information
- File location with direct link to code
- Detailed description and remediation steps
- Context about the security concern

## 🔍 Requirements

### For Public Repositories

- Issues must be enabled (Settings → General → Features → Issues)

### For Private Repositories

- GitHub Advanced Security enabled (Settings → Security & analysis)
- CodeQL analysis enabled

## 🛠️ Troubleshooting

| Problem              | Solution                                        |
| -------------------- | ----------------------------------------------- |
| Workflow doesn't run | Check `SECURITY_ANALYSIS_ENABLED: true`         |
| No issues created    | Verify Issues are enabled in repo settings      |
| Permission errors    | Enable GitHub Advanced Security (private repos) |
| CodeQL fails         | Check dependencies install correctly            |

## 📊 Filtering Issues

Use GitHub's search to find specific security issues:

- All security issues: `label:security`
- High severity only: `label:security "🔴 High"`
- Python issues: `label:security,python`
- CodeQL findings: `label:security,codeql`

## ⚙️ Customization

Edit `.github/workflows/security-analysis.yml` to:

- Add more languages: `language: [ 'python', 'javascript', 'java', 'typescript' ]`
- Change schedule: Modify the `cron` expression
- Adjust Bandit sensitivity: Change `--severity-level medium` to `low` or `high`

---

**Ready to secure your code?** Enable the workflow and let it find potential security issues automatically!
