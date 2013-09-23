//
//  CreateWeiboViewController.m
//  WuTongCity
//
//  Created by alan  on 13-8-15.
//  Copyright (c) 2013年 alan. All rights reserved.
//

#import "CreateWeiboViewController.h"
#import "TopicVO.h"
#import "DateUtil.h"
#import "WeiBoViewController.h"
#import "LocalDirectory.h"
#import "ImageUtil.h"

@interface CreateWeiboViewController ()

@end

@implementation CreateWeiboViewController

- (id)init{
    self = [super init];
    if (self) {
        faceBoardShow = NO;//默认表情键盘没有打开
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    dataCenter = [DataCenter sharedInstance];
    //为使用tableview定义的临时数据
    tempDict = [[NSMutableDictionary alloc]initWithObjectsAndKeys:[NSArray arrayWithObject:@"1"],@"1",[NSArray arrayWithObject:@"2"],@"2", nil];
    tempArray = [[NSArray alloc]initWithArray:[[tempDict allKeys]sortedArrayUsingSelector:@selector(compare:)]];
    
    //初始默认给一个加好图片按钮
    imageArray = [[NSMutableArray alloc]initWithObjects:@"more.png", nil];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"取消"
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(goback)];
    self.navigationItem.leftBarButtonItem = leftButton;

    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"发布"
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(sendWeibo)];
    self.navigationItem.rightBarButtonItem = anotherButton;
    

    createWeiboTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 480) style:UITableViewStyleGrouped];
    createWeiboTableView.dataSource = self;
    createWeiboTableView.delegate = self;
    [self.view addSubview:createWeiboTableView];
    
//    //建立UIToolbar
//    UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
//    //表情按钮
//    faceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    faceBtn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin;
//    [faceBtn setBackgroundImage:[UIImage imageNamed:@"face"] forState:UIControlStateNormal];
//    [faceBtn addTarget:self action:@selector(showPhraseInfo) forControlEvents:UIControlEventTouchUpInside];
//    faceBtn.frame = CGRectMake(30.0f,toolBar.bounds.size.height-38.0f,34,34);
//    [toolBar addSubview:faceBtn];
    
    //初始化文本框
    weiboTextView = [[UITextView alloc]initWithFrame:CGRectMake(10, 10, 280, 80)];
    weiboTextView.font = [UIFont systemFontOfSize:14];
    weiboTextView.delegate = self;
//    weiboTextView.inputAccessoryView = toolBar;
    
    //初始化表情键盘
//    _faceBoard = [[FaceBoard alloc]init];
//    _faceBoard.delegate = self;
    
    //添加点击手势--点击撤销键盘
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    gestureRecognizer.cancelsTouchesInView = NO;
    [createWeiboTableView addGestureRecognizer:gestureRecognizer];

}

//tableview------------------------------------start--------------------------------------------------
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [tempDict allKeys].count;//返回分组数量,即Array的数量
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSString *key=[tempArray objectAtIndex:section];//返回当前分组对应neighbourDict的key值
    NSArray *sectionArray=[tempDict objectForKey:key];//根据key，取得Array
    return [sectionArray count]; //返回Array的大小
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * tableIdentifier=@"CreateWeiboCell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:tableIdentifier];
    if(cell==nil){
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableIdentifier];
    }
    
    NSString *key = [tempArray objectAtIndex:[indexPath section]];
    NSArray *section = [tempDict objectForKey:key];
    NSString *type = [section objectAtIndex:[indexPath row]];
    switch ([type intValue]) {
        case 1://设置文本框
            [cell.contentView addSubview:weiboTextView];
            cell.frame = CGRectMake(0, 0, 320, 100);
            break;
        case 2:{//设置图片
            
            UIButton *imgBtn;
            int imgBtnX = 20, imgBtnY = 10;
            if(imageArray.count > 0){
                int imgBtnHeight = 60, imgBtnWidth = 60;
                for (int i=0; i<imageArray.count; i++) {
                    NSString *imageName = [imageArray objectAtIndex:i];
                    imgBtn = [[UIButton alloc] initWithFrame:CGRectMake(imgBtnX,imgBtnY,imgBtnHeight,imgBtnWidth)];
                    if ([imageName isEqualToString:@"more.png"]) {//添加图片
//                        imagePath = [[LocalDirectory imageFileDirectory] stringByAppendingPathComponent:imageName];
                        [imgBtn setBackgroundImage:[UIImage imageNamed:@"more.png"] forState:UIControlStateNormal];
                        [imgBtn addTarget:self action:@selector(showImageRes) forControlEvents:UIControlEventTouchUpInside];
//                        [imgBtn setBackgroundImage:[UIImage imageNamed:@"more.png"] forState:UIControlStateNormal];
//                        [imgBtn setBackgroundImage:[UIImage imageNamed:@"more.png"] forState:UIControlStateHighlighted];
////                    、 [imgBtn setBackgroundImage:[UIImage imageNamed:@"more.png"] forState:UIControlStateNormal];
//                        [imgBtn addTarget:self action:@selector(showImagesource) forControlEvents:UIControlEventTouchUpInside];
                    }else{//从本地目录加载图片
                        imagePath = [[LocalDirectory imageFileDirectory] stringByAppendingPathComponent:imageName];
                        [imgBtn setBackgroundImage:[UIImage imageWithContentsOfFile:imagePath] forState:UIControlStateNormal];
                        [imgBtn addTarget:self action:@selector(showImage:) forControlEvents:UIControlEventTouchUpInside];
                    }
                    imgBtn.tag = i;//将imgageArray下标赋给tag
                    if (imageArray.count > 1) {
                        //每行4个，到第四个图片
                        if ((i+1)%4 == 0 && (i+1) < imageArray.count) {
                            imgBtnX = 20;
                            imgBtnY = imgBtnY+imgBtnHeight+5;
                        }else{
                            imgBtnX = imgBtnX+imgBtnWidth+10;
                        }
                    }
                    [cell addSubview:imgBtn];
                }
                imgBtnY = imgBtnY + imgBtnHeight+10;//cell总高度
            }
            cell.backgroundColor = [UIColor colorWithRed:240.0 green:241.0 blue:242.0 alpha:1.0];
            cell.frame = CGRectMake(0, 0, 320, imgBtnY);
            break;
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self tableView:createWeiboTableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"";
}

//tableview-----------------------------end---------------------------------------------------------
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//取消按钮
-(void)goback{
    [createWeiboReq cancel];
    [self dismissViewControllerAnimated:YES completion:nil];
}

//文字键盘和表情键盘切换
-(void)showPhraseInfo{
    if (faceBoardShow) {//打开文字键盘
        [weiboTextView resignFirstResponder];
        [faceBtn setBackgroundImage:[UIImage imageNamed:@"face"] forState:UIControlStateNormal];
        weiboTextView.inputView = nil;
        weiboTextView.keyboardType = UIKeyboardTypeDefault;
        [weiboTextView becomeFirstResponder];
        faceBoardShow = NO;
    }else{//打开表情键盘
        [faceBtn setBackgroundImage:[UIImage imageNamed:@"text"] forState:UIControlStateNormal];
        [weiboTextView resignFirstResponder];
        weiboTextView.inputView=_faceBoard;
        [weiboTextView becomeFirstResponder];
        faceBoardShow = YES;
    }
}

//文本框回调赋值(文字、表情)
-(void) setParentText:(NSString *)inputText{
    NSMutableString *tempStr = [[NSMutableString alloc]initWithString:weiboTextView.text];
    [tempStr appendString:inputText];
    weiboTextView.text = tempStr;
}

//弹出选项列表选择图片来源
- (void)showImageRes {
    UIActionSheet *chooseImageSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选择",@"相机", nil];
    [chooseImageSheet showInView:self.view];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            //从相册选择
            [self openPhotoLibray];
            break;
        case 1:
            //拍照
            [self openCamera];
            break;
        default:
            break;
    }
}

//打开图片库
-(void)openPhotoLibray{
    UIImagePickerController *mImagePicker=[[UIImagePickerController alloc]init];
    mImagePicker.sourceType=UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    mImagePicker.delegate= self;
    [self presentViewController:mImagePicker animated:YES completion:nil];
}

//拍照
-(void)openCamera{
    //资源类型为照相机
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    //判断是否有相机
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        //资源类型为照相机
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:nil];
        //        [self presentModalViewController:picker animated:YES];
        //        [picker release];
    }else {
        NSLog(@"该设备无摄像头");
    }
}

//获取图库图片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *image= [info objectForKey:UIImagePickerControllerOriginalImage];
    
//    float imageHeight, imageWith;
//    if (image.size.height>image.size.width) {
//        imageHeight = 480.0, imageWith = 320.0;
//    }else{
//        imageWith = 480.0, imageHeight = 320.0;
//    }
    UIImage *bolgImage = [ImageUtil imageWithImageSimple:image scaledToSize:CGSizeMake(image.size.width, image.size.height)];
//    UIImage *bolgImage = [UIImage imageWithData:UIImageJPEGRepresentation(tempImage, 0.5)];
//    NSData *data = UIImageJPEGRepresentation(avatarImage, 0.5);//获取图片数据
    
    //用时间戳作为图片名称,并创建图片
    NSString *imageName = [NSString stringWithFormat:@"%ld.png", (long)[[NSDate date] timeIntervalSince1970]];
    imagePath = [[LocalDirectory imageFileDirectory] stringByAppendingPathComponent:imageName];
    [[NSFileManager defaultManager] createFileAtPath:imagePath contents:UIImageJPEGRepresentation(bolgImage, 0.5) attributes:nil];
    //如果当前图片数量已经为9,删掉最后一个添加图片,将新的图片放入集合
    if (imageArray.count == WEIBO_CREATE_MAX_IMAGE && [[imageArray lastObject] isEqualToString:@"more.png"]) {
        NSLog(@"%@",imageArray);
        [imageArray insertObject:imageName atIndex:(imageArray.count-1)];//在最后位置放入对象
NSLog(@"%@",imageArray);
        [imageArray removeLastObject];//删除最后一个对象(more)
        NSLog(@"%@",imageArray);
        
    }else{
        //[imgDict setValue:[UIImage imageWithContentsOfFile:imagePath] forKey:imageName];
        [imageArray insertObject:imageName atIndex:(imageArray.count-1)];//插入到(imgageArray.count-1)前面一个位置
    }
    [createWeiboTableView reloadData];
    
    [picker dismissViewControllerAnimated:YES completion:nil];

}

//全屏打开图片
-(void) showImage:(id)sender{
    UIButton *btn = (UIButton *)sender;
    NSLog(@"%d",btn.tag);
    //通过放入btn里的集合下标，在imgkeyarray里找出对应image的key值,再通过key值在imgDict里找到image
    NSString *imageName = [imageArray objectAtIndex:btn.tag];
    ImageBrowseViewController *imageBrowseViewController = [[ImageBrowseViewController alloc] initWithImageName:imageName];
	[imageBrowseViewController setDelegate:self];
    [self.navigationController pushViewController:imageBrowseViewController animated:YES];
}
//删除图片
-(void)trashWithImageName:(NSString *)_imageName{
    //如果当前图片数组的最后一个对象不是more
    if (imageArray.count == WEIBO_CREATE_MAX_IMAGE && ![[imageArray lastObject] isEqualToString:@"more.png"]) {//如果图片数==9
        [imageArray removeObject:_imageName];
        [imageArray addObject:@"more.png"];
    
    }else{
        [imageArray removeObject:_imageName];
    }
    [createWeiboTableView reloadData];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)sendWeibo{
    NSLog(@"发微博啦！");
    
    //发布邻居说
    createWeiboReq=[ASIFormDataRequest requestWithURL:[NSURL URLWithString:[RequestLinkUtil getUrlByKey:PUBLIC_BLOG_CREATE]]];

    [createWeiboReq setPostValue:@"0" forKey:@"frf.PublicBlog.msgType"];//0普通消息，20普通活动，30商业活动
    [createWeiboReq setPostValue:@"0" forKey:@"frf.PublicBlog.scope"];//0小区，1全站
    [createWeiboReq setPostValue:@"0" forKey:@"frf.PublicBlog.isStick"];//非置顶
    [createWeiboReq setPostValue:dataCenter.village.uuid forKey:@"frf.Topic.villageId"];//小区id
    [createWeiboReq setPostValue:weiboTextView.text forKey:@"frf.Topic.content"];//内容
    [createWeiboReq setPostValue:dataCenter.userVO.userId forKey:@"uuid"];//用户id
    [createWeiboReq setPostValue:@"0" forKey:@"frf.Topic.status"];//有效
    [createWeiboReq setPostValue:@"" forKey:@"upload_file_persist.currentUuids"];
    
    for (int i=0; i<imageArray.count;i++) {
        NSString *ipath = [[LocalDirectory imageFileDirectory] stringByAppendingPathComponent:[imageArray objectAtIndex:i]];
        NSData *data = UIImageJPEGRepresentation([UIImage imageWithContentsOfFile:ipath], 0.5);
        [createWeiboReq addData:data forKey:[NSString stringWithFormat:@"upload_file_persist.UploadFileInfo[%d].UploadFile",i]];
    }
    createWeiboReq.timeOutSeconds= 30;
    [createWeiboReq setDelegate:self];
    [createWeiboReq setDidFinishSelector:@selector(createBlogSuccess:)];
    [createWeiboReq setDidFailSelector:@selector(requestError:)];
    [createWeiboReq startAsynchronous];
    
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.delegate = self;
    [HUD show:YES];
    

}



- (void) hideKeyboard {
    [weiboTextView resignFirstResponder];
    weiboTextView.inputView = nil;
    weiboTextView.keyboardType = UIKeyboardTypeDefault;
    faceBoardShow = NO;
    [faceBtn setBackgroundImage:[UIImage imageNamed:@"face"] forState:UIControlStateNormal];
}

#pragma mark  -------邻居说列表请求回调----------
-(void)createBlogSuccess:(ASIFormDataRequest*)request{
    NSLog(@"result:%@",request.responseString);
    NSString *respString = request.responseString;
       NSDictionary *reqDict = [[respString JSONValue] objectAtIndex:0];
    if ([@"success" isEqualToString:[reqDict objectForKey:@"resultCode"]]) {
       
    }else{
//        UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"邻居说" message:@"邻居说创建失败" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
//        [av show];
        
    }
    [HUD hide:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark  -------请求错误--------
- (void)requestError:(ASIFormDataRequest*)request{
    [HUD hide:YES];
    UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"梧桐邑" message:@"服务器异常" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
    [av show];
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
