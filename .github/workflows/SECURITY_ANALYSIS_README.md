# Security Analysis Workflow Configuration

This repository includes a robust GitHub Action for automated security analysis using CodeQL (SAST). By default, the workflow is disabled to prevent unnecessary runs in forked repositories or personal accounts. To enable, set the workflow input `enable_security_analysis` to `true`.

## How to Enable Security Analysis

1. Open `.github/workflows/security-analysis.yml`.
2. Change the value of `enable_security_analysis` from `false` to `true` in the workflow `inputs` section.

```
inputs:
  enable_security_analysis:
    description: 'Enable security analysis workflow'
    required: false
    default: 'false'
```

3. Commit and push your changes.

## What the Workflow Does

- Runs CodeQL analysis on push and pull request events (if enabled).
- Parses CodeQL results and creates a GitHub issue for each security finding.
- Handles permissions and works in forked repositories (no secrets required).
- Issues are formatted for easy triage and deduplication.

## Troubleshooting

- If the workflow does not run, ensure `enable_security_analysis` is set to `true`.
- If issues are not created, check repository permissions (issues must be enabled).
- For forks, the workflow will run without requiring additional configuration.

## Customization

- You can adjust the workflow to use other SAST tools (e.g., Bandit, Semgrep) by modifying the analysis step.
- To change issue formatting, edit the `Create Issue` step in the workflow.

---

For more details, see [SECURITY_ANALYSIS_GUIDE.md](../SECURITY_ANALYSIS_GUIDE.md).
