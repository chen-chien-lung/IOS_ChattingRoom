//
//  ChattingView.m
//  HelloMySendMessage
//
//  Created by Joe Chen on 2016/6/23.
//  Copyright © 2016年 Joe Chen. All rights reserved.
//

#import "ChattingView.h"
#import "ChattingBubbleView.h"

#define Y_PADDING 20

@interface ChattingView()
{
    CGFloat lastChattingBubbleViewY;
    NSMutableArray * allChattingItems;
    
}
@end

@implementation ChattingView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void) addChattingItem:(ChattingItem *) item{
    
    if(!allChattingItems){
        allChattingItems = [NSMutableArray new];
    }
    
    ChattingBubbleView * bubbleView = [[ChattingBubbleView alloc]initWithItem:item offsetY:lastChattingBubbleViewY + Y_PADDING];
    
    [self addSubview:bubbleView];
    
    lastChattingBubbleViewY = CGRectGetMaxY(bubbleView.frame);
    self.contentSize = CGSizeMake(self.frame.size.width,lastChattingBubbleViewY);
    
    //scroll to bottom scrollRectToVisible讓scrollview捲動到指定的區塊出現為止
    [self scrollRectToVisible:CGRectMake(0, lastChattingBubbleViewY-1, 1, 1) animated:true];
    
    //keep the item
    [allChattingItems addObject:item];
}


@end
