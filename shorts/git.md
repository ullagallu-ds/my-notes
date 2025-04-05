# What is git and why?
is a distributed vcs it track changes of code overtime and it also allows collaboration between developers
- Track changes: Git keeps a history of every change made to files in your project.
- Revert easily: If you mess something up, you can roll back to a previous version.
- Branching & merging: You can create separate branches to work on features or fixes, and then merge them back into the main codebase.
- Collaboration: Developers can work together on the same project without stepping on each other’s toes.

# What is a branch?
It is a copy of another branch where you work seamlessly without messup with some one code you can do experiments if everything working good raise PR to merge of your branch another branch
# Create a new branch
- git branch feature-x
# Switch to that branch
- git checkout feature-x
# Create and switch in one line (shortcut)
- git checkout -b feature-x
# See all branches
- git branch
# Merge branch into main
- git checkout main
- git merge feature-x
# Delete a branch (after merge, for cleanup)
- git branch -d feature-x

# What is merging and Difference between merge and rebase and cherry-pick
- Integrate one branch changes into another branch through PR
**Merge**
- keeps the history of commits of previous branch
**rebase**
- It rewrites history of previous branch commits
**cherry-pick**
- instead of integrating one branch commits into another branch pick the particular commit and merge it









# Chagpt Version
Here you go—same notes, no styling, just plain and clean text for your reference or sharing:

---

# What is Git and Why?

Git is a distributed version control system (VCS). It helps track changes in your code over time and allows multiple developers to collaborate efficiently.

Key Benefits:
- Track Changes: Maintains a history of every change made to files.
- Revert Easily: Go back to any previous version when needed.
- Branching & Merging: Create separate lines of development for features/fixes.
- Collaboration: Work with other developers without conflicts.

---

# What is a Branch?

A branch is a copy of the codebase where you can work independently—test features, fix bugs, or experiment—without affecting the main branch or others’ work.

Once your changes are stable, you can raise a Pull Request (PR) to merge your branch into another (like main).

---

# Common Git Branch Commands

```
# Create a new branch
git branch feature-x

# Switch to that branch
git checkout feature-x

# Create and switch (shortcut)
git checkout -b feature-x

# List all branches
git branch

# Merge branch into main
git checkout main
git merge feature-x

# Delete a branch after merging
git branch -d feature-x
```

---

# Merging vs Rebase vs Cherry-Pick

Merge:
- Combines changes from one branch into another.
- Keeps full commit history (preserves context).

Rebase:
- Moves/rewrites commits from one branch onto another.
- Creates a cleaner, linear history.
- Used when you want to avoid merge commits.

Cherry-Pick:
- Pick a specific commit from one branch and apply it to another.
- Useful when you don’t want the whole branch, just one or a few commits.

Here’s the same explanation with all styling removed — just plain text for easy copy/paste or note-taking:

---

PR stands for Pull Request.

What is a Pull Request?

A pull request is a way to propose changes you've made in a Git branch to be merged into another branch, usually the main or develop branch.

Think of it like saying:  
"Hey, I’ve finished my changes on this branch. Can someone review and approve them before we merge into the main code?"

---

Why Use Pull Requests?

- Code Review: Other team members can check your work.
- Discussion: You can discuss improvements or ask questions.
- Visibility: Everyone can see what’s changing before it's merged.
- Control: Prevents unreviewed or unstable code from entering important branches.

---

Typical PR Workflow:

1. Create a branch  
   `git checkout -b feature-login`

2. Do your work and commit changes  
   `git commit -m "Add login page"`

3. Push the branch to GitHub, GitLab, etc.  
   `git push origin feature-login`

4. Open a PR on the platform  
   - Choose base branch (e.g. main)  
   - Compare your branch (e.g. feature-login)  
   - Add title, description, and reviewers

5. Team reviews, approves, and merges the PR
---