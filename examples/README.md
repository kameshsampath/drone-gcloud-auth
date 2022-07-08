# Examples

The folder has few Drone pipeline examples. All the examples requires you to have a secret file with the following contents

```shell
google_cloud_project=<the google cloud project to use>
service_account_json=<the google cloud service account JSON>
service_image_name=<the fully qualified image name to push to GCR>
```

Once you create this file run the drone pipeline using the command,

```shell
drone exec --secret-file <your secret file>
```

__TIP__:  
  You use tools like [jq](https://stedolan.github.io/jq/) to build a single line string of `$GOOGLE_APPLICATION_CREDENTIALS` using the command,

  ```shell
  jq  -r -c . $GOOGLE_APPLICATION_CREDENTIALS
  ````
