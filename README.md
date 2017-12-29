# FeestwinkelApp
This is my Project for the course evaluation of Native Apps II. This project will be used as a real application for the store [Feestwinkel.be](https://www.feestwinkel.be). The application allows you to search the offer of firework and to see a demovideo. Next to this, you can sort the firework on alphabet, price, en type. It also let you scan the firework in the physical store to see the video. But you only can scan if you are actually there.

### Appstore
The application will be available in the appstore as soon as possible. I'm waiting for a review at this moment.
![status](https://cdn.pbrd.co/images/H0sy7lk.png)

### Usage
Just run the xcode project. The app comes with a prefilled **Realm database** so you should see all the firework in the Collectionview. If you want use the scanner at home you must edit the *'FireworkOverviewController.swift'*. 
Comment this : (line 28 till 30 ) 
```swift
        scanButton.isEnabled = false;
        scanButton.alpha = 0.7;
        scanText.isHidden = false;
```
And comment this : (line 47 till 55)
```swift
        if(distance < 60.00){
            scanText.isHidden = true;
            scanButton.isEnabled = true;
            scanButton.alpha = 1;
        }else{
            scanText.isHidden = false;
            scanButton.isEnabled = false;
            scanButton.alpha = 0.7;
        }
```
Now the scanbutton should be enabled when you run the project. In the folder FireworkExamples, you find pictures of the firework just like they are placed in the store. When you hold your phone in front of the picture, the application should scan the firework.

### Used Frameworks and Services
I used some new material that we didn't see in class. 
* AVKit 
* Core Location
* Vision
* SceneKit
* ARKit
* CoreML
I used [Microsoft's custom vision](https://www.customvision.ai) to build my own Machine Learning Model (Vuurwerk.mlmodel). 

### Demo video
![demo](https://github.com/Jeremy-vdw/FeestwinkelApp/blob/master/demo.gif)
