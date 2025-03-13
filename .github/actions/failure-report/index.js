const core = require('@actions/core');
const github = require('@actions/github');

async function findOrCreateTrackingIssue(octokit, context, assignee) {
    const issues = await octokit.rest.issues.listForRepo({
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
        const newIssue = await octokit.rest.issues.create({
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

async function reportFailureAsComment(octokit, context, assignee, trackingIssue) {
    const now = new Date().toISOString();
    const runUrl = `${context.serverUrl}/${context.repo.owner}/${context.repo.repo}/actions/runs/${context.runId}`;

    await octokit.rest.issues.createComment({
        owner: context.repo.owner,
        repo: context.repo.repo,
        issue_number: trackingIssue.number,
        body: `@${assignee}: Test failure detected at ${now} in [workflow run](${runUrl}).`
    });
    console.log(`Added failure report to issue #${trackingIssue.number}`);
}

async function run() {
  try {
    // Get inputs
    const assignee = core.getInput('assignee', { required: true });
    
    // Get octokit client
    const token = process.env.GITHUB_TOKEN;
    if (!token) {
      throw new Error('GITHUB_TOKEN environment variable is required');
    }
    
    const octokit = github.getOctokit(token);
    const context = github.context;
    
    // Report the error on a tracking issue
    const trackingIssue = await findOrCreateTrackingIssue(octokit, context, assignee);
    if (!trackingIssue) return;
    reportFailureAsComment(octokit, context, assignee, trackingIssue);
    
    // Set the issue number as output
    core.setOutput('issue-number', trackingIssue.number);
  } catch (error) {
    core.setFailed(error.message);
  }
}

run();
