# Project Plan

## Plan

[Trello Board](https://trello.com/b/rZwGoPsG/zero-to-jupyterhub)

1. Identify all dependencies in the reposotory.
2. Identify and document all docker images required.
3. Identify and document the current deployment flow for the project.
    1. If images are built, where are they stored.
    2. How does Helm Chart access the required images, and how can they be customized.
    3. How is Helm Chart built and where is it stored.
4. Identify where to store docker images (in git repo, or in remote container store).
5. Architect design to migrate from circleci to bitbucket pipelines.
6. One by one, alter docker images to use the Red Hat Universal Base Image 8 as a base image and make sure that they build successfully and run independently.

## Authors

- Will Holtam
