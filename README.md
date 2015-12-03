# RingCentral Swift SDK

[![Build Status](https://travis-ci.org/anilkumarbp/RingCentralSwift.svg?branch=master)](https://travis-ci.org/anilkumarbp/RingCentralSwift)
[![codecov.io](https://codecov.io/github/anilkumarbp/RingCentralSwift/coverage.svg?branch=master)](anilkumarbp/RingCentralSwift.svg?branch=master)

***

1. [Overview](#overview)
2. [Setting Up](#setting-up)
3. [Initialization](#initialization)
4. [Authorization](#authorization)
5. [Generic Requests](#generic-requests)
6. [Performing RingOut](#performing-ringout)
7. [Sending SMS](#sending-sms)
8. [Subscription](#subscription)
9. [SDK Demos](#sdk-demos)


***

# Overview

The purpose of this RingCentral Swift SDK is to assist other developers in expediating the
development of any application. The outlines attempt to mirror the legacy of other SDks,
however it is not guaranteed to be exactly the same.

***

# Setting Up

Navigate to your project directory (the one with the 'workspace' file, e.g. `.xcodeproj` extension).

Type:

    $ git clone https://github.com/ringcentral/ringcentral-swift.git
    $ cd ringcentral-swift
    $ chmod 700 setup.sh
    $ ./setup.sh
    $ cd ..

The previous commands will automatically move all the appropriate files into your project directory.

Open up Xcode to your project. File -> Add Files... -> add http, core, subscription, and platform.

Install CocoaPods to retrieve other dependencies.

To set up CocoaPods:

    $ sudo gem install cocoapods

The same line is used to update cocoapods accordingly.

Ensure your current working directory is the project directory and execute the following CocoaPod commands:

    $ pod init
    $ open -a Xcode Podfile

That will set up a Podfile and open it for editing.

If you are in the iOS platform, replace the file contents with the following, ensuring you replace `YourProjectName` and `YourProjectNameTests` appropriately. The target file must have the literal string `Tests` appended to `YourProjectName`.

    platform :ios, '8.0'
    target 'YourProjectName' do
    source 'https://github.com/CocoaPods/Specs'
    pod 'PubNub', '~>4.0'
    use_frameworks!
    end
    target 'YourProjectNameTests' do
    end

If you are in the OSx platform, replace the file contents with the following, ensuring you replace `YourProjectName` and `YourProjectTest` appropriately:
    
    platform :osx, '10.0'
    target 'YourProjectName' do
    source 'https://github.com/CocoaPods/Specs'
    use_frameworks!
    pod 'PubNub', '~>4.0'
    end

Save and close the Podfile.

Go back into terminal and type the following from within the project directory:

    $ pod update
    $ pod install

If for some reason there is not an Objective-C bridging header:
Create a new File (File -> New -> File) of type Objective-C.
You will be promped "Would you like to configure an Objective-C bridging header?".
Select Yes, and insert the following into the Bridging Header file (.h).

    #import <PubNub/PubNub.h>

You will now be able to use the PubNub SDK written in Objective-C.

# Initialization

The RingCentral SDK is initiated in the following ways.

**Sandbox:**

    var rcsdk = SDK(appKey: app_key, appSecret: app_secret, server: SDK.RC_SERVER_SANDBOX)

**Production:**

    var rcsdk = SDK(appKey: app_key, appSecret: app_secret, server: SDK.RC_SERVER_PRODUCTION)

The 'app_key' and 'app_secret' should be read from a configuration file.

Depending on the stage of production, either                                        
**SDK.RC_SERVER_SANDBOX** or **SDK.RC_SERVER_PRODUCTION**                                   
will be used as the 'server' parameter.

# Authorization

To authorize the platform, extract the 'Platform' object:

    var platform = rcsdk.getPlatform()

Once the platform is extracted, call:

    platform.authorize(username, password: password)

or (to authorize with extension):

    platform.authorize(username, ext: ext, password: password)

The SDK will automatically refresh the token so long the refresh token lives.

*Caution*: If no extension is specified, platform automitically refers extension 101 (default).
***

# Generic Requests

Currently all requests can be made through the following:

    apiCall([
        "method": "POST",
        "url": "/restapi/v1.0/",
        "body": ""
    ])

Attach the following code as a completion handler (callback) if needed:

    {(data, response, error) in
        if (error) {
            // do something for error
        } else {
            // continue with code
        }
    }

For simple checking of a successful status code:

    (response as! NSHTTPURLResponse).statusCode / 100 == 2


For turning 'data' into a Dictionary (JSON):

    NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: &errors) as! NSDictionary
    // or
    NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: nil) as! NSDictionary


For readability of the data

    println(NSString(data: data!, encoding: NSUTF8StringEncoding))

# Performing RingOut

RingOut follows a two-legged style telecommunication protocol.
The following method call is used to send a Ring Out.

    apiCall([
        "method": "POST",
        "url": "/restapi/v1.0/account/~/extension/~/ringout",
        "body": ["to": ["phoneNumber": "14088861168"],
                 "from": ["phoneNumber": "14088861168"],
                 "callerId": ["phoneNumber": "13464448343"],
                 "playPrompt": "true"]
    ])

# Sending SMS

The follow method call is used to send a SMS.

platform.postSms("hi i'm min", to: "12345678912") // true
    
    apiCall([
        "method": "POST",
        "url": "/restapi/v1.0/account/~/extension/~/sms",
        "body": ["to": [{"phoneNumber": "14088861168"}],
                 "from": ["phoneNumber": "14088861168"],
                 "text": "send message"
    ])


# Subscription

To enable subscription, type:

    self.subscription = Subscription(platform: self)
    subscription!.register()

In order for PubNub to do something after a callback:

    platform.subscription!.setMethod({
        (arg) in
        // do whatever you need to with the callback variable 'arg'
    })

An example in the demo is provided that changes the status color accordingly.

***

# SDK Demo 1

Login page:
    Insert app_key, app_secret, username, password in order to log in.
    This is generally done through a configuration file.

![Alt text](/img/login.png?raw=true "Optional Title")

Phone page:
    Use the number pad to type the numbers you need.
    The Status Bar (initially shown as a red rectangle 'No Call') changes color accordingly.
    Allows the sending of SMS and Fax, along with the ability to make calls.

![Alt text](/img/phone.png?raw=true "Optional Title")

Log page:
    Shows implementation of the 'Call Log' along with the 'Message Log'.

![Alt text](/img/log.png?raw=true "Optional Title")


