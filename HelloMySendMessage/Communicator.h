//
//  Communicator.h
//  HelloMySendMessage
//
//  Created by Joe Chen on 2016/6/17.
//  Copyright © 2016年 Joe Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ID_KEY    @"id"
#define USER_NAME_KEY    @"UserName"
#define MESSAGE_KEY    @"Message"
#define DEVICETOKEN_KEY    @"DeviceToken"
#define GROUP_NAME_KEY    @"GroupName"
#define LAST_MESSAGE_ID_KEY    @"LastMessageID"
#define TYPE_KEY    @"Type"
#define MESSAGES_KEY    @"Messages"

#define GROUP_NAME  @"AP102"
#define MY_NAME @"Joe"
#define DATA_KEY @"data"

typedef void (^DoneHandler)(NSError *error,id result);

@interface Communicator : NSObject

+(instancetype)shareInstance;

//-(void)updateDeviceToken:(NSString*) deviceToken
//              completion:(void (^)(NSError *error,id result))
//                doneHandler;

-(void)updateDeviceToken:(NSString*) deviceToken
              completion:(DoneHandler) doneHandler;

-(void)sendTextMessage:(NSString*) message
              completion:(DoneHandler) doneHandler;


-(void) retriveMessageWithLastMessageID:(NSInteger)lastMessageID
                             completion:(DoneHandler)doneHandler;

-(void) downloadPhotoWithFileName:(NSString*) fileName
                       completion:(DoneHandler) doneHandler;

-(void)sendPhotoMessageWithData:(NSData*)data
                     completion:(DoneHandler)doneHandler;

@end
