const execSync = require('child_process').execSync;

// Read the FROM and TO values from the environment
const from = process.env.FROM;
const to = process.env.TO || 'HEAD';

// Fetch all commits in the provided range
const output = execSync(
  `git log --no-merges ${from}..${to} --format='%s|%aN'`,
  {
    encoding: 'utf-8',
  }
);

// The commit messages and authors are separated by "|". Split by newline first, then each line by "|"
const commits = output
  .split('\n')
  .filter(Boolean)
  .map((line) => {
    const [message, author] = line.split('|');
    return { message, author };
  });

// Extract unique authors
const authors = [...new Set(commits.map((commit) => commit.author))];

// Format the list of commit messages with authors
const formattedList = commits
  .map((commit) => `- ${commit.message} (@${commit.author})`)
  .join('\n');

// Print the commit messages and authors
console.log(`
Here are the commit messages with contributors:

${formattedList}

And the full list of contributors:

${authors.join(', ')}
`);
