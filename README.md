# Virtual Host NGINX and PHP-FPM - CentOS 7.2

This Virtual Host template is to help create the proper folder structure and settings for a new NGINX and PHP-FPM install on a CentOS 7.2 webserver. It also includes Vagrantfile and provisioning needed for local development.

## Usage

To use it, run cookiecutter with this repository url:

```
cookiecutter gh:twkm/vhosttemplate-centos-72-cookiecutter
```

This will clone the project to a local folder and prompt you for some inputs to create the project:

* **admin_email:** Email used for the ServerAdmin variable in the virtual host server config files
* **project_name:** The name of the project. This is used to name the folder and link everything up properly in server config files.

## Configuration

Ensure that you review the ```/config/nginx-conf``` and ```/config/nginx-vhosts``` folders to edit configuration files. You may need to add additional server configurations, or add new ones to these folders.

The ```/config/nginx-conf``` folder is where you add NGINX configuration for new subdomains. ```/config/nginx-vhosts``` is where you customize the NGINX settings for each new subdomain.

## Requirements

This template requires [Cookiecutter](https://github.com/audreyr/cookiecutter) v.1.1+ in order to be able to exclude binary files. The ```/data/adminer/``` folder includes binary data which will cause an error in earlier versions of Cookiecutter.