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


<pre>
-(void)doPost:(NSString*) urlString parameters:(NSDictionary*)
parameters completion:(DoneHandler)doneHandler{
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    
    //change parameters to format: "data=..."
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
    NSString * jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSDictionary * finalParameters = @{DATA_KEY:jsonString};
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [manager POST:urlString parameters:finalParameters progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task,id _Nonnull responseObject){
              
              NSLog(@"doPOST OK Result:%@",responseObject);
              doneHandler(nil,responseObject);
        
          }failure:^(NSURLSessionDataTask * _Nonnull task,NSError *_Nonnull error){
              
              NSLog(@"doPOST Error:%@",error);
              doneHandler(error,nil);
        
          }
    ];
    
}
</pre>
