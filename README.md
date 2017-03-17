# IRC cat

Tails a file and puts it to an IRC channel.

# Requirements

I recommend installing the following with `App::cpanminus`

- POE
- POE::Component::IRC
- POE::Component::IRC::Plugin::FollowTail (usually ships with POE::Component::IRC)

# Settings

## Selecting files

Tweak the `%tail_files` hash table to select which files to tail. The key needs to be unique, but it doesn't matter what it is.

## `$irc` object

Before launching, you'll want to review the follwoing settings

- Nick: the nickname the bot will connect to IRC as
- Server: the server address to connect to
- Port: port # to connect on
- Password: server password (or comment this out if there's no server password)
- Flood: 0 enables internal flood checks to stop the bot from flooding itself off the server. Set this to 1 if the bot is flood exempt.
- UseSSL: Connect using TLS
- SSLCert: Path to certificate file to connect with
- SSLKey: Path to private key file to connect with

Not listed, but you can also set a `Debug => 1` to see server traffic if the bot is having issues connecting.

