
#!/bin/bash

# Docker image name
IMAGE_NAME="php74-lint"

# Docker build
echo "Building Docker image..."
docker build -t ${IMAGE_NAME} .

# Check if the build was successful
if [ $? -eq 0 ]; then
    echo "Docker image was built successfully!"
else
    echo "Docker build failed. Please check the error message above."
    exit 1
fi

# Symlink
echo "Creating symlink..."

# Destination of the symlink
SYMLINK_DEST="$HOME/.local/bin/phplint"

# Check if the destination directory exists
if [ ! -d $(dirname ${SYMLINK_DEST}) ]; then
    mkdir -p $(dirname ${SYMLINK_DEST})
fi

# Check if the symlink already exists
if [ -L ${SYMLINK_DEST} ]; then
    echo "Symlink already exists. Overriding it..."
    rm ${SYMLINK_DEST}
fi

# Source of the symlink (phplint script)
SYMLINK_SRC=$(realpath ./phplint)

# Create the symlink
ln -s ${SYMLINK_SRC} ${SYMLINK_DEST}

# Check if the symlink was created successfully
if [ $? -eq 0 ]; then
    echo "Symlink was created successfully!"
else
    echo "Symlink creation failed. Please check the error message above."
    exit 1
fi

echo "Installation completed successfully!"
