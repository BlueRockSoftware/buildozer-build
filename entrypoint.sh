#!/bin/sh -l

echo $GITHUB_WORKSPACE

orig_user=$(stat -c '%u' $GITHUB_WORKSPACE )
orig_group=$(stat -c '%g' $GITHUB_WORKSPACE )

echo "User ID " $orig_user
echo "Group ID " $orig_group

# set all files to the user buildozer so we can run the build as this user.
chown -R buildozer:buildozer $GITHUB_WORKSPACE

# Workspace
sudo -u buildozer env "PATH=$PATH:/home/buildozer/.local/bin" buildozer android debug
exit_status=$?

# set all files back to previous user
chown -R $orig_user:$orig_group $GITHUB_WORKSPACE

if [ $exit_status -eq 0 ]; then
    echo "Build completed successfully"
    exit 0
else
    echo "Build failed!"
    exit 1
fi
