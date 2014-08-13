# Shared Keychain Demo

A demo of using shared keychains, because there is a lot of misconception of what is required to enable shared keychains.


## Requirements
run `pod install` to install UICKeyChainStore
You will need to add the following App IDs to your Apple developer center profile
- this.bundle.identifier.is
- it.doesnt.matter.what

and install their provisioning profiles. Xcode can take care of this part. Maybe.


Only the `App ID Prefix` needs to be the same, this may be your Team ID.



## Running
Open the workspace and run the apps. You'll need to run on an actual iOS device, not the Simulator, since the Simulator can troll you and make everything look OK when it's not ( ≖‿≖)
`is` writes the `[NSDate date].description` to the shared keychain.
`what` reads from the shared keychain.

Running `what` should output something similar to the log:

```
2014-08-13 11:42:47.281 what[2628:60b] store1 key1 is 2014-08-13 02:42:38 +0000
2014-08-13 11:42:47.283 what[2628:60b] store2 key1 is 2014-08-13 02:42:38 +0000
```



# Setting up shared keychains
You'll need:
- A common App ID Prefix
- define the keychain groups (`keychain-access-groups`) for the keychain sharing entitlements. Xcode will prepend `$(AppIdentifierPrefix)` for you, so you don't have to add this youself.

That's it, no common bundle ID, no shared domain string, nothing.

