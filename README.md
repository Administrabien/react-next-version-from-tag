# react-next-version-from-tag


This GitHub action initially gets the version from the repository's package.json file. To determine the next version, if it has already obtained the version (i.e., it's not the first time it's run), it gets the version from the tags and then determines the new version.