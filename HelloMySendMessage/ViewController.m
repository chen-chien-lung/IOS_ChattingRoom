//
//  ViewController.m
//  HelloMySendMessage
//
//  Created by Joe Chen on 2016/6/17.
//  Copyright © 2016年 Joe Chen. All rights reserved.
//

#import "ViewController.h"
#import "Communicator.h"
#import "AppDelegate.h"
#import "ChattingView.h"
#import  <MobileCoreServices/MobileCoreServices.h>
#import "ChatLogManager.h"

@interface ViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    Communicator * comm;
    NSMutableArray * incomingMessages;
    NSInteger lastMessageID;
    ChatLogManager *logManager;
    
    BOOL isRefreshing;
    BOOL shouldRefreshAgain;
}
@property (weak, nonatomic) IBOutlet ChattingView *chattingView;
@property (weak, nonatomic) IBOutlet UITextField *inputTextField;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    incomingMessages = [NSMutableArray new];
    logManager = [ChatLogManager new];
    comm = [Communicator shareInstance];
    
    //Listen to the notification :DID_RECEIVED_REMOTE_NOTIFICATION
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(doRefresh) name:DID_RECEIVED_REMOTE_NOTIFICATION object:nil];
    
    //Load lastMessageID from NSUserDefault
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    lastMessageID = [defaults integerForKey:LAST_MESSAGE_ID_KEY];
    if(lastMessageID == 0){
        lastMessageID = 1;
    }

    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //show lastest log
    NSInteger totalCount = [logManager getTotalCount];
    NSInteger startIndex = totalCount-20;
    if(startIndex < 0){
        startIndex = 0;
    }
    for(NSInteger i = startIndex;i<totalCount;i++){
        NSDictionary * tmpMessage = [logManager getMessageByIndex:i];
        [incomingMessages addObject:tmpMessage];
    }
    [self handleIcomingMessages:false];
    
    //Download when VC is launched
    [self doRefresh];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)SendPhotoBtnPressed:(id)sender {
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Choose Image Source" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * camera = [UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self launchImagePickerWithSourceType:UIImagePickerControllerSourceTypeCamera];
        
    }];
    UIAlertAction * library = [UIAlertAction actionWithTitle:@"Photo Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self launchImagePickerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:nil];
    
    [alert addAction:camera];
    [alert addAction:library];
    [alert addAction:cancel];
    [self presentViewController:alert animated:true completion:nil];
    
}

-(void) launchImagePickerWithSourceType:(UIImagePickerControllerSourceType)sourceType{
    
    if([UIImagePickerController isSourceTypeAvailable:sourceType] == false){
        NSLog(@"Invail Source Type.");
        return;
    }
    
    UIImagePickerController * imagePicker = [UIImagePickerController new];
    imagePicker.sourceType = sourceType;
    imagePicker.mediaTypes = @[@"public.image"];
   // imagePicker.mediaTypes = @[(NSString*)kUTTypeImage,(NSString*)kUTTypeMovie];
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:true completion:nil];
}

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    NSString * mediaType = info[UIImagePickerControllerMediaType];
    
    if([mediaType isEqualToString:@"public.image"]){
        UIImage * originalImage = info[UIImagePickerControllerOriginalImage];
        
        UIImage * resizedImage = [self resizeWithImage:originalImage];
        
        NSData * imageData = UIImageJPEGRepresentation(resizedImage, 0.7);
        NSLog(@"Image Size: %f x %f,File Size: %ld",resizedImage.size.width,resizedImage.size.height,imageData.length);
        
        [comm sendPhotoMessageWithData:imageData completion:^(NSError *error, id result) {
            if(error){
                NSLog(@"* Error occur: %@",error);
                //show error message
            }else{
                //Download and Refresh
                [self doRefresh];
            }
        }];
    }
    [picker dismissViewControllerAnimated:true completion:nil];
}

-(UIImage*) resizeWithImage:(UIImage*) srcImage{
    
    CGFloat maxLength = 1024.0;
    CGSize targetSize;
    
    //No need to resize. Use original image
    if(srcImage.size.width <= maxLength && srcImage.size.height <=maxLength){
        targetSize = srcImage.size;
    }else{
        if(srcImage.size.width >= srcImage.size.height){
            CGFloat ratio = srcImage.size.width / maxLength;
            targetSize = CGSizeMake(maxLength, srcImage.size.height/ratio);
        }else{
            CGFloat ratio = srcImage.size.height / maxLength;
            targetSize = CGSizeMake(srcImage.size.width/ratio,maxLength);
        }
    }
    
    //resize the srcImage as targetSize
    //UIGraphicsBeginImageContext 在系統內產生一個虛擬畫布 drawInRect把改變後的圖片畫在虛擬畫面上(自己會畫)
    //UIGraphicsGetImageFromCurrentImageContext 取得虛擬畫布
    UIGraphicsBeginImageContext(targetSize);
    [srcImage drawInRect:CGRectMake(0, 0, targetSize.width, targetSize.height )];
    
    UIImage * frameImage = [UIImage imageNamed:@"frame_01.png"];
    [frameImage drawInRect:CGRectMake(0, 0, targetSize.width, targetSize.height)];
    
    UIImage * resultImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //記得要釋放記憶體！！！！！！
    UIGraphicsEndImageContext();
    
    return resultImage;
    
}

