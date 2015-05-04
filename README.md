bitswarm/apache-php-drupal
==========================

Extension of bitswarm/apache-php preloaded with Drupal and build tool extras such as Bower, Bundler, Composer, Compass, 
Drush, and Grunt. 


Building the base image
-----------------------

To create the base image `bitswarm/apache-php-drupal`, execute the following command on the bitswarm-docker-php folder:

    docker build -t bitswarm/apache-php-drupal .


Running your Apache+PHP docker image
------------------------------------

Start your image binding the external ports 80 in all interfaces to your container:

    docker run -d -p 80:80 bitswarm/apache-php-drupal

Test your deployment:

    curl http://localhost/

Hello world!

Environment Variables For Dynamic Configuration
-----------------------------------------------

There are certain environment variables which if set can configure various options, such as whether SSHD is enabled,
the service acct password and private/public keys, Xdebug, etc.  Please see the Dockerfile for reference.

Loading your custom PHP application
-----------------------------------

This image can be used as a base image for your PHP application. Create a new `Dockerfile` in your 
PHP application folder with the following contents:

    FROM bitswarm/apache-php-drupal

After that, build the new `Dockerfile`:

    docker build -t username/my-php-app .

And test it:

    docker run -d -p 80:80 username/my-php-app

Test your deployment:

    curl http://localhost/

That's it!


Loading your custom PHP application with composer requirements
--------------------------------------------------------------

Create a Dockerfile like the following:

    FROM bitswarm/apache-php-drupal
    RUN rm -fr /app
    ADD . /app
    RUN composer install

- Replacing `git` with any dependencies that your composer packages might need.
- Add your php application to `/app`

Other build utilities included
------------------------------

 - Drush
 - Composer
 - Grunt
 - Bower
 - Bundler