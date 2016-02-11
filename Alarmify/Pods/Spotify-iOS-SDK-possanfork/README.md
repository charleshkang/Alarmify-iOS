**WARNING: This is a beta release of the Spotify iOS SDK.**


Spotify iOS SDK Readme
=======

Welcome to Spotify iOS SDK! This ReadMe is for people who wish to develop iOS
applications containing Spotify-related functionality, such as audio streaming,
playlist manipulation, searching and more.

Usage of this SDK is bound under the [Developer Terms of Use](https://developer.spotify.com/developer-terms-of-use/).


Beta Release Information
=======

We're releasing this SDK early to gain feedback from the developer community
about the future of our iOS SDKs. Please file feedback about missing issues or
bugs over at our [issue tracker](https://github.com/spotify/ios-sdk/issues),
making sure you search for existing issues and adding your voice to those
rather than duplicating.

For known issues and release notes, see the
[CHANGELOG.md](https://github.com/spotify/ios-sdk/blob/master/CHANGELOG.md)
file.


Requirements
=======

The Spotify iOS SDK requires iOS a deployment target of iOS 7 or higher. The
following architectures are supported: `armv7`, `armv7s` and `arm64` for devices,
and `i386` and `x86_64` for the iOS Simulator. The `i386` and `x86_64` slices
*cannot* be used to build Mac applications.


Getting Started
=======

Getting the Spotify iOS SDK into your application is easy:

1. Add the `Spotify.framework` library to your Xcode project.
2. Add the `-ObjC` flag to your project's `Other Linker Flags` build setting.
3. Add `AVFoundation.framework` to the "Link Binary With Libraries" build phase
   of your project.
4. `#import <Spotify/Spotify.h>` into your source files and away you go!

The library's headers are extensively documented, and it comes with an Xcode
documentation set which can be indexed by Xcode itself and applications like
Dash. This, along with the included demo projects, should give you everything
you need to get going. The classes that'll get you started are:

* `SPTAuth` contains methods of authenticating users. See the "Basic Auth" demo
  project for a working example of this. Be sure to to read the "Authentication and
  Scopes" and "Session Lifetime" sections below, as authentication is quite involved.

  **Note:** To perform audio playback, you must request the `SPTAuthStreamingScope`
  scope when using `SPTAuth`. To do so, pass an array containing the constant to
  `-loginURLForClientId:declaredRedirectURL:scopes:`. The supplied demo
  projects already do this if needed.

* `SPTRequest` contains methods for searching, getting playlists and doing
  metadata lookup. Most metadata classes (`SPTTrack`, `SPTArtist`, `SPTAlbum` and
  so on) contain convenience methods too.

Authenticating and Scopes
=======

You can generate your application's Client ID, Client Secret and define your
callback URIs at the [My Applications](https://developer.spotify.com/my-applications/)
section of the Spotify Developer Website. The temporary keys given out for previous
SDK Releases will not work with Beta 3 and newer.

When connecting a user to your app, you *must* provide the scopes your application
needs to operate. A scope is a permission to access a certain part of a user's account,
and if you don't ask for the scopes you need you will receive permission denied errors
when trying to perform various tasks.

You do *not* need a scope to access non-user specific information, such as to perform
searches, look up metadata, etc.

Common scopes include:

* `SPTAuthStreamingScope` allows music streaming for Premium users.

* `SPTAuthUserReadPrivateScope` allows access to a user's private information, such
  as full display name, user photo, etc.

* `SPTAuthPlaylistReadScope` and `SPTAuthPlaylistReadPrivateScope` allows access to
  a user's public and private playlists, respectively.

* `SPTAuthPlaylistModifyScope` and `SPTAuthPlaylistModifyPrivateScope` allows
  modification of a user's public and private playlists, respectively.

A full list of scopes is available in the documentation and in `SPTAuth.h`.

If your application's scope needs change after a user is connected to your app, you
will need to throw out your stored credentials and re-authenticate the user with the
new scopes.

**Important:** Only ask for the scopes your application needs. Requesting playlist
access when your app doesn't use playlists, for example, is bad form.

Session Lifetime
=======

Once your user is authenticated, you will receive an `SPTSession` object that allows
you to perform authenticated requests. This session is only valid for a certain
period of time, and must be refreshed.

You can find out if the session is still valid by calling the `-isValid` method on
`SPTSession`, and the expiration date using the `expirationDate` property. Once
the session is no longer valid, you can renew it using `SPTAuth`'s
`-renewSession:withServiceEndpointAtURL:callback:` method.

As an example, when your application is launched you'll want to restore your stored
session then check if it's valid and renew it if necessary. Your code flow would go
something like this:

```objc
SPTSession *session = …; // Restore session

if (session == nil) {
    // No session at all - use SPTAuth to ask the user
    // for access to their account.
    [self presentFirstTimeLoginToUser];

} else if ([session isValid]) {
    // Our session is valid - go straight to music playback.
    [self playMusicWithSession:session];

} else {
    // Session expired - we need to refresh it before continuing.
    // This process doesn't involve user interaction unless it fails.
    NSURL *refreshServiceEndpoint = …;
    [[SPTAuth defaultInstance] renewSession:session
                   withServiceEndpointAtURL:refreshServiceEndpoint
                                   callback:^(NSError *error, SPTSession *session)
        {
            if (error == nil) {
                [self playMusicWithSession:session];
            } else {
                [self handleError:error];
            }
        }];
}
```

Migrating from CocoaLibSpotify
=======

CocoaLibSpotify is based on the libspotify library, which contains a lot of
legacy and is a very complex library. While this provided a great deal of
functionality, it could also eat up a large amount of RAM and CPU resources,
which isn't ideal for mobile platforms.

The Spotify iOS SDK is based on a completely new technology stack that aims to
avoid these problems while still providing a rich set of functionality. Due to
this new architecture, we took the decision to start from scratch with the
Spotify iOS SDK's API rather than trying to squeeze the new technology into
CocoaLibSpotify's API. This has resulted in a library that's much easier to use
and has a vastly smaller CPU and RAM footprint compared to CocoaLibSpotify.

The Spotify iOS API does *not* have 1:1 feature parity with CocoaLibSpotify.
It contains functionality that CocoaLibSpotify does not, and CocoaLibSpotify
has features that the Spotify iOS SDK does not. We're working to close that
gap, and if there's a feature missing from the Spotify iOS SDK that's
particularly important to you, please get in touch so we can prioritise
correctly.

Due to the API and feature differences between CocoaLibSpotify and the Spotify
iOS SDK, we understand that migration may be difficult. Due to this,
CocoaLibSpotify will remain available for a reasonable amount of time after
this SDK exits beta status.
