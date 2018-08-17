Command line workflow
---------------------

git clone http://your.username/github.com/scm/dev/reponame.git
git checkout $branchName
-b to create new branch
(assuming some time passes) git pull
git add filename(s)
git commit -m "message"
git push
-u origin $branchName if this is the first push
git checkout master
git merge $branchName
git push

Useful One off Commands
-----------------------
To abort a failed merge
`git merge --abort`

To reset last commit
`git reset HEAD^`

To reset all commits
`git reset --hard origin/master`

To see the differences between branches
`git diff origin/master`

To unstage commit
`git reset $filename`

To undo modifications to a file
`git checkout – $filename`

To stage all files
`git add -A .`

To find all commits that added or removed searchstring
`git log -S searchstring --source --all`

To find last modified date for file
`git log -1 --format="%ad" -- path/to/file`
 
To update git index - eg after updating gitignore
`git update-index`


To generate a commit to revert a commit thats already pushed
`git revert $commit_hash`
`git push`

You have not concluded your merge (MERGE_HEAD exists).
`git merge --abort`
Resolve the conflict.
`git pull`

To sync a fork
`git fetch master`
`git checkout master`
`git merge upstream/master`

To disable certificate validation
`git config --global http.sslVerify false`
