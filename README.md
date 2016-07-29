
# Piclet
Piclet is a social sharing image platform with the ability to create and compete different challenges. 
This repo contains the iOS Piclet Application. 

Here are some screenshots for a better understanding what this app does: 

<img src="https://cloud.githubusercontent.com/assets/3514796/17260108/dd792856-55ce-11e6-9748-e7951c753f75.PNG" 
alt="welcome" width="240px" height="auto">
<img src="https://cloud.githubusercontent.com/assets/3514796/17260025/64b9bb2e-55ce-11e6-913d-61a27a63a934.PNG" alt="challenges" width="240px" height="auto">
<img src="https://cloud.githubusercontent.com/assets/3514796/17260023/64b8304c-55ce-11e6-95a0-1dd5bd57d9fb.PNG" 
alt="createChallenge" width="240px" height="auto">
</div>

<img src="https://cloud.githubusercontent.com/assets/3514796/17260021/64b638fa-55ce-11e6-9691-867cee399083.PNG" 
alt="posts" width="240px" height="auto">
<img src="https://cloud.githubusercontent.com/assets/3514796/17260020/64b5502a-55ce-11e6-92cf-4fbee449702a.PNG" 
alt="profile" width="240px" height="auto">
<img src="https://cloud.githubusercontent.com/assets/3514796/17260024/64b928c6-55ce-11e6-8fdf-37232812dd03.PNG" 
alt="receivedLikes" width="240px" height="auto">



# Getting started

This section explains what tools you need to install, to compile and to run *Piclet* on an *iOS Device* or *iOS Simulator*. The *Piclet iOS App* was created with the open source programming language Swift 2.0 and supports all iPhone / iPod Touch Devices running iOS 8.0 and later. 




## Features

* Login / create account
* Sort the running challenges through a ‘hot’ and ‘new’ section
* Each challenge displays additional informations like: ‘number of posts’, ‘number of total votes’ and ‘age’ 
* Discover interesting and hopefully challenging posts
* Ability to like a user post 
* Each user can create new challenges and posts
* The Profile view shows the user stats and history
* The stats contain the rank and the ‘total number of likes’ the user earned
* The history contains all ‘posts’, ‘likes’ and ‘challenges’ the user created
* The user can upload his own avatar


****



## Requirements
The following list contains the requirements you need to be able to compile *Piclet* on your computer. 

#### **Mac OS X**
You need a computer which runs *Mac OS X* as your Operation System. This constraint comes from Apple and applies for every *iOS Application*.

#### **Xcode**
*Xcode* is an Integrated Development Environment (IDE) which also contains the *iOS* software development kit (SDK) which enables *iOS* development. To compile the *Piclet* Application you need to install Xcode. 

There are two ways to obtain a copy. The easiest is to install *Xcode* through the *Mac App Store*. The *Mac App Store* comes pre installed in *Mac OS X v10.6.6* or later.

The other way is to create an Apple Developer Account and download *Xcode* from the Apple Developer Website. Here you can also get a copy of a Beta version of *Xcode*.

#### **Carthage**

*Carthage* is a decentralized dependency manager. I used *Carthage* to simplify the process of obtaining and managing frameworks that I added to the *Piclet* project. There are two ways to install *Carthage* on your system:

1. Download the *Carthage.pkg* and install it on your machine. You can get the file from the github repository.
https://github.com/Carthage/Carthage

2. You can also install *Carthage* through *Homebrew*. The only requirement is that *Homebrew* and *Xcode 7.1* or newer is installed on your machine. To install execute the following commands on your command line.

```
brew update
brew install carthage
```

For more details on how this dependency manager works, please check the *Carthage* Github project Site. 


****



## Run the App
The following steps describe how to download and compile the project in *Xcode*. Before you start make sure that you fulfil all the requirements listed above.

#### **Download the Project**
First you need to push or download the *iOS Piclet* repository. To pull the repository just execute the following on your command line:

```
git pull https://Safi1012@bitbucket.org/Safi1012/piclet-ios.git
```

The repository should now be downloaded and saved to your selected destination.


#### **Install the dependencies**
The next step is to download and install the required dependencies for the project. This process is simple thanks to *Carthage*. Just navigate on your command line to the *Piclet* destination path you selected above and execute:

```
carthage bootstrap
```

When the process finishes, all the existing project dependencies should be installed.


#### **Execute Piclet**
Open Xcode and select ‘open another Project’ and select the path where you saved the *Piclet* Project. After *Xcode* finished loading you should see the *Piclet* Project and all files which it includes. 

To compile the App press the ‘Run’ (triangle) Button and select the *iOS Simulator* or your connected Device as the target.

After compiling the project, the *Piclet App* should be open on your selected target device.

You should now have a running copy on your target device. 

