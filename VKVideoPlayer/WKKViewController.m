//
//  WKKViewController.m
//  CameraWithAVFoudation
//
//  Created by 可可 王 on 12-7-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "WKKViewController.h"
#import "CameraImageHelper.h"
#import "SVProgressHUD.h"
#import "UIButton+WebCache.h"
//#import "Image.h"
//#import "Photo.h"
//#import "Note.h"
//#import "Customer.h"

@interface WKKViewController ()
@property(retain,nonatomic) CameraImageHelper *CameraHelper;
@end

@implementation WKKViewController
@synthesize RealView;
@synthesize liveView;
@synthesize Preview;


- (void)saveImage:(id)sender
{
    
//    NSString *pid = [NSString md5Date];
//    
//    NSString *stroe_name = [NSString stringWithFormat:@"%@.jpg",  pid]  ;
//    
//    
//    NSData *data =  UIImageJPEGRepresentation(self.Preview.image, KcompressionQuality);
//    [data writeToFile:KDocumentName(stroe_name) atomically:YES];
//    
//    Photo *p = [Photo createEntity];
//    
//    p.photo_id = pid;
//    p.sync = Sync_Unsync;
//    p.create_time = [NSDate date];
//    p.update_time = [NSDate date];
//    p.stroe_name = stroe_name;
    
//    if (self.note) {
//        p.note_id = self.note.note_id;
//    }
//    else {
//        Note *n = [Note createEntity];
//        n.note_id = [NSString md5Date];
//        n.cstm_id = self.customer.customer_id;
//        n.sync = Sync_Unsync;
//        n.create_time = [NSDate date];
//        n.update_time = [NSDate date];
//        
//        self.note = n;
//        
//        p.note_id = self.note.note_id;
//
//    }

//    [[NSManagedObjectContext defaultContext] saveToPersistentStoreWithCompletion:nil];
//    
//
//    [self back:nil];
    
}

- (void)actionControl:(UIButton *)button
{
    switch (button.tag) {
        case 2001:
        {
//            保存
            [self saveImage:nil];
            break;
        }
        case 2002:
        {
            //            重拍
            [self redoPhoto:nil];
            break;
        }
        case 2003:
        {
            //            返回
            [self back:nil];

            break;
        }
        default:
            break;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
  
    
    _CameraHelper = [[CameraImageHelper alloc]init];
    
    // 开始实时取景
    [_CameraHelper startRunning];
    [_CameraHelper embedPreviewInView:self.liveView];

    [_CameraHelper changePreviewOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
    
    
    _showView.alpha = 0;
    
//    [self getNetImages];
//    
//    [[ImageView share] addToView:self.view imagePathName:@"" rect:RectMake2x(140, 995, 130, 140)];
//    [[ImageView share] addToView:self.view imagePathName:@"" rect:RectMake2x(140, 1148, 130, 140)];
//    [[ImageView share] addToView:self.view imagePathName:@"" rect:RectMake2x(140,1304, 130, 140)];
    
    
    submitButton =  [[Button share] addToView:self.view addTarget:self
                         rect:RectMake2x(140, 995, 130, 140)
                          tag:2001 action:@selector(actionControl:)
                    imagePath:@"相机按钮-确定-00"
         highlightedImagePath:@"相机按钮-确定-01"];
    
    [submitButton setEnabled:NO];
    
    
    
    redoButton =   [[Button share] addToView:self.view addTarget:self
                         rect:RectMake2x(140, 1148, 130, 140)
                          tag:2002 action:@selector(actionControl:)
                    imagePath:@"相机按钮-删除-00"
         highlightedImagePath:@"相机按钮-删除-01"];
    [redoButton setEnabled:NO];

    [[Button share] addToView:self.view addTarget:self
                         rect:RectMake2x(140,1304, 130, 140)
                          tag:2003 action:@selector(actionControl:)
                    imagePath:@"相机按钮-返回-00"
         highlightedImagePath:@"相机按钮-返回-00"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:YES];
    
    [self setPreview:nil];
    
    [_CameraHelper stopRunning];
    [_CameraHelper removeAVObserver];
    
    
    
    [self setRealView:nil];
    [self setLiveView:nil];
}



- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [_CameraHelper changePreviewOrientation:(UIInterfaceOrientation)toInterfaceOrientation];
}


- (void)putImage
{
    
    
    [SVProgressHUD showWithStatus:@"正在上传图片..." maskType:SVProgressHUDMaskTypeGradient];

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFXMLParserResponseSerializer new];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/xml"];
    
    
//    UIImage *i = [UIImage imageNamed:@"按钮-材料变更单-1"];
//    NSData *d = [NSData dataWithData: UIImagePNGRepresentation(i)];
//
//    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//
//    
//    NSData *dataImage = [[NSData alloc] init];
//    dataImage = UIImagePNGRepresentation(i);
    NSData *data =  UIImageJPEGRepresentation(self.Preview.image, .8);

    NSString * str = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    
//    
//    NSDictionary *parameters = @{ @"stringToConvert":  str,
//                                  @"orderId":_orderID,
//                                  @"itemId": _itemId,
//                                  @"type": [NSNumber numberWithInt:_type]};
// 
//    NSString *urlString = [NSString stringWithFormat:@"%@Tositrust.asmx/UploadImage", KHomeUrl];
//
//    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        [SVProgressHUD dismiss];
//
//        
//        [self redoPhoto:nil];
//        
//        NSError *parseError = nil;
//        NSDictionary *xmlDictionary= [XMLReader dictionaryForParse:responseObject error:&parseError];
//        
//        NSString *s = [xmlDictionary[@"string"] objectForKey:@"text"];
//        
//        
//        if ( [s isEqualToString:@"成功"]) {
//            [[Message share] messageAlert:@"上传成功，您可以继续拍照上传!"];
//            
//            [self getNetImages];
//        }
//        else {
//            [[Message share] messageAlert:@"上传失败，请稍后尝试。"];
//
//        }
//
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [SVProgressHUD dismiss];
//        [self redoPhoto:nil];
//        [[Message share] messageAlert:KString_Server_Error];
//        DLog(@"%s: AFHTTPRequestOperation error: %@", __FUNCTION__, error);
//    }];
//    
    
}

- (void)clipImage
{
    
    CGSize size = CGSizeMake( [_CameraHelper image].size.width* 1/5, [_CameraHelper image].size.height* 1/5) ;
//    UIImage *image = [Image imageWithImage:[_CameraHelper image] scaledToSize:size];
//    
//    if (image) {
        self.Preview.image = [_CameraHelper image] ;
        _showView.alpha = 1;
//    }
    
    

}

-(void)getImage
{
    
    [submitButton setEnabled:YES];
    [redoButton setEnabled:YES];
    
    
    [submitButton setHighlighted:YES];
    [redoButton setHighlighted:YES];
    
    
    
    [self clipImage];
  
}

- (IBAction)snapPressed:(id)sender {


//    if (self.dataMArray.count == 5) {
//        
//        [[Message share] messageAlert:@"已经到达了可拍摄照片的最大数量，  请点击左下角的返回！"];
//        return;
//    }
    
    [_CameraHelper CaptureStillImage];
    [self performSelector:@selector(getImage) withObject:nil afterDelay:0.5];
}

- (IBAction)back:(id)sender {

    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"noteRefreshNote" object:nil];


    
}

- (IBAction)redoPhoto:(id)sender {
    
    _showView.alpha = 0;
    Preview.image = nil;
    
    
    [submitButton setEnabled:NO];
    [redoButton setEnabled:NO];
    [submitButton setHighlighted:NO];
    [redoButton setHighlighted:NO];

}

- (IBAction)updateImage:(id)sender {
    

    [self putImage];

}


- (void)closeMe:(UIButton *)button
{
    [button removeFromSuperview];
}

- (void)openView:(UIButton *)button
{
  
    
    UIButton *b =  [[Button share] addToView:self.view addTarget:self rect:  self.view.frame  tag:2100 action:@selector(closeMe:)];
    b.frame = self.view.frame;
    
    
    [b setImage:button.imageView.image forState:UIControlStateNormal];

}

- (void)scrollV
{
    
    for (int  i = 1000; i < 1006; i ++) {
        
        UIButton *b = (UIButton *)[self.view viewWithTag:i];
        
        if (b) {
            [b removeFromSuperview];
        }
    }
    
    int x = 390;
    int y =  1260;

//    for (int i = 0;  i< self.dataMArray.count; i++) {
//        
//        UIButton *b =  [[Button share] addToView:self.view addTarget:self rect:RectMake2x(x + i*323 , y, 317, 236) tag:i +1000 action:@selector(openView:)];
//        NSString *string = self.dataMArray[i][@"text"];
//        NSURL *url = [[NSURL alloc] initWithString:string];
//
//        [b setImageWithURL:url forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"照相页面-小图-底图"]  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
//
//        }];
//    }
}

- (void)getNetImages
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFXMLParserResponseSerializer new];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/xml"];
//    
//    NSDictionary *parameters = @{
//                                  @"orderId":_orderID,
//                                  @"itemId": _itemId,
//                                  @"type": [NSNumber numberWithInt:_type]};
//    
//    NSString *urlString = [NSString stringWithFormat:@"%@Tositrust.asmx/GetImageInfo", KHomeUrl];
//
//    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        
//        NSError *parseError = nil;
//        NSDictionary *xmlDictionary= [XMLReader dictionaryForParse:responseObject error:&parseError];
//        
//        NSString *s = [xmlDictionary[@"string"] objectForKey:@"text"];
//        
//        NSDictionary *dictionary= [XMLReader dictionaryForXMLString:s error:&parseError];
//
//        
//        if ( [dictionary[@"ArrayOfString"][@"string"] isKindOfClass:[NSMutableDictionary class]] ) {
//            
//            self.dataMArray = [[NSMutableArray alloc]     initWithObjects: dictionary[@"ArrayOfString"][@"string"], nil];
//        }
//        else {
//            
//            self.dataMArray = dictionary[@"ArrayOfString"][@"string"];
//        }
//        [self scrollV];
//        
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [SVProgressHUD dismiss];
//        [[Message share] messageAlert:KString_Server_Error];
//        DLog(@"%s: AFHTTPRequestOperation error: %@", __FUNCTION__, error);
//    }];
}
@end
