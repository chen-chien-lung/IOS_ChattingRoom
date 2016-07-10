//
//  ChattingBubbleView.h
//  HelloMySendMessage
//
//  Created by Joe Chen on 2016/6/23.
//  Copyright © 2016年 Joe Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChattingItem.h"

@interface ChattingBubbleView : UIView

-(instancetype) initWithItem :(ChattingItem*)item offsetY:(CGFloat)offsetY;


@end
