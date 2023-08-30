#!/bin/bash

set -euxo pipefail

ORGANIZATION=pmpaulino
BASE_REPO_NAME=test_repo
BASE_BRANCH=main
BRANCH_NAME=test_branch

function build_up {
    echo "Building up..."
    repo_name="$BASE_REPO_NAME"_"$repo_index"
    
    # Step 1
    # Create a repository
    gh repo create $ORGANIZATION/$repo_name --clone --public --add-readme

    # Change directory to the new repository
    cd $repo_name

    # Change name of the master branch to main
    git branch -m $BASE_BRANCH
    git pull origin $BASE_BRANCH
    git branch --set-upstream-to=origin/$BASE_BRANCH

    # Make a few commits
    for i in {1..3}; do
        echo "Test $i" > file$i.txt
        git add file$i.txt
        git commit -m "Test commit $i"
    done
    git push origin $BASE_BRANCH

    # Create a new branch and make commits on it
    git checkout -b $BRANCH_NAME
    for i in {4..6}; do
        echo "Test $i" > file$i.txt
        git add file$i.txt
        git commit -m "Test commit $i on new branch"
    done

    # Push the branch to GitHub
    git push origin $BRANCH_NAME

    # Create a pull request from the new branch
    gh pr create --base $BASE_BRANCH --head $BRANCH_NAME --title "Test PR" --body "This is a test PR"
    
    cd ..
}

function close_prs {
    
    repo_name="$BASE_REPO_NAME"_"$repo_index"

    cd $repo_name

    # Step 2
    # Get PR number
    PR_NUMBER=$(gh pr list | grep "Test PR" | cut -f1)

    # Close the pull request
    gh pr close $PR_NUMBER --delete-branch

    cd ..
}

function create_new_branches_prs {
    repo_name="$BASE_REPO_NAME"_"$repo_index"
    cd $repo_name
    
    # Step 3
    # Create a new branch and make commits on it
    git checkout -b $BRANCH_NAME"_new"
    for i in {7..9}; do
        echo "Test $i" > file$i.txt
        git add file$i.txt
        git commit -m "Test commit $i on new branch"
    done

    # Push the branch to GitHub
    git push origin $BRANCH_NAME"_new"

    # Create a pull request from the new branch
    gh pr create --base $BASE_BRANCH --head $BRANCH_NAME"_new" --title "Test PR 2" --body "This is a test PR 2"
    
    cd ..
}

function tear_down {
    repo_name="$BASE_REPO_NAME"_"$repo_index"

    # Step 4
    # Delete repository
    /opt/homebrew/Cellar/gh/2.32.1/bin/gh repo delete $ORGANIZATION/$repo_name --yes
    rm -rf $repo_name
}


for repo_index in {1..3}; do
    build_up
done

# Wait for user input
# echo "Press any key to close prs..."
# read -n1
sleep 60

for repo_index in {1..3}; do
    close_prs
done

# Wait for user input
# echo "Press any key to create new branches and prs..."
# read -n1
sleep 60

for repo_index in {1..3}; do
    create_new_branches_prs
done

# Wait for user input
# echo "Press any key to tear down these demo repos..."
# read -n1
sleep 60

for repo_index in {1..3}; do
    tear_down
done
