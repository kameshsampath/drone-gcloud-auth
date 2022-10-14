# Drone Google Cloud Auth Plugin

A [Drone](https://drone.io) plugin to create [Google Cloud auth](https://cloud.google.com/sdk/gcloud/reference/auth/) config. The plugin also configures the [Artifact registry](https://cloud.google.com/artifact-registry/docs) for docker push and pull.

>**DEPRECATION:** The plugin does not configure Container Registry anymore in support for [Artifact registry](https://cloud.google.com/artifact-registry/docs)

## Usage

The following settings changes this plugin's behavior.

* `google_application_credentials`: The google cloud service account JSON.
* `google_cloud_project`: The google cloud project to use.
* `google_cloud_region (optional)`: The google cloud region to set as default region. If provided the Artifact Registry for Docker will be enabled in these regions.
* `registry_locations (optional)`: An array of Google Cloud Artifact registry locations to configure for docker authentication.
  
> **TIP**: To list the regions use the `gcloud compute regions list`

To use the plugin create a secret file called `.env` with following variables,

```text
google_cloud_project=foo
service_account_json=The JSON string of Service Account JSON
```

> TIP:  
>
> You use tools like [jq](https://stedolan.github.io/jq/) to build a single line string of `$GOOGLE_APPLICATION_CREDENTIALS` using the command,
>
>  ```shell
>  jq  -r -c . $GOOGLE_APPLICATION_CREDENTIALS
>  ````
>
> Check more details on [GOOGLE_APPLICATION_CREDENTIALS](https://cloud.google.com/docs/authentication getting-started#setting_the_environment_variable)

Create a `.drone.yml` as shown below and then run the command `drone exec --secret-file=.env`

```yaml
kind: pipeline
type: docker
name: gcloud-auth

steps:

- name: configure gcloud
  image: docker.io/kameshsampath/drone-gcloud-auth
  pull: if-not-exists
  settings:
    google_application_credentials:
      from_secret: service_account_json
    google_cloud_project:
      from_secret: google_cloud_project
    registry_locations:
      - asia-south1
      - us-centra1
  volumes:
    - name: gcloud-config
      path: /root/.config/gcloud

- name: view the config
  image: quay.io/kameshsampath/drone-gcloud-auth
  pull: if-not-exists
  commands:
    - gcloud config list
  volumes:
    - name: gcloud-config
      path: /root/.config/gcloud

volumes:
  - name: gcloud-config
    temp: {}
```

Please check the examples folder for `.drone.yml` with other settings.

## Building

Run the following command to build and push the image manually

```text
./scripts/build.sh
```

## Testing

```shell
export SA_JSON=$(cat <your google application cred json> | jq -r -c '.')
```

```shell
docker run --rm \
  -e PLUGIN_GOOGLE_CLOUD_PROJECT=$PLUGIN_GOOGLE_CLOUD_PROJECT \
  -e PLUGIN_GOOGLE_APPLICATION_CREDENTIALS="$SA_JSON" \
  -e PLUGIN_GOOGLE_CLOUD_REGION=us-central1 \
  kameshsampath/drone-gcloud-auth
```
