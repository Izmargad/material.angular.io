#!/bin/bash

#
# Script that fetches material2 assets from the material2-docs-content repo.
#

cd $(dirname ${0})/../

# Default publish branch that is associated to the currently installed Angular Material
# version.
defaultPublishBranch=$(node ./tools/print-publish-branch)

# Branch on the docs-content repository that includes the docs assets. The branch can
# be specified because in some situations we do not always want the docs content that
# is associated with the currently installed version of Material.
docsContentBranch=${1:-${defaultPublishBranch}}

# Directory where documentation assets should be copied to (overviews, api docs)
documentsDestination=./src/assets/documents/

# Directory where the live example assets will be copied to.
examplesDestination=./src/assets/

# Path to the directory where the Stackblitz examples should be copied to.
stackblitzDestination=./src/assets/stackblitz/

# Path to the @angular/material-examples package in the node modules.
materialExamplesDestination=./node_modules/@angular/material-examples

# Git HTTP clone URL for the material2-docs-content repository.
docsContentRepoUrl="https://github.com/angular/material2-docs-content"

# Path to the directory where the docs-content will be cloned.
docsContentPath=/tmp/material2-docs-content

# Create all necessary directories if they don't exist.
mkdir -p ${documentsDestination}
mkdir -p ${examplesDestination}
mkdir -p ${stackblitzDestination}
mkdir -p ${materialExamplesDestination}

# Remove previous repository if directory is present.
rm -Rf ${docsContentPath}

echo "Pulling docs-content assets for the branch: ${docsContentBranch}."

# Clone the docs-content repository.
git clone ${docsContentRepoUrl} ${docsContentPath} --depth 1 --branch ${docsContentBranch}

# Copy all document assets (API, overview and guides).
cp -R ${docsContentPath}/api ${documentsDestination}
cp -R ${docsContentPath}/overview ${documentsDestination}
cp -R ${docsContentPath}/guides ${documentsDestination}

# Copy the example assets to the docs.
cp -R ${docsContentPath}/examples ${examplesDestination}

# Copy the StackBlitz examples to the docs.
cp -R ${docsContentPath}/stackblitz/examples ${stackblitzDestination}

# Manually install the @angular/material-examples package from the docs-content.
cp -R ${docsContentPath}/examples-package/* ${materialExamplesDestination}
