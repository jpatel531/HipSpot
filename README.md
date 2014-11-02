#HipSpot

A HipChat plugin that allows you play tunes on Spotify.

##What It Does

Let's say you're in an office, and there's one computer running Spotify. Given that computer has Spotify open, and both `server/server.rb` and the `robut` binary are running, anyone on the company's HipChat can play songs on the central computer.

##How To Run It

Clone this repo.

    $ git clone https://github.com/jpatel531/HipSpot.git

###Setting Up The Bot

In `config.yml`, set up the variables the robot needs to run:

* `server_url`: The URL the Robot is posting song requests to.
* `jid`: The Jabber ID given to the Robot's account by HipChat, which can be found under your account settings.
* `password`: The password of the Robot's account.
* `nick`: The name the Robot appears as.
* `room`: The HipChat rooms the Robot appears in.
* `mention_name`: The short name referring to the Robot. E.g. @bot

When that's done, type `robut` to start the Robot. You should see it appear in Hipchat.

###Start The Server

    $ cd server
    shotgun
    ngrok -subdomain=<your_app_name> 9393

Alternatively you can use the external IP to receive requests from within a local network without deployment. When the Bot sends requests, the server will play the appropriate Spotify song on the computer it's hosted on.

Ta Da!



