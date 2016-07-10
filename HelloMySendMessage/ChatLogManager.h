//
//  ChatLogManager.h
//  HelloMySendMessage
//
//  Created by Joe Chen on 2016/6/24.
//  Copyright © 2016年 Joe Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ChatLogManager : NSObject

+(void)savePhotoWithFileName:(NSString*) originalFileName data:(NSData*)data;

+(UIImage*) loadPgotoWithFileName: (NSString*)origialFileName;

-(void) addChatLog:(NSDictionary*)messageDictionary;

-(NSInteger) getTotalCount;
-(NSDictionary*) getMessageByIndex:(NSInteger)index;

@end
