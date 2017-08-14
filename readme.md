NEMAC Drupal Project
----------------------

This project provides scaffolding to build a containerized Drupal webserver.


## Directory structure

* **.ebextensions/** - Files run when deploying the application to Elastic Beanstalk
* **docker/** - Files used to build the docker image which runs the webserver.
* **docker/httpd/** - Apache2 config files.
* **docker/service/** - Services to run and monitor in the container.
* **docker/my_init.d/** - Scripts to run when the container first starts.
* **web/** - The webroot in which Drupal is installed.
* **docker-compose.yml/** - Config for running development environment locally.
* **Dockerrun.aws.json/** - Config for running environments on Elastic Beanstalk.
* **commands.sh/** - Utility commands script. Load using `source commands.sh`.
* **composer.json/** - Dependencies to install via composer.
* **composer.lock/** - Dependencies resolved via composer. Commit this to ensure that Composer doesn't automatically upgrade dependencies in staging/production environments. Run `composer update` in local development environment to rebuild.

## Webserver Stack Overview
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
          - Python 2.7.5 (packaged with Centos 7)
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
XDEBUG_REMOTE_HOST|IP|IP that XDEBUG should connect to. For dev environment this will be the ip of the docker-machine, for staging it will be `127.0.0.1` and ssh port forwarding should be used.

## Local Development
This requires your AWS user to be in the `cfn-developers` or `cfn-admins` IAM group.

### Setup for OSX
1. Install [Docker Toolbox for OSX](https://docs.docker.com/toolbox/toolbox_install_mac/)
2. Install [Git](https://git-scm.com/downloads)
3. Install [the AWS Command Line Interface](https://docs.aws.amazon.com/cli/latest/userguide/cli-install-macos.html), then use `aws configure` to set your aws credentials.

### Setup for PC
(Requires Windows 10 Creators Update and beyond)
1. Install [Docker Toolbox for Windows](https://docs.docker.com/toolbox/toolbox_install_windows/).
2. Run the "Docker Quickstart Terminal". Close it once it reports the docker machine is running.
3. Install Windows Subsystem for Linux (aka Bash on Windows), then using Bash run [this script](https://gist.github.com/jwilson8767/00a46f5ca63327d5bfd802f87b702c8d) to setup the docker client.
4. Install and configure the AWS CLI (and git) using `sudo apt-get install -y python git && sudp pip install --upgrade awscli` followed by `aws configure` to set your aws credentials.
5. Your local dev environment should now be set up. From now on always use Bash when interacting with this project.

### Local Dev Environment Usage

#### Starting the environment
1. Run `source commands.sh` to load utility commands.
2. Run `drun` to start the containers (app and database). 
3. (optional) Use `dtail` to view the startup progress. When startup has finished (first startup can take up to 5 minutes, subsequent startups as little as 10 seconds) exit dtail by pressing Ctrl+C.  
4. This project should now be available at [http://localhost/](http://localhost/), or [http://192.168.99.100/](http://192.168.99.100/) if you're on Windows.
5. If this is a brand new project with no database you may need to visit [http://localhost/install.php](http://localhost/install.php) to configure Drupal for the first time.

Note: Container ports for local dev environment may be changed in `docker-compose.yml`.

#### Stopping the environment 
To stop the environment run `drun stop`. To destroy the environment run `drun down`. To also destroy the database run `drun down -v`

#### Running commands on the app container
`drush`, `composer`, `sql-dump`, and `sql-import` may all be run from your terminal directly. Any more advanced operations require using `dbash` to start an interactive session. Note that by default you will be logged in as root, use `su -sE /bin/bash apache` to switch to the web server user. In the container the project directory is mapped to `/app` for convenience .

#### Utility Commands
Run `source commands.sh` to load utility commands. Some of these commands are also available in Elastic Beanstalk instances.

**Image management commands:**
  **build-image** - Build the docker image for local use.
  **pull-image** - Pull the docker image from ECR for local use.
  **push-image** - Pushes current local development image to AWS ECR repository with the specified version tag.
  
**Local development container commands:**
  **drun** - Runs docker-compose to start the local development environment.
    drun stop - Stops the running dev environment.
    drun down - Remove running dev environment (Add "-v" to also remove data from database/composer cache)
  **dps** - List running Docker containers.
  **dbash** - Open a terminal in running app container.
  **dlog** - View running app container's stdout output.
  **dtail** - Follow running app container's stdout output.
  
**Utility commands:**
  **drush** - Runs \`drush\` in running app container.
  **composer** - Runs \`composer\` in running app container.
  **sql-dump** - Runs \`drush sql-dump\` in running app container.
  **sql-import** - Imports sql dump from file using drush.

#### SSH
Adding your public key in `.ebextensions/keys.config` where indicated will allow you to ssh into instances using `ssh ec2-user@instancehostname`. Once connected, logs can be found in `/var/log/`, deployed application source is visible at `/var/app/current/` and running `dbash` will get you an interactive terminal in the current running app container. `dps` gives some stats on how long it has been running. If no container is running `dps` will show only the "ecs-agent" container, at which point logs from failed containers can be found in `/var/log/containers`.

#### <span id="debugging"></span> Debugging
Setting `ENABLE_DEBUGGING` in `docker-compose.yml` (for local), `Dockerrun.aws.json` (for all remotes), or using CloudFormation (for a specific stack) will turn on XDEBUG (for which you will need a debugging client)

## Deploying project to a remote Elastic Beanstalk environment.

## Managing Drupal across multiple environments (local and remote)
### Committing Changes
1. minor code changes (especially to custom modules and themes) -> commit.
1. fundamental database changes -> dump database and deploy to a new remote environment.
1. Minor content changes -> export content as Features, commit Features -> apply Features in remote environment using GUI.
1. Adding/removing modules -> Install using Composer if possible, commit composer.json and composer.lock -> enable module in remote environment using GUI.
1. Configuration changes (Drupal 8 only) -> export config to sync folder and commit relevant files -> import config in remote environment using GUI.
### Migrating an existing Drupal 7 site.
### Migrating an existing site (D7 to D7)
1. Identify the site’s directory on the existing server, database name, url, and git repository (create git repository if none already exists)
2. Backup the site’s drupal root directory using `tar czf <sitename>.tgz sitedirectory`
3. Dump the site’s database using `mysqldump --default-character-set=utf8 --databases sitedatabasename --protocol=tcp  --compress=TRUE --skip-extended-insert --skip-create --no-create-db --dump-date=FALSE --skip-triggers --quick > <sitename>.sql`
4. Move the backup tar and sql files to your development machine. (using scp this would be something like `scp username@server:/path/to/sitename.tgz ./` on your local machine.)
5. Untar the project source into a new project directory using `tar xzf sitename.tgz`.
6. Move the contents of the old drupal root directory to `newprojectdir/web/`. Delete the (now empty) `project/html` folder.
7. Copy the sql dump file to `newprojectdir/sql/` and rename to "dump_00.sql" (only files matching the pattern "dump_*.sql" will be imported later).
8. Use `drun && dtail` to watch as the database is imported and the webserver is started. 
9. Checking [http://localhost/](http://localhost/) should show the site perfectly at this point.
10. Configure the asset bucket the project should use in `docker-compose.yml` and `Dockerrun.aws.json`
11. Turn on asset offloading by running <!-- TODO asset offload import command sequence -->
 
### HTTPS / HSTS
1. Set `PRIMARY_DOMAIN`, `ALTERNATE_DOMAINS` (optional), and `ADMIN_EMAIL` in Dockerrun.aws.json and (optionally) when deploying to Elastic Beanstalk.
2. Route any of those domains to the environment. When the environment detects that it is the target of those domains it will use Certbot to register SSL certificates for the domain.

## Gotchas

- If you encounter errors about files not existing in `/vendor`, delete it, then restart the container using `drun stop && drun` as this indicates a failed composer install (possibly with damaged permissions).
- Because multiple projects are using the same docker image repository, changes for a single project should be tagged with a prefix for that project (Ex: `cohesivefire-1.04`) and `Dockerrun.aws.json` should be updated to use that image in production.

## Further Reading:
- [Composer Docs](https://getcomposer.org/doc/)
- [Drush commands](https://drushcommands.com/drush-8x/) 
- [Drupal w/ Composer project docs](https://github.com/drupal-composer/drupal-project) (Drupal 8+ only)
- [Workflow for configuration sync between environments using the web interface](https://www.drupal.org/node/2416545) (Drupal 8+ only)
- [Workflow for configuration sync between environments using git](http://nuvole.org/blog/2014/aug/20/git-workflow-managing-drupal-8-configuration) (Drupal 8+ only)
