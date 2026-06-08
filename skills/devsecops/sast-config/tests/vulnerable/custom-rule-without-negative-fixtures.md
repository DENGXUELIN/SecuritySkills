# Vulnerable: Custom SAST rule accepted without negative fixtures

This fixture should produce custom rule regression evidence findings.

## Review Context

- Tool: Semgrep
- Rule ID: `custom.python.path-join-traversal`
- Rule file: `.semgrep/custom/path-traversal.yml`
- Language: Python
- Claimed purpose: flag user-controlled path joins that can escape the upload directory
- CI command: `semgrep --config .semgrep/custom/path-traversal.yml app/`

## Evidence Provided

The team provides one production finding and a screenshot showing the rule fired once. The rule parses and the CI job reports findings.

## Missing Regression Evidence

| Requirement | Status |
|---|---|
| Rule-to-test mapping | no `tests/` directory for `custom.python.path-join-traversal` |
| Positive fixtures | one screenshot only; no committed vulnerable sample with expected result |
| Negative fixtures | none for `safe_join`, canonicalization, allowlisted filenames, or framework upload helpers |
| Expected annotations | no `# ruleid` / `# ok` annotations and no expected result count |
| Regression command | CI runs against production code only, not rule fixtures |
| Drift handling | no owner or metric when false positives increase |
| Coverage limits | no note that URL paths, Windows paths, and archive extraction are out of scope |
| Suppression evidence | two `nosemgrep` comments were added after noise, but no safe fixture explains them |

## Failure Scenario

A later pattern broadening flags safe wrapper calls:

```python
safe_path = safe_join(UPLOAD_ROOT, user_filename)
write_upload(safe_path, stream)
```

Because there is no negative fixture, the false positive ships and developers start adding broad suppressions. Another later edit stops matching the original `os.path.join(base, request.args["file"])` shape, but there is no positive regression test to fail.

Expected findings:

- `SAST-RULE-01` because no mapped fixture directory exists.
- `SAST-RULE-02` because there is no committed positive fixture.
- `SAST-RULE-03` because safe wrapper and sanitizer negative fixtures are missing.
- `SAST-RULE-04` because expected results are not annotated.
- `SAST-RULE-05` because no fixture regression command is wired to CI or local review.
- `SAST-RULE-06` because false-positive and false-negative drift are not controlled.
- `SAST-RULE-07` because coverage limits are absent.
- `SAST-RULE-08` because suppressions were added without negative fixtures.

Expected handling: require rule fixtures before trusting the custom rule, add `semgrep --test` or equivalent CI coverage, document unsupported patterns, and map every suppression to a negative fixture or ticket.
