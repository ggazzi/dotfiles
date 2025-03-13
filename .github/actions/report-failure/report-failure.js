async function findOrCreateTrackingIssue(github, context, assignee) {
    const issues = await github.rest.issues.listForRepo({
        owner: context.repo.owner,
        repo: context.repo.repo,
        labels: 'failure-tracker',
    });

    if (issues.data.length === 1) {
        const issue = issues.data[0];
        console.log(`Found tracking issue #${issue.number}: ${issue.title}`);
        return issue;
    }

    if (issues.data.length === 0) {
        const newIssue = await github.rest.issues.create({
            owner: context.repo.owner,
            repo: context.repo.repo,
            title: `Test Failures for ${assignee}`,
            body: 'This issue tracks test failures from scenarios owned by @${assignee} (exclusively or shared).',
            assignees: [assignee],
            labels: ['failure-tracker', 'bug'],
        });
        console.log(`Created tracking issue #${newIssue.data.number}`);
        return newIssue.data;
    }

    console.error(`Found ${issues.data.length} failure tracker issues for ${assignee}, expected at most one.`);
    for (const issue of issues.data) {
        console.error(`Issue #${issue.number}: ${issue.title}`);
    }
    return null;
}

function prepareCommentBody(context, owner, scenario, testOutput) {
    return `@${owner}: scenario "${scenario}" failed.

<details>
<summary>Failure Details</summary>

Standard Output:
\`\`\`
${testOutput}
\`\`\`
</details>
`;
}

/**
 * Report a test failure to a tracking issue
 * 
 * @param {Context} context Workflow context 
 * @param {"@actions/core"} core @actions/core
 * @param {Octokit} github Octokit instance 
 * @param {string[]} owners GitHub users or groups that should be notified to the issue.
 * @param {string} scenario Name of the scenario that failed.
 * @param {string} testOutput The output of the test that failed.
 */
async function reportTestFailure({ context, core, github }, owners, scenario, testOutput) {
  try {
    const commentBody = prepareCommentBody(context, owners, scenario, testOutput);

    for (const owner of owners) {
        const trackingIssue = await findOrCreateTrackingIssue(github, context, owner);
        if (!trackingIssue) {
            core.setFailed('Failed to find or create tracking issue');
            return;
        }
        await github.rest.issues.createComment({
            owner: context.repo.owner,
            repo: context.repo.repo,
            issue_number: trackingIssue.number,
            body: commentBody,
        });
        console.log(`Added failure report to issue #${trackingIssue.number}`);
    }
  } catch (error) {
    core.setFailed(error.message);
  }
}

module.exports = reportTestFailure;