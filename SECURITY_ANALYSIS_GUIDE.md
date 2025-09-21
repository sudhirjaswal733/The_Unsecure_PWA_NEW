# Security Analysis Configuration Guide

This repository includes an automated security analysis workflow that uses CodeQL and Bandit to identify potential security vulnerabilities in your code.

## 🚨 Important: Workflow is Disabled by Default

**The security analysis workflow is disabled by default** to prevent:
- Accidental runs in forked repositories
- Unexpected charges in personal GitHub accounts
- Issues being created without proper configuration

## ✅ How to Enable Security Analysis

### Step 1: Enable the Workflow

Edit the file `.github/workflows/security-analysis.yml` and change:

```yaml
env:
  # CRITICAL: Set this to true to enable the security analysis
  # Default is false to prevent accidental runs in forks
  SECURITY_ANALYSIS_ENABLED: false
```

To:

```yaml
env:
  # CRITICAL: Set this to true to enable the security analysis
  # Default is false to prevent accidental runs in forks
  SECURITY_ANALYSIS_ENABLED: true
```

### Step 2: Ensure Proper Permissions

Make sure your repository has the following settings enabled:

1. **GitHub Advanced Security** (for private repositories):
   - Go to Settings → Security & analysis
   - Enable "GitHub Advanced Security"

2. **CodeQL Analysis**:
   - Go to Settings → Security & analysis
   - Enable "Code scanning" with CodeQL

3. **Issues**:
   - Go to Settings → General
   - Ensure "Issues" are enabled

### Step 3: Configure Branch Protection (Recommended)

For production repositories, consider:
- Settings → Branches
- Add branch protection rules for `main`/`master`
- Require status checks to pass before merging

## 🔧 Workflow Features

### Security Analysis Tools

1. **CodeQL Analysis**:
   - Supports Python and JavaScript
   - Uses security-extended and security-and-quality query suites
   - Runs on push, pull requests, and weekly schedule
   - Creates detailed issues for each finding

2. **Bandit Analysis** (Python-specific):
   - Specialized Python security linter
   - Detects common security issues in Python code
   - Medium severity and above findings create issues

### Automatic Issue Creation

The workflow automatically creates GitHub issues for each security finding with:
- 🔴 High, 🟡 Medium, or 🟢 Low severity indicators
- Detailed descriptions and remediation guidance
- Direct links to the problematic code
- Labels for easy filtering and organization
- Deduplication to prevent duplicate issues

### Workflow Triggers

- **Push events** to main/master/develop branches
- **Pull requests** targeting main/master/develop branches
- **Weekly schedule** (Sundays at 2 AM UTC)
- **Manual dispatch** with force-run option

## 🎯 Manual Execution

You can manually run the workflow even when disabled:

1. Go to Actions tab in your repository
2. Select "Security Analysis (SAST)"
3. Click "Run workflow"
4. Check "Force run even if disabled"
5. Click "Run workflow"

## 📋 Issue Management

### Issue Labels

Security issues are tagged with:
- `security` - All security-related issues
- `codeql` - Issues found by CodeQL
- `bandit` - Issues found by Bandit
- `python` / `javascript` - Language-specific issues
- `automated` - Auto-generated issues

### Filtering Security Issues

Use GitHub's issue filters:
- All security issues: `label:security`
- High severity: `label:security` and search for "🔴 High"
- CodeQL issues: `label:security,codeql`
- Python security issues: `label:security,python`

## 🔍 Understanding Results

### False Positives

Not all findings are actual security vulnerabilities:
1. Review each issue carefully
2. Consider the context of your application
3. Close issues that are false positives with a comment
4. Consider suppressing recurring false positives in code

### Priority Guidelines

1. **🔴 High Severity**: Address immediately
   - SQL injection, XSS, authentication bypass
   - Remote code execution vulnerabilities

2. **🟡 Medium Severity**: Address in next development cycle
   - Input validation issues
   - Insecure configurations

3. **🟢 Low Severity**: Address when convenient
   - Code quality issues with security implications
   - Potential information disclosure

## 🛠️ Customization Options

### Modifying Analysis Scope

Edit `.github/workflows/security-analysis.yml` to:

1. **Change languages analyzed**:
   ```yaml
   matrix:
     language: [ 'python', 'javascript', 'typescript', 'java' ]
   ```

2. **Modify CodeQL queries**:
   ```yaml
   queries: security-extended,security-and-quality
   # Or use: queries: security-only
   ```

3. **Adjust Bandit severity**:
   ```bash
   bandit -r . -f json -o bandit-report.json --severity-level low
   ```

### Schedule Changes

Modify the cron schedule:
```yaml
schedule:
  # Run daily at midnight UTC
  - cron: '0 0 * * *'
  # Run on weekdays at 9 AM UTC
  - cron: '0 9 * * 1-5'
```

## 🚀 Best Practices

### For Repository Maintainers

1. **Enable workflow gradually**: Start with manual runs
2. **Review initial results**: Assess false positive rate
3. **Train team members**: Ensure understanding of security issues
4. **Set up notifications**: Monitor security issue creation
5. **Regular reviews**: Weekly/monthly security issue triage

### For Contributors

1. **Check security issues before contributing**
2. **Run security analysis on feature branches**
3. **Address security findings in your changes**
4. **Ask questions if findings are unclear**

### For Forked Repositories

If you fork this repository:
1. **Decide if you want security analysis**
2. **Enable the workflow manually** (it's disabled by default)
3. **Ensure your GitHub account supports the features used**
4. **Consider the cost implications** for private repositories

## 🆘 Troubleshooting

### Common Issues

1. **Workflow doesn't run**:
   - Check `SECURITY_ANALYSIS_ENABLED` is `true`
   - Verify repository permissions
   - Check GitHub Advanced Security is enabled

2. **No issues created**:
   - Verify `issues: write` permission
   - Check if Issues are enabled in repository settings
   - Look for errors in workflow logs

3. **CodeQL fails**:
   - Check language matrix configuration
   - Verify dependencies can be installed
   - Review CodeQL initialization logs

4. **Permission errors**:
   - Ensure proper workflow permissions
   - Check GitHub token scopes
   - Verify Advanced Security features are available

### Getting Help

1. Check workflow run logs in the Actions tab
2. Review GitHub's CodeQL documentation
3. Consult Bandit documentation for Python-specific issues
4. Open an issue in this repository for workflow problems

## 📚 Additional Resources

- [GitHub CodeQL Documentation](https://docs.github.com/en/code-security/code-scanning/using-codeql-code-scanning-with-your-existing-ci-system)
- [Bandit Security Linter](https://bandit.readthedocs.io/)
- [GitHub Advanced Security](https://docs.github.com/en/get-started/learning-about-github/about-github-advanced-security)
- [OWASP Security Guidelines](https://owasp.org/www-project-top-ten/)