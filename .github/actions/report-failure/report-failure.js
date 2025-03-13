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

    core.setFailed(`Found ${issues.data.length} failure tracker issues for ${assignee}, expected at most one.`);
    for (const issue of issues.data) {
        console.error(`Issue #${issue.number}: ${issue.title}`);
    }
    return null;
}

async function reportFailureAsComment(github, context, assignee, trackingIssue) {
    const now = new Date().toISOString();
    const runUrl = `${context.serverUrl}/${context.repo.owner}/${context.repo.repo}/actions/runs/${context.runId}`;

    const body = `@${assignee}: Test failure detected at ${now} in [workflow run](${runUrl}).

<details>
<summary>Failure Details</summary>

Here we'll include a log of the tests that were run, or some other details.
</details>
`;

    await github.rest.issues.createComment({
        owner: context.repo.owner,
        repo: context.repo.repo,
        issue_number: trackingIssue.number,
        body,
    });
    console.log(`Added failure report to issue #${trackingIssue.number}`);
}

/**
 * Report a test failure to a tracking issue
 * 
 * @param {Context} context Workflow context 
 * @param {"@actions/core"} core @actions/core
 * @param {Octokit} github Octokit instance 
 * @param {string} assignee GitHub user or group that should be notified to the issue.
 * @returns {Promise<number>} The issue number of the tracking issue that was created or edited.
 */
async function reportTestFailure({ context, core, github }, assignee) {
  try {
    const trackingIssue = await findOrCreateTrackingIssue(github, context, assignee);
    if (!trackingIssue) {
        core.setFailed('Failed to find or create tracking issue');
        return;
    }
    reportFailureAsComment(github, context, assignee, trackingIssue);
    
    // Set the issue number as output
    return trackingIssue.number;
  } catch (error) {
    core.setFailed(error.message);
  }
}

module.exports = reportTestFailure;