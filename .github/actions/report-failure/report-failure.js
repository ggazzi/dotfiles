async function findOrCreateTrackingIssue(github, context, assignee) {
    const issues = await github.rest.issues.listForRepo({
        owner: context.repo.owner,
        repo: context.repo.repo,
        assignee,
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
            title: `Failure Tracker for ${assignee}`,
            body: 'This issue tracks test failures that need attention.',
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

    await github.rest.issues.createComment({
        owner: context.repo.owner,
        repo: context.repo.repo,
        issue_number: trackingIssue.number,
        body: `@${assignee}: Test failure detected at ${now} in [workflow run](${runUrl}).`
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
    // Get inputs
    const assignee = core.getInput('assignee', { required: true });
    
    // Get octokit client
    const token = process.env.GITHUB_TOKEN;
    if (!token) {
      throw new Error('GITHUB_TOKEN environment variable is required');
    }
    
    // Report the error on a tracking issue
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