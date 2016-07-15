# IOS_ChattingRoom
 
This is a simple chatting room and the UIUserNotification is the key method to implement the send and get message function.
DeviceToken is the unique key for the Apple APNS to identify the devices that can work this chatting room app.

<img src="https://raw.githubusercontent.com/chen-chien-lung/IOS_ChattingRoom/master/IMG_2765.jpg" width=283px height="504">
 
1.Ask user's permission for UIUserNotification.
<img src="https://github.com/chen-chien-lung/IOS_ChattingRoom/blob/master/RegistUserNotification.png?raw=true">

2.After reciiving the DeviceToken ,save the DeviceToken to our local server.
  We keep the DeviceToken in the server is so that when we send the messages the server knows that which devices can get the messages.
<img src="https://github.com/chen-chien-lung/IOS_ChattingRoom/blob/master/DeviceToken.png?raw=true">

3.To decide what we will do after receiving the UIUserNotification
<img src="https://github.com/chen-chien-lung/IOS_ChattingRoom/blob/master/UserNotification.png?raw=true">
