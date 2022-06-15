# Drone Google Cloud Auth Plugin

A [Drone](https://drone.io) plugin to create [Google Cloud auth](https://cloud.google.com/sdk/gcloud/reference/auth/) config. The plugin also configures the `gcr.io` container registry for docker push and pull.

## Usage

The following settings changes this plugin's behavior.

* google_application_credentials The google cloud service account JSON.
* google_cloud_project The google cloud project to use.
* google_cloud_region (optional) The google cloud region to set as default region.
* registries (optional) An array of Google Cloud container registries to configure for docker authentication. Default `gcr.io`

To use the plugin create a secret file called `.env` with following variables,

```text
google_cloud_project=foo
service_account_json=The JSON string of Service Account JSON
```

__TIP__:  
  You use tools like [jq](https://stedolan.github.io/jq/) to build a single line string of `$GOOGLE_APPLICATION_CREDENTIALS` using the command,

  ```shell
  jq  -r -c . $GOOGLE_APPLICATION_CREDENTIALS
  ````

  Check more details on [GOOGLE_APPLICATION_CREDENTIALS](https://cloud.google.com/docs/authentication/getting-started#setting_the_environment_variable)

Create a `.drone.yml` as shown below and then run the command `drone exec --secret-file=.env`

```yaml
kind: pipeline
type: docker
name: gcloud-auth

steps:

- name: configure gcloud
  image: quay.io/kameshsampath/drone-gcloud-plugin
  pull: if-not-exists
  settings:
    google_application_credentials:
      from_secret: service_account_json
    google_cloud_project:
      from_secret: google_cloud_project
  volumes:
    - name: gcloud-config
      path: /home/dev/.config/gcloud

- name: view the config
  image: quay.io/kameshsampath/drone-gcloud-plugin
  pull: if-not-exists
  commands:
    - gcloud config list
  volumes:
    - name: gcloud-config
      path: /home/dev/.config/gcloud

volumes:
  - name: gcloud-config
    temp: {}
```

Please check the examples folder for `.drone.yml` with other settings.

## Building

Build the plugin image:

```text
./scripts/build.sh
```

## Testing

To use the plugin create a secret file called `.env` with following variables,

```text
google_cloud_project=foo
service_account_json=The JSON string of Service Account JSON
```

```shell
drone exec --secret-file=.env examples/.drone-registries.yml
```