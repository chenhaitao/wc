//
//  SettingViewController.m
//  WuTongCity
//
//  Created by alan  on 13-8-11.
//  Copyright (c) 2013年 alan. All rights reserved.
//

#import "UserSettingViewController.h"
#import "UserSettingCell.h"
#import "DataCenter.h"
#import "ImageUtil.h"
#import "LocalDirectory.h"

@interface UserSettingViewController ()

@end

@implementation UserSettingViewController
@synthesize userDict, userSectionArray;

-(id)init{
    if(self = [super init]){
        dataCenter = [DataCenter sharedInstance];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //以下是每次进入页面都必须重新加载的
    userVO = dataCenter.userVO;//全局用户信息
    self.userDict = [userVO getUserDcit];//用户信息集合
    self.userSectionArray = [[NSArray alloc]initWithArray:[[self.userDict allKeys]sortedArrayUsingSelector:@selector(compare:)]];//用户分组key
    
    UserSettingTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStyleGrouped];
    UserSettingTableView.dataSource = self;
    UserSettingTableView.delegate = self;
    UserSettingTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:UserSettingTableView];
    
    //add
    UserVO *user = [DataCenter sharedInstance].userVO;
    self.addressDic = [NSDictionary dictionaryWithObjectsAndKeys:user.building,@"building",user.unit,@"unit",user.room,@"room", nil];
}

- (void)viewDidUnload{
    [super viewDidUnload];
    self.userDict=nil;
    self.userSectionArray=nil;
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //add
    if (self.addressDic) {
        UserVO *user = [DataCenter sharedInstance].userVO;
        user.building = self.addressDic[@"building"];
        user.unit= self.addressDic[@"unit"];
        user.room = self.addressDic[@"room"];
    }
    
    
    //以下是每次进入页面都必须重新加载的
    userVO = dataCenter.userVO;//全局用户信息
    self.userDict = [userVO getUserDcit];//用户信息集合
    self.userSectionArray = [[NSArray alloc]initWithArray:[[self.userDict allKeys]sortedArrayUsingSelector:@selector(compare:)]];//用户分组key
    [UserSettingTableView reloadData];


}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.userSectionArray count];//返回分组数量,即Array的数量
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSString *key=[self.userSectionArray objectAtIndex:section];//返回当前分组对应neighbourDict的key值
    NSArray *sectionArray=[self.userDict objectForKey:key];//根据key，取得Array
    return [sectionArray count]; //返回Array的大小
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *key = [self.userSectionArray objectAtIndex:[indexPath section]];
    NSArray *section = [self.userDict objectForKey:key];
    NSDictionary *dict = [[NSDictionary alloc]initWithDictionary:[section objectAtIndex:[indexPath row]]];
    
    
    static NSString * tableIdentifier=@"UserSettingCell";
    UserSettingCell *cell=[tableView dequeueReusableCellWithIdentifier:tableIdentifier];
    if(cell==nil){
        
        cell=[[UserSettingCell alloc]initWithTitle:[dict objectForKey:@"title"]
                                           content:[dict objectForKey:@"content"]
                                              mark:[dict objectForKey:@"mark"]];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0;
    
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    //    NSString *mysection = [self.settingArray objectAtIndex:section];
    return @"";
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0://从相册选择
            [self LocalPhoto];
            break;
        case 1://拍照
            [self takePhoto];
            break;
        default:
            break;
    }
}
//从相册选择
-(void)LocalPhoto{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    //资源类型为图片库
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    //设置选择后的图片可被编辑
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:nil];
}

//拍照
-(void)takePhoto{
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
    }else {
        NSLog(@"该设备无摄像头");
    }
}

//获取图库图片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
//    UIImage *image= [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    UIImage *avatarImage = [ImageUtil imageWithImageSimple:image scaledToSize:CGSizeMake(image.size.width, image.size.height)];
    
    //上传用户头像
    ASIFormDataRequest *avatarUploadReq=[ASIFormDataRequest requestWithURL:[NSURL URLWithString:[RequestLinkUtil getUrlByKey:AVATAR_UPLOAD]]];
    NSString *stringBoundary = @"0xKhTmLbOuNdArY";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",stringBoundary];
