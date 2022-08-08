# Drone GitHub Release Please

A [Drone](https://drone.io) plugin to perform releases using [release-please](https://github.com/googleapis/release-please).

## Usage

The following settings changes this plugin's behavior.

| Option | Type | Description |
| ------ | ---- | ----------- |
| `token` | string |REQUIRED. GitHub token with repo write permissions |
| `repo_url` | string | GitHub repository in the format of `<owner>/<repo>`. Defaults `$DRONE_REPO` |
| `api_url` | string | Base URI for making REST API requests. Defaults to `https://api.github.com` |
| `graphql_url` | string | Base URI for making GraphQL requests. Defaults to `https://api.github.com` |
| `target_branch` | string |The branch to open release PRs against and tag releases on. Defaults to the default branch of the repository |
| `dry_run` | boolean | If set, reports the activity that would happen without taking effect |
| `debug` | boolean | If set, sets log level to >=DEBUG |
| `trace` | boolean | If set, sets log level to >=TRACE |
| `extra_options` | string | The extra options to pass to the as described here [without-a-manifest-config](https://github.com/googleapis/release-please/blob/main/docs/cli.md#without-a-manifest-config) |

```yaml
kind: pipeline
type: docker
name: default

steps:

- name: configure gcloud
  image: docker.io/kameshsampath/drone-release-please
  settings:
    GITHUB_TOKEN:
      from_secret: my_gh_pat
    extra_options: >-
      --release-type=simple
      --bump-patch-for-minor-pre-major=true
  pull: if-not-exists
```

Please check the examples folder for `.drone.yml` with other settings.

## Building

Run the following command to build and push the image manually

```text
./scripts/build.sh
```

## Testing

__TODO__: Add examples