- (IBAction)SendTextBtnPressed:(id)sender {
    
    if(_inputTextField.text.length == 0){
        
        return;
    }
    [_inputTextField resignFirstResponder];
    [comm sendTextMessage:_inputTextField.text completion:^(NSError *error, id result) {
        
        if(error){
            NSLog(@"* Error occur: %@",error);
            //show error message
        }else{
            //Download and Refresh
            [self doRefresh];
        }
    }];
}

-(void) doRefresh {
    
    if(isRefreshing == false){
        isRefreshing = true;
    }else{
        shouldRefreshAgain = true;
        return;
    }
    
    
    [comm retriveMessageWithLastMessageID:lastMessageID completion:^(NSError *error, id result) {
        
        if(error){
            NSLog(@"* Error occur: %@",error);
            //show error message
            isRefreshing = false;
        }else{
            
            //handle incoming messages
            NSArray * messages = result[MESSAGES_KEY];
            if(messages.count == 0){
                NSLog(@"No New message,then do nothing");
                isRefreshing = false;
                return;
            }
            
            //keep lastMessageID
            NSDictionary * lastMessage = messages.lastObject;
            lastMessageID = [lastMessage[ID_KEY] integerValue];
            
            //save lastMassageID to NSUserDefault
            NSUserDefaults *dafaults =  [NSUserDefaults standardUserDefaults];
            [dafaults setInteger:lastMessageID forKey:LAST_MESSAGE_ID_KEY];
            [dafaults synchronize];
            
            [incomingMessages addObjectsFromArray:messages];
            
            [self handleIcomingMessages:true];
        }
    }];
    
}

-(void)handleIcomingMessages:(BOOL)shouldSaveToLog{
    
    if(incomingMessages.count == 0){
        isRefreshing = false;
        if(shouldRefreshAgain){
            shouldRefreshAgain = false;
            [self doRefresh];
        }
        return;
    }
    NSDictionary * tmpMessage = incomingMessages.firstObject;
    [incomingMessages removeObjectAtIndex:0];
    
    //add to logManager 每一筆訊息進來就把它存進去資料庫
    if(shouldSaveToLog){
        [logManager addChatLog:tmpMessage];
    }
    
    NSInteger messageID = [tmpMessage[ID_KEY] integerValue];
    NSInteger messageType = [tmpMessage[TYPE_KEY] integerValue];
    
    NSString * senderName = tmpMessage[USER_NAME_KEY];
    NSString * message = tmpMessage[MESSAGE_KEY];
    if(messageType == 0){
        //text
        NSString * displayMessage = [NSString stringWithFormat:@"%@: %@ (%ld)",senderName,message,messageID];
        
       
        [self addChatItemWithMessage:displayMessage image:nil sender:senderName];
        
        //move to next message
        [self handleIcomingMessages:shouldSaveToLog];
        
    }else{
        //Image
        
        UIImage * image = [ChatLogManager loadPgotoWithFileName:message];
        if(image != nil){
            //Photo is cached,use it directly
            NSString * displayMessage = [NSString stringWithFormat:@"%@: %@ (%ld)",senderName,message,messageID];
            [self addChatItemWithMessage:displayMessage image:image sender:senderName];
            //move to next message
            [self handleIcomingMessages:shouldSaveToLog];
            
        }else{
            //need to load from server
            [comm downloadPhotoWithFileName:message completion:^(NSError *error, id result) {
                
                if(error){
                    NSLog(@"*error occur: %@",error);
                }else{
                    NSString * displayMessage = [NSString stringWithFormat:@"%@:%@ (%ld)",senderName,message,messageID];
                    [self addChatItemWithMessage:displayMessage image:[UIImage imageWithData:result] sender:senderName];
                    
                    //Save Image as a cached file
                    [ChatLogManager savePhotoWithFileName:message data:result];
                }
                //move to next message
                [self handleIcomingMessages:shouldSaveToLog];
            }];
        }
    }
}

-(void)addChatItemWithMessage:(NSString*)message image:(UIImage*)image sender:(NSString*)senderName{
    
    //decede it is fromMe or fromOthers
    ChattingItem * item = [ChattingItem new];
    item.text =message;
    if([senderName isEqualToString:MY_NAME]){
        item.type = fromMe;
    }else{
        item.type = fromOthers;
    }
    item.image = image;
    [_chattingView addChattingItem:item];

}

@end




