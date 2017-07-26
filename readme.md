NEMAC Drupal Project
----------------------

This project provides scaffolding to build a containerized Drupal webserver.


### Directory structure

* **.ebextensions/** - Files run when deploying the application to Elastic Beanstalk
* **docker/** - Files used to build the docker image which runs the webserver.
* **docker/httpd/** - Apache2 config files.
* **docker/service/** - Services to run and monitor in the container.
* **docker/my_init.d/** - Scripts to run when the container first starts.
* **web/** - The webroot in which Drupal is installed.
* **docker-compose.yml/** - Config for running development environment locally.
* **Dockerrun.aws.json/** - Config for running staging and production environments on Elastic Beanstalk.
* **composer.json/** - Dependencies to install via composer.
* **composer.lock/** - Dependencies resolved via composer. Commit this to ensure that Composer doesn't automatically upgrade dependencies in staging/production environments. Run `composer update` in local development environment to rebuild.

### Webserver Stack Overview
- Orchestration: CloudFormation
- Version Control: Git
- Deployment: Codepipeline
- Environment manager: Elastic Beanstalk 
  - Instance: EC2 (Amazon Linux)
    - Application Docker container (image built from `/docker`)
      - OS: Centos 7
        - Runtimes: 
          - Apache 2.4.6 
          - PHP 7.1 (fpm)
          - Python 2.7.5 (built into Centos 7)
        - Services: 
          - Drupal
            - Static Asset Offloading: s3 / Drupal s3fs
            - Dependency management: Composer
          - Cron
            - Certbot for registering/renewal of SSL Certs
            - Drupal Cronjobs
- Monitoring/logging locations:
  - Instance: 
    - Monitoring: Elastic Beanstalk / EC2
    - Logging: /var/logs (Enable log streaming via Elastic Beanstalk for debugging/archival purposes)
  - Container: ECS
  - Database: RDS

## Local Development

### Setup

### Usage

### Configuration
The below environment variables may be configured in `docker-compose.yml`(for dev environment), `Dockerrun.aws.json`(for staging and production), and/or via the Elastic Beanstalk environment configuration. Elastic Beanstalk environment variables overwrite those defined in `Dockerrun.aws.json`, using this you can change variables on a running environment without pushing new code.

 Name | Type | Description
 :--- | :--- | :---
PRIMARY_DOMAIN | Hostname | The primary domain name for this environment. Ex: 'some.project.com' 
ALTERNATE_DOMAINS | Hostnames | Additional domain names/CNAMES for which https certificates should be registered (comma-seperated).
ADMIN_EMAIL | Email | The email used to register ssl certs. May receive ssl cert expiry notices.
SECRETS_STORE | S3 bucket/prefix | The S3 bucket and prefix in which the secrets for this environment are stored. Ex: 's3://nemac-secrets/staging-some-project-com/')
ASSET_STORE | S3 bucket/prefix | The S3 bucket and prefix in which the assets for this environment are stored. Ex: 's3://nemac-assets-us-east-1/some-project-com/')
ENABLE_HTTPS | true\|false | Enables https and certbot.
FORCE_HTTPS | true\|false | Enables http redirect (301) to https and turns on HSTS.
ENABLE_DEBUGGING | true\|false | Enables error printing, xdebug, and more. Do not enable in production. See: [debugging](#debugging).
XDEBUG_REMOTE_HOST|IP|IP that XDEBUG should connect to. For dev environment this will be the ip of the docker-machine, for staging it will be `127.0.0.1` and ssh port forwarding should be used. Do not enable in production.


## Local Development


Add `127.0.0.1 PRIMARY_DOMAIN` to your hosts for local development.

### Setup
<!-- TODO document docker setup on OSX -->


### Utility Commands
Run `source commands.sh` to load utility commands.

**Image management commands:**
  **build-image** - Build the docker image for local use.
  **pull-image** - Pull the docker image from ECR for local use.
  **push-image** - Pushes current local development image to AWS ECR repository with the specified version tag.
  
**Local development container commands:**
  **drun** - List Docker containers.
  **dps** - List running Docker containers.
  **dbash** - Open a terminal in running app container.
  **dlog** - View running app container's stdout output.
  **dtail** - Follow running app container's stdout output.
  **alog** - View running app container's apache2 error log.
  **atail** - Follow running app container's error log.
  
**Utility commands:**
  **drush** - Runs \`drush\` in running app container.
  **composer** - Runs \`composer\` in running app container.
  **sql-dump** - Runs \`drush sql-dump\` in running app container.
  **sql-import** - Imports sql dump from file using drush.

### <span id="debugging"></span> Debugging
Setting `ENABLE_DEBUGGING` in `docker-compose.yml` (for local), `Dockerrun.aws.json` (for all remotes), or using CloudFormation (for a specific stack) will turn on XDEBUG (for which you will need a debugging client)

### SSH
Adding your public key in `.ebextensions/keys.config` where indicated will allow you to ssh into instances using `ssh ec2-user@instancehostname`. Once connected, logs can be found in `/var/log/`, deployed application source is visible at `/var/app/current/` and running `dbash` will get you an interactive terminal in the current running app container. `dps` gives some stats on how long it has been running. If no container is running `dps` will show only the "ecs-agent" container, at which point logs from failed containers can be found in `/var/log/containers`.

### Gotchas

- If you encounter errors about files not existing in `/vendor`, destroy it, then re-run `drun` as this indicates a failed composer install.
- Because multiple projects are using the same docker image repository, changes for a single project should be pushed with a prefix for that project (Ex: `cohesivefire-1.04`) and `Dockerrun.aws.json` should be updated to use that image.

### Further Reading:
[Drupal w/ Composer project docs](https://github.com/drupal-composer/drupal-project)
[Composer Docs](https://getcomposer.org/doc/)
[Drush commands](https://drushcommands.com/drush-8x/)
[Workflow for configuration sync between environments using the web interface](https://www.drupal.org/node/2416545)
[Workflow for configuration sync between environments using git](http://nuvole.org/blog/2014/aug/20/git-workflow-managing-drupal-8-configuration)

# TODO register ssl cert renewal CRON
# TODO encrypt hash salts using KMS
# TODO encrypt ssl certs using KMS data keys
