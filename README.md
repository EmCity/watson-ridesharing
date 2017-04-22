<img src="https://bluemixassets.eu-gb.mybluemix.net/api/Products/image/logos/conversation.svg?key=[starter-watson-conversation]&event=readme-image-view" alt="Watson Conversation Logo" width="200px"/>

## Conversation
Bluemix Mobile Starter for Conversation in Swift

[![](https://img.shields.io/badge/bluemix-powered-blue.svg)](https://bluemix.net)
[![Platform](https://img.shields.io/badge/platform-ios_swift-lightgrey.svg?style=flat)](https://developer.apple.com/swift/)

### Table of Contents
* [Summary](#summary)
* [Requirements](#requirements)
* [Configuration](#configuration)
* [Run](#run)
* [License](#license)

### Summary
This Bluemix Mobile Starter will showcase the Conversation service from Watson and give you integration points for each of the Bluemix Mobile services.

### Requirements
* iOS 8.0+
* Xcode 8
* Swift 3.0

### Configuration
* [Bluemix Mobile services Dependency Mangagement](#bluemix-mobile-services-dependency-management)
* [Watson Dependency Management](#watson-dependency-management)
* [Watson Credential Mangement](#watson-credential-management)

#### Bluemix Mobile services Dependency Management
This starter uses the Bluemix Mobile services SDKs in order to use the functionality of Mobile Analytics, Push Notifications, and Mobile Client Access.

The Bluemix Mobile services SDK uses [CocoaPods](https://cocoapods.org/) to manage and configure dependencies. To use our latest SDKs you need version 1.1.0.rc.2.

You can install CocoaPods using the following command:

```bash
$ sudo gem install cocoapods --pre
```

If the CocoaPods repository is not confifgured, run the following command:

```bash
$ pod setup
```

For this starter, a pre-configured `Podfile` has been included in the **ios_swift/Podfile** location. To download and install the required dependencies, run the following command in the **ios_swift** directory:

```bash
$ pod install
```
Now Open the Xcode workspace: `{APP_Name}.xcworkspace`. From now on, open the `.xcworkspace` file becuase it contains all the dependencies and configurations.

If you run into any issues during the pod install, it is recommended to run a pod update by using the following commands:

```bash
$ pod update
$ pod install
```

> [View configuration](#configuration)

#### Watson Dependency Management
This starter uses the Watson Developer Cloud iOS SDK in order to use the Watson Conversation service.

The Watson Developer Cloud iOS SDK uses [Carthage](https://github.com/Carthage/Carthage) to manage dependencies and build binary frameworks.

You can install Carthage with [Homebrew](http://brew.sh/):

```bash
$ brew update
$ brew install carthage
```

To use the Watson Developer Cloud iOS SDK in any of your applications, specify it in your `Cartfile`:

```
github "watson-developer-cloud/ios-sdk"
```

For this starter, a pre-configured `Cartfile` has been included in the **ios_swift/Cartfile** location

Run the following command to build the dependencies and frameworks:

```bash
$ carthage update --platform iOS
```

> **Note**: You may have to run `carthage update --platform iOS --no-use-binaries`, if the binary is a lower version than your current version of Swift.

Once the build has completed, the frameworks can be found in the **ios_swift/Carthage/Build/iOS/** folder. The Xcode project in this starter already includes framework links to the following frameworks in this directory:

* **ConversationsV1.framework**
* **RestKit.framework**

![ConfiguredFrameworks](README_Images/ConfiguredFrameworks.png)

If you build your Carthage frameworks in a separate folder, you will have to drag-and-drop the above frameworks into your project and link them in order to run this starter successfully.

> [View configuration](#configuration)

#### Watson Credential Management
Once the dependencies have been built and configured for the Bluemix Mobile service SDKs as well as the Watson Developer Cloud SDK, you will need to configure the Watson credentials for the Conversation service. If you have not already created  the Watson Conversation service on Bluemix, please go to the [Bluemix Catalog](https://console.bluemix.net/catalog/) and create and bind [Conversation](https://console.bluemix.net/catalog/services/conversation/).

You will need to create or upload a conversation file to your Watson Conversation service on Bluemix in order to allow interaction with the service.

In the dashboard of your Conversation service on Bluemix run the Conversation tooling dashboard by clicking the **Launch tool** button:

![ConversationDashboard](README_Images/ConversationDashboard.png)

Now create your own Conversation Workspace or upload the sample we have included in this project (**bluemix_mobile_qa_workspace.json**):

![ConversationWorkspace](README_Images/ConversationWorkspace.png)

After you have created or uploaded a Conversation Workspace you will need to get the Workspace Id. Click the **View details** list item to see the Workspace information. Save the **WorkspaceID** which we will need to include in our application configuration:

![ConversationWorkspaceID](README_Images/ConversationWorkspaceID.png)


A **WatsonCredentials.plist** configuration file is included in the XCode project that includes credential configuration for the Conversation Service:

![WatsonCredentials.plist](README_Images/WatsonCredentialsPlist.png)

Include the username and password credentials for the Conversation service that correspond to your Bluemix application values:

![ConversationCredentials](README_Images/ConversationCredentials.png)

> [View configuration](#configuration)




### Run
You can now run the application on a simulator or physical device:

<img src="README_Images/ConversationScreenshot.png" alt="Conversation App Screenshot" width="250px"/>

The Watson Conversation service allows you to add a natural language interface to your application to automate interactions with your end users. This application shows an application of this service that allows you to have a conversation with Watson. Watson will send an initial conversation which you can then reply to and continue to interact with the service.

### License
This package contains code licensed under the Apache License, Version 2.0 (the "License"). You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0 and may also view the License in the LICENSE file within this package.
# watson-ridesharing
