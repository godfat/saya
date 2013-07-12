# Saya[![Build Status](https://secure.travis-ci.org/godfat/saya.png?branch=master)](http://travis-ci.org/godfat/saya)

by Lin Jen-Shin ([godfat](http://godfat.org))

## LINKS:

* [github](https://github.com/godfat/saya)
* [rubygems](https://rubygems.org/gems/saya)
* [rdoc](http://rdoc.info/github/godfat/saya)

## DESCRIPTION:

Saya helps you post a post to different SNS simultaneously.

It is intended to provide a reference usage for [Jellyfish](https://github.com/godfat/jellyfish).

## FEATURES:

Post once, show up everywhere.

## REQUIREMENTS:

* Tested with MRI (official CRuby) 1.9.3, 2.0.0, Rubinius and JRuby.

## INSTALLATION:

    gem install saya

## SYNOPSIS:

    # Run the server at 0.0.0.0:8080 (it'll pick a server for you)
    saya

    # Run the server at 0.0.0.0:9090 with Rainbows! server
    saya -s rainbows -p 9090

    # Use your own Rainbows! server to run Saya
    rainbows -c /path/to/rainbows/config.rb `saya -c`

    # Use your own auth config for setting up SNS key/secret
    saya -a /path/to/auth.yaml

    # Or pass it as an environment variable
    env SAYA_AUTH=/path/to/auth.yaml saya

    # Print the content of default auth.yaml
    saya -y

    # Setup SNS key/secret via `env`
    env TWITTER_CONSUMER_KEY=key TWITTER_CONSUMER_SECRET=secret saya

    # Print the help message
    saya -h

## CONTRIBUTORS:

* Lin Jen-Shin (@godfat)

## LICENSE:

Apache License 2.0

Copyright (c) 2013, Lin Jen-Shin (godfat)

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

<http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
