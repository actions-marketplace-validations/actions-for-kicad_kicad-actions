# Release procedure

Within this document the release procedure is noted down for creating a new release.

> Note: only do this from the main branch.

1. Create a new tag by running the following command.

```sh
git tag vX.X
```

2. Push all tags by running the following command.

```sh
git push origin tag vX.X
```

Where `X.X` is the version in both commands, for example `1.0`.
