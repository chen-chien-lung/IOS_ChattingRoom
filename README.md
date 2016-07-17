# IOS_ChattingRoom
 
This is a simple chatting room and the UIUserNotification is the key method to implement the send and get message function.
DeviceToken is the unique key for the Apple APNS to identify the devices that can work this chatting room app.

<img src="https://raw.githubusercontent.com/chen-chien-lung/IOS_ChattingRoom/master/IMG_2765.jpg" width=283px height="504">
 
1.Ask user's permission for UIUserNotification.
<img src="https://github.com/chen-chien-lung/IOS_ChattingRoom/blob/master/RegistUserNotification.png?raw=true">

2.After reciiving the DeviceToken ,save the DeviceToken to our local server.
  We keep the DeviceToken in the server so that the server knows which devices can get the messages.
<img src="https://github.com/chen-chien-lung/IOS_ChattingRoom/blob/master/DeviceToken.png?raw=true">

3.To decide what we will do after receiving the UIUserNotification
<img src="https://github.com/chen-chien-lung/IOS_ChattingRoom/blob/master/UserNotification.png?raw=true">

4.Commnuicator class . This class is to handle all the send/get the message/image function.
<img src="https://github.com/chen-chien-lung/IOS_ChattingRoom/blob/master/methods.png?raw=true">

5.Because this Communicator class will be called lots of times and it should be keep in the memory.So I use the singleton   
  coding style to program this class.
  Singleton:
  1.Declare the _singletonCommunicator as static 
  2.The _singletonCommunicator class will be bulid only once and will keep in the memory.
<img src="https://github.com/chen-chien-lung/IOS_ChattingRoom/blob/master/singleton.png?raw=true">

6.Send and get photo from/to server.
  In this app we use AFHTTPSessionManager class to handle all the POST and GET function
<img src="https://github.com/chen-chien-lung/IOS_ChattingRoom/blob/master/sendPhoto.png?raw=true">
<img src="https://github.com/chen-chien-lung/IOS_ChattingRoom/blob/master/downloadPhoto.png?raw=true">

7.We can send message and image in this app ,so we need two kinds of POST methods.
<img src="https://github.com/chen-chien-lung/IOS_ChattingRoom/blob/master/doPost_text.png?raw=true">
<img src="https://github.com/chen-chien-lung/IOS_ChattingRoom/blob/master/doPost_image.png?raw=true">


