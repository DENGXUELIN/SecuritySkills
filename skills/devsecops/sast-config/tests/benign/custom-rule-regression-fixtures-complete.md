# Benign: Custom SAST rule has positive and negative regression fixtures

This fixture should avoid custom rule regression evidence findings because fixture mapping, annotations, regression command, and drift handling are complete.

## Review Context

- Tool: Semgrep
- Rule ID: `custom.python.path-join-traversal`
- Rule file: `.semgrep/custom/path-traversal.yml`
- Language: Python
- CI job: `sast-custom-rules`

## Custom Rule Regression Evidence

| Field | Evidence |
|---|---|
| Rule ID | `custom.python.path-join-traversal` |
| Tool / Language | Semgrep / Python |
| Rule File | `.semgrep/custom/path-traversal.yml` |
| Positive Fixtures | `.semgrep/tests/path_traversal/vulnerable_join.py` with 3 `# ruleid: custom.python.path-join-traversal` annotations |
| Negative Fixtures | `.semgrep/tests/path_traversal/safe_join.py` and `canonicalized_upload.py` with 7 `# ok: custom.python.path-join-traversal` annotations |
| Expected Annotations | committed `# ruleid` and `# ok` annotations plus expected result count in CI log |
| Regression Command | `semgrep --test .semgrep/custom/path-traversal.yml` |
| Last Passing Run | commit `abc1234`, CI log `sast-custom-rules#482`, 3 findings and 7 ok assertions |
| CI Enforcement | required pull-request check for custom rule changes |
| Coverage Limits | Windows drive-letter paths and archive extraction are out of scope and tracked in `APPSEC-991` |
| Drift Handling | AppSec owner reviews fixture diff; false-positive rate tracked monthly |

## Fixture Examples

Positive fixture:

```python
target = os.path.join(UPLOAD_ROOT, request.args["file"])  # ruleid: custom.python.path-join-traversal
```

Negative fixture:

```python
target = safe_join(UPLOAD_ROOT, request.args["file"])  # ok: custom.python.path-join-traversal
```

Expected outcome:

- Do not flag `SAST-RULE-01` because the rule maps to a fixture directory.
- Do not flag `SAST-RULE-02` because vulnerable fixture annotations exist.
- Do not flag `SAST-RULE-03` because safe wrapper and canonicalization negative fixtures exist.
- Do not flag `SAST-RULE-04` because expected results are annotated and counted.
- Do not flag `SAST-RULE-05` because the native Semgrep test command runs in CI.
- Do not flag `SAST-RULE-06` because drift handling and owner review are documented.
- Do not flag `SAST-RULE-07` because coverage limits are documented.
- Do not flag `SAST-RULE-08` because suppressions require negative fixture coverage or a ticket.
