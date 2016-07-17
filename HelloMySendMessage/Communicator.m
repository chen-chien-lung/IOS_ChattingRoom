//
//  Communicator.m
//  HelloMySendMessage
//
//  Created by Joe Chen on 2016/6/17.
//  Copyright © 2016年 Joe Chen. All rights reserved.
//

#import "Communicator.h"
#import <AFNetworking/AFNetworking.h>

@implementation Communicator

#define BASE_URL @""

#define SENDMESSAGE_URL [BASE_URL stringByAppendingPathComponent:@"sendMessage.php"]

#define SENDPHOTOMESSAGE_URL [BASE_URL stringByAppendingPathComponent:@"sendPhotoMessage.php"]

#define RETRIVEMESSAGES_URL [BASE_URL stringByAppendingPathComponent:@"retriveMessages2.php"]

#define UPDATEDEVICETOKEN_URL [BASE_URL stringByAppendingPathComponent:@"updateDeviceToken.php"]

#define PHOTOS_BASE_URL [BASE_URL stringByAppendingPathComponent:@"photos/"]

static Communicator * _singletonCommunicator =nil;

+(instancetype) shareInstance{
    if(_singletonCommunicator == nil){
        _singletonCommunicator = [Communicator new];
    }
    return _singletonCommunicator;
    
}

//deviceToken發送推播時可以讓apple找到此裝置 就像是一個身分證號
-(void)updateDeviceToken:(NSString *)deviceToken
              completion:(DoneHandler)doneHandler
{
    NSDictionary * jsonObj = @{USER_NAME_KEY:MY_NAME,DEVICETOKEN_KEY:deviceToken,GROUP_NAME_KEY:GROUP_NAME};
    
    [self doPost:UPDATEDEVICETOKEN_URL parameters:jsonObj completion:doneHandler];
    
}

-(void)sendTextMessage:(NSString *)message completion:(DoneHandler)doneHandler{
    
    NSDictionary * jsonObj = @{USER_NAME_KEY:MY_NAME,MESSAGE_KEY:message,GROUP_NAME_KEY:GROUP_NAME};
    
    [self doPost:SENDMESSAGE_URL parameters:jsonObj completion:doneHandler];
    
}

-(void) downloadPhotoWithFileName:(NSString*) fileName
                       completion:(DoneHandler) doneHandler{
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"image/jpeg"];
    
    NSString * finalPhotoURLString = [PHOTOS_BASE_URL stringByAppendingPathComponent:fileName];
    
    [manager GET:finalPhotoURLString
      parameters:nil
        progress:nil
    success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"Download OK: %ld bytes",[responseObject length]);
        doneHandler(nil,responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       
        
        NSLog(@"Download Fail:%@",error);
        doneHandler(error,nil);
    }];
}

-(void)sendPhotoMessageWithData:(NSData*)data
                     completion:(DoneHandler)doneHandler{
    NSDictionary * jsonObj = @{USER_NAME_KEY:MY_NAME,GROUP_NAME_KEY:GROUP_NAME};
    
    [self doPost:SENDPHOTOMESSAGE_URL parameters:jsonObj data:data completion:doneHandler];
    
}


#pragma mark - Shared Methods
//image
-(void)doPost:(NSString*) urlString parameters:(NSDictionary*)
parameters data:(NSData*)data completion:(DoneHandler)doneHandler{

    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    
    //change parameters to format: "data=..."
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
    NSString * jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSDictionary * finalParameters = @{DATA_KEY:jsonString};
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:urlString parameters:finalParameters
    constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [formData appendPartWithFileData:data name:@"fileToUpload" fileName:@"image.jpg" mimeType:@"image/jpg"];
    } progress:nil
    success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"doPOST OK Result:%@",responseObject);
        doneHandler(nil,responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"doPOST Error:%@",error);
        doneHandler(error,nil);
    }];
}

//text
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

-(void)retriveMessageWithLastMessageID:(NSInteger)lastMessageID completion:(DoneHandler)doneHandler{
    
    
    NSDictionary * jsonObj = @{LAST_MESSAGE_ID_KEY:@(lastMessageID),GROUP_NAME_KEY:GROUP_NAME};
    
    [self doPost:RETRIVEMESSAGES_URL parameters:jsonObj completion:doneHandler];

    
    
    
    
}

@end
