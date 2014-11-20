# cowboy\_pooler\_example #

When faced with some pretty bizarre behaviour locally testing with [Tsung](http://tsung.erlang-projects.org/),
I went down the path of creating a simple application to test my approach in isolation.  Turns out it
was mostly just a case of local -> VPN -> AWS causing me issues but I thought the resulting
simple application might serve as a useful example for others beginning with things like:

* Opscode's great [concrete](https://github.com/opscode/concrete) tool
* the [Cowboy](http://ninenines.eu/docs/en/cowboy/1.0/guide/) application library
* Seth's [Pooler](https://github.com/seth/pooler) project for managing pools of connections, ````gen_server````s, etc
* the [Tsung](http://tsung.erlang-projects.org/) load testing tool (though my usage here is very simple)

## What Is It? ##

It's a minimal example of a basic user service that has only a single ````GET```` endpoint.

## Building It ##

Pretty simple:  ````make````

If you want to build a full release (a folder structure that includes the Erlang runtime, libraries, etc):  ````make rel````

## Running It ##

The configuration targets PostgreSQL in a local [Vagrant](http://vagrantup.com) image, so start that first:

    vagrant up

Make a release first by running ````make clean rel````.  Starting it in the foreground:

    ./_rel/cowboy_pooler_example/bin/cowboy_pooler_example foreground

The basic endpoint to hit would be something like [http://localhost:8004/user/1](http://localhost:8004/user/1).  Example
users 1-4 should be in the simple Vagrant-hosted database.

## Using Tsung ##

As mentioned before, my usage is very basic.  The supplied configuration file tries to simulate the arrival of 100 users per second.
Run it with the following command if you have the example service already running:

    tsung -f tsung.xml start

Once Tsung boots up, it will list the folder where it keeps its logs.  I was originally using this to see the proportion of error 503
responses vs 200s under load and latency.
