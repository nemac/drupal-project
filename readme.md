
### Directory structure

* **.ebextensions/** - Files run when deploying the application to Elastic Beanstalk
* **docker/** - Files used to build the docker image which runs the webserver.
* **docker/apache2/** - Apache2 config files.
* **docker/my_init.d/** - Scripts to run when the container first starts.
* **drupal-additions/** - Files which are copied into (and overwrite) `www/` upon `composer install`
* **www/** - The webroot in which Drupal is installed.
* **docker-compose.yml/** - Config for running development environment locally.
* **Dockerrun.aws.json/** - Config for running staging and production environments on Elastic Beanstalk.
* **composer.json/** - Dependencies to install via composer.
* **composer.lock/** - Dependencies resolved via composer. Commit this to ensure that Composer doesn't automatically upgrade dependencies in staging/production environments. Run `composer update` in local development environment to rebuild.

### Scripts
* **drun** - Runs the local development environment. (usually preceded by `image-build`)
* **dps** - Lists running docker containers.
* **dlog** - Shows log output from current running app container.
* **image-build** - Build the docker image locally.
* **image-push** - Pushes the docker image to the image repository with the provided tag.
