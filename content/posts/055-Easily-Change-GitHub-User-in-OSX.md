---
title: Easily Change GitHub User in OS X
publishDate: 2019-11-18
lastmod: 2020-03-11T10:13:54-05:00
draft: false
emojiEnable: true
tags:
  - OS X
  - GitHub
  - keychain
  - Keychain Access
  - credentials
---

## Check Your Git Configuration

The first step is to run `git config -l` to see what the current configuration is.  If the `user.name` and/or `user.email` properties are incorrect, change them using something like this:

```
git config --global user.name "Mark McFate"
git config --global user.email "yourEMail@address.here"
```

That's only half the battle.  I love _OS X_ and the _Keychain Access_ app is wonderful, except when I'm working with _git_ and _GitHub_ in a terminal, which I do quite often. The real problem is that I have 4 different identities in _GitHub_... crazy, I know.  

## Altering Keychain Access from the Command Line

Changing from one identity to another has been a real pain-in-the-a$$, up until I found [this gem of a post](https://help.github.com/en/github/using-git/updating-credentials-from-the-osx-keychain).

Basically, what it tells me to do from the command line is this:

{{% boxmd %}}
Through the command line, you can use the credential helper directly to erase the keychain entry.

To do this, type the following command:

```
git credential-osxkeychain erase
host=github.com
protocol=https
>
```
...Press `return` twice if necessary.

If it's successful, nothing will print out. To test that all of this works, try and clone a repository from GitHub. If you are prompted for a password, the keychain entry was deleted.
{{% /boxmd %}}

Works like a charm!  But, if it doesn't, and that has been my experience at times, I've opened the **Keychain Access** app and executed the steps documented in the next section.  The next `git...` command I specify, if necessary, will prompt me for my _GitHub_ username and password, and those are automatically saved until I repeat the `git credential-osxkeychain erase` command. Woot!

## Changing Keychain Access in the GUI

If all else fails, I sometimes find it necessary to open my Mac's _Keychain Access_ app, search for all instances of `github.com`, and delete the entry that generally has these properties:

  - Name: @ github.com
  - Kind: Internet password
  - Keychain: login

Once that has been removed, and the removal is saved, my _git_ commands once again will prompt me for a valid username and password.

And that's a wrap.  Until next time...
