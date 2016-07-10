//
//  ChattingBubbleView.m
//  HelloMySendMessage
//
//  Created by Joe Chen on 2016/6/23.
//  Copyright © 2016年 Joe Chen. All rights reserved.
//

#import "ChattingBubbleView.h"

//Contents of UI layout
#define SIDE_PADDING_RATE       0.02 //泡泡跟螢幕的邊緣距離
#define MAX_BUBBLE_WIDTH_RATE   0.7  //泡泡寬最大到整個螢幕的70%
#define CONTENT_MARGIN          10.0 //泡泡內的文字內容跟泡泡被邊緣的距離
#define BUBBLE_TALE_WIDTH       10.0 //泡泡尾巴的長度
#define TEXT_FONT_SIZE          16.0

@interface ChattingBubbleView ()
{
    //SubViews
    UIImageView * chattingImageView;
    UILabel * chattingLabel;
    UIImageView * backgroundImageView;
}

@end

@implementation ChattingBubbleView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(instancetype) initWithItem :(ChattingItem*)item offsetY:(CGFloat)offsetY;{
    
    //Step1:calculate a basic frame
    self = [super initWithFrame:CGRectZero];
    self.frame = [self calculateBasicFrame:item.type offsetY:offsetY];
    
    //Step2:calculate with image
    CGFloat currentY = 0.0;
    UIImage * image = item.image;
    if(image != nil){
        CGFloat x = CONTENT_MARGIN;
        CGFloat y = CONTENT_MARGIN;
        
        //訊息是對方傳來的話 內容的座標x要加讓尾巴的寬度
        if(item.type == fromOthers){
            x += BUBBLE_TALE_WIDTH;
        }
        
        //比較照片的寬度和圖片能顯示的最大寬 取小的值
        CGFloat displayWidth = MIN(image.size.width,self.frame.size.width-2*CONTENT_MARGIN-BUBBLE_TALE_WIDTH);
        CGFloat displayRatio = displayWidth / image.size.width;
        CGFloat displayHeight = image.size.height * displayRatio;
        
        
        CGRect displayFrame = CGRectMake(x, y, displayWidth, displayHeight);
        
        //prepare chattingImageView
        chattingImageView = [[UIImageView alloc] initWithFrame:displayFrame];
        chattingImageView.image = image;
        chattingImageView.layer.cornerRadius = 5.0;
        chattingImageView.layer.masksToBounds = true;
        
        [self addSubview:chattingImageView];
        
        currentY = CGRectGetMaxY(displayFrame);
        
    }
    
    //step3:calculate with text
    NSString * text = item.text;
    if(text != nil){
        
        CGFloat x = CONTENT_MARGIN;
        CGFloat y = currentY + TEXT_FONT_SIZE/2;
        if(item.type == fromOthers){
            x += BUBBLE_TALE_WIDTH;
        }
        
        CGRect displayFrame = CGRectMake(x, y, self.frame.size.width-2*CONTENT_MARGIN - BUBBLE_TALE_WIDTH, TEXT_FONT_SIZE);
        
        //Create Label
        chattingLabel = [[UILabel alloc] initWithFrame:displayFrame];
        chattingLabel.font = [UIFont systemFontOfSize:TEXT_FONT_SIZE];
        chattingLabel.numberOfLines = 0; //基於內容多寡來指定高度
        chattingLabel.text = text;
        [chattingLabel sizeToFit];
        
        [self addSubview:chattingLabel];
        
        currentY = CGRectGetMaxY(chattingLabel.frame);
        
    }
    //step4:calculate bubble view size
    CGFloat finalHeight = currentY + CONTENT_MARGIN;
    CGFloat finalWidth = 0.0;
    
    if(chattingImageView != nil){
        if(item.type == fromMe){
            finalWidth = CGRectGetMaxX(chattingImageView.frame)+CONTENT_MARGIN+BUBBLE_TALE_WIDTH;
            
        }else{
            //fromOthers
            finalWidth = CGRectGetMaxX(chattingImageView.frame)+CONTENT_MARGIN;
        }
    }
    
    if(chattingLabel != nil){
        
        CGFloat labelWidth = 0;
        
        if(item.type == fromMe){
            labelWidth = CGRectGetMaxX(chattingLabel.frame)+CONTENT_MARGIN+BUBBLE_TALE_WIDTH;
            
        }else{
            //fromOthers
            labelWidth = CGRectGetMaxX(chattingLabel.frame)+CONTENT_MARGIN;
        }
        finalWidth = MAX(finalWidth,labelWidth);
    }
    
    //調整自己發出的文字如果只有文字 而且文字很短的話 要把文字往右移
    CGRect selfFrame = self.frame;
    if(item.type == fromMe && chattingImageView == nil){
        selfFrame.origin.x += selfFrame.size.width - finalWidth;
    }
    selfFrame.size.width = finalWidth;
    selfFrame.size.height = finalHeight;
    self.frame = selfFrame;
    
    //step5:handle background display
    [self prepareBackgroundImageView:item.type];
    
    return self;
}

-(void) prepareBackgroundImageView:(ChattingItemType) type {
    
    CGRect bgImageViewFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    backgroundImageView = [[UIImageView alloc]initWithFrame:bgImageViewFrame];
    
    if(type == fromMe){
        UIImage * image = [UIImage imageNamed:@"fromMe.png"];
        image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(14, 14, 17, 28)];
        backgroundImageView.image = image;
        
    }else{
        //fromOthers
        UIImage * image = [UIImage imageNamed:@"fromOthers.png"];
        image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(14, 22, 17, 20)];
        backgroundImageView.image = image;
    }
    [self addSubview:backgroundImageView];
    [self sendSubviewToBack:backgroundImageView];//因為已經貼了文字或照片所以再貼這圖會疊在上面 要把他往後移
    
}

-(CGRect) calculateBasicFrame:(ChattingItemType)type offsetY:(CGFloat)offsetY{
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat sidePadding = screenWidth * SIDE_PADDING_RATE;
    CGFloat maxWidth = screenWidth * MAX_BUBBLE_WIDTH_RATE;
    
    CGFloat offsetX;
    if(type == fromMe){
        offsetX = screenWidth - sidePadding - maxWidth;
    }else{
        //fromOthers
        offsetX = sidePadding;
    }
    
    return CGRectMake(offsetX, offsetY, maxWidth, 10);
}

@end