//    UIImage *im = [UIImage imageWithContentsOfFile:imagePath];//通过path图片路径获取图片
    NSData *data = UIImageJPEGRepresentation(avatarImage, 0.5);//获取图片数据
    [avatarUploadReq addData:data withFileName:@"avatar.png" andContentType:contentType forKey:@"upload_file_persist.UploadFileInfo[0].UploadFile"];
    [avatarUploadReq setPostValue:userVO.userPersonalityId forKey:@"entityId"];
    [avatarUploadReq setDelegate:self];
    [avatarUploadReq setDidFinishSelector:@selector(avatarUploadSuccess:)];
    [avatarUploadReq setDidFailSelector:@selector(requestError:)];
    [avatarUploadReq startAsynchronous];
    
    
    pickerController = picker;
    
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UserSettingCell *cell = (UserSettingCell *)[tableView cellForRowAtIndexPath:indexPath];
    [self nextViewByUserAttr:[cell.mark intValue]];
}

//弹出选项列表选择图片来源
- (void)showImagesource {
    UIActionSheet *chooseImageSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选择",@"相机", nil];
    [chooseImageSheet showInView:self.view];
}

-(void)goback{
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void) nextViewByUserAttr:(int)_attr{
    switch (_attr) {
        case 1:
            [self showImagesource];
            break;
        case 2://修改昵称
            self.editNickNameViewController = [[EditNickNameViewController alloc] initWithNickName:dataCenter.userVO.nickName];
            [self.navigationController pushViewController:self.editNickNameViewController animated:YES];
            self.editNickNameViewController.title = @"昵称";
            break;
        case 3://个性签名
            self.editSignatureViewController= [[EditSignatureViewController alloc]initWithSignature:dataCenter.userVO.signature];
            [self.navigationController pushViewController:self.editSignatureViewController animated:YES];
            self.editSignatureViewController.title = @"个性签名";
            break;
        case 4://修改姓名
            self.editRealNameViewController= [[EditRealNameViewController alloc]initWithUserVO:dataCenter.userVO];
            [self.navigationController pushViewController:self.editRealNameViewController animated:YES];
            self.editRealNameViewController.title = @"姓名";
            break;
        case 5://修改电话
            self.editUserTelViewController= [[EditUserTelViewController alloc]initWithUserVO:dataCenter.userVO];
            [self.navigationController pushViewController:self.editUserTelViewController animated:YES];
            self.editUserTelViewController.title = @"电话";
            break;
        case 6://修改地址
            self.editUserAddressViewController= [[EditUserAddressViewController alloc]init];
            [self.navigationController pushViewController:self.editUserAddressViewController animated:YES];
            self.editUserAddressViewController.title = @"地址";
            self.editUserAddressViewController.us = self;
            break;
        case 7://修改性别
            self.editUserSexViewController= [[EditUserSexViewController alloc]initWithUserVO:dataCenter.userVO];
            [self.navigationController pushViewController:self.editUserSexViewController animated:YES];
            self.editUserSexViewController.title = @"性别";
            break;
        case 8://修改职业
            self.editUserJobViewController= [[EditUserJobViewController alloc]initWithUserVO:dataCenter.userVO];
            [self.navigationController pushViewController:self.editUserJobViewController animated:YES];
            self.editUserJobViewController.title = @"职业";
            break;
        case 9://修改生日
            self.editUserBirthdayViewController= [[EditUserBirthdayViewController alloc]initWithUserVO:dataCenter.userVO];
            [self.navigationController pushViewController:self.editUserBirthdayViewController animated:YES];
            self.editUserJobViewController.title = @"生日";
            break;
        default:
            break;
    }
}

//pragma mark  -------修改头像网络请求回调----------
-(void)avatarUploadSuccess:(ASIFormDataRequest*)request{
//    NSLog(@"blog回调结果:%@",request.responseString);
   
    if ([request.responseString JSONValue]) {
        NSDictionary *tempDict = [request.responseString JSONValue];
        NSString *imgId = [tempDict objectForKey:@"imgId"];
        dataCenter.userVO.avatar = imgId;
        
        [[[self.userDict objectForKey:@"1"] objectAtIndex:0] setValue:imgId forKey:@"content"];
        [UserSettingTableView reloadData];
    }else{
        UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"更改头像" message:@"更改头像失败" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
        [av show];
    }
  
    
    [pickerController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark  -------请求错误--------
- (void)weiboRequestError:(ASIFormDataRequest*)request
{
    UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"梧桐邑" message:@"服务器异常" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
    [av show];
}

@end
