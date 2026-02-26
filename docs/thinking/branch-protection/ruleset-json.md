# Branch Protection: Ruleset JSON

This is a direct export of the active branch protection ruleset for `main`. If the prose and JSON diverge, the JSON wins.

## Update Policy

- Update this file only when the ruleset itself changes
- Export from GitHub and replace the JSON block
- Keep this as the authoritative reference

```json
{
    "id": 12555375,
    "name": "protect-main",
    "target": "branch",
    "source_type": "Repository",
    "source": "HYP3R00T/gitops-deployment-platform",
    "enforcement": "active",
    "conditions": {
        "ref_name": {
            "exclude": [],
            "include": ["~DEFAULT_BRANCH"]
        }
    },
    "rules": [
        {
            "type": "deletion"
        },
        {
            "type": "non_fast_forward"
        },
        {
            "type": "pull_request",
            "parameters": {
                "required_approving_review_count": 0,
                "dismiss_stale_reviews_on_push": true,
                "required_reviewers": [],
                "require_code_owner_review": true,
                "require_last_push_approval": false,
                "required_review_thread_resolution": true,
                "allowed_merge_methods": ["merge", "squash"]
            }
        }
    ],
    "bypass_actors": []
}
```
