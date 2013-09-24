//
//  AdvertisementView.m
//  WuTongCity
//
//  Created by alan  on 13-8-18.
//  Copyright (c) 2013年 alan. All rights reserved.
//

#import "AdvertisementView.h"
#import "DataCenter.h"
#import <QuartzCore/QuartzCore.h> 
#import "UIImageView+WebCache.h"
#import "PosterVO.h"

@implementation AdvertisementView

//-(void)

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        posterArray =[[NSMutableArray alloc] init];
//        posterArray = _posterArray;
        
        [self posterLoad];
    }
    return self;
}

// scrollview 委托函数
- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    CGFloat pagewidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pagewidth/([slideImages count]+2))/pagewidth)+1;
    page --;  // 默认从第二页开始
    pageControl.currentPage = page;
}
// scrollview 委托函数
- (void)scrollViewDidEndDecelerating:(UIScrollView *)sc
{
    CGFloat pagewidth = scrollView.frame.size.width;
    int currentPage = floor((scrollView.contentOffset.x - pagewidth/ ([slideImages count]+2)) / pagewidth) + 1;
    if (currentPage==0)
    {
        [scrollView scrollRectToVisible:CGRectMake(320 * [slideImages count],0,320,SCROLLVIEW_HEIGHT) animated:NO]; // 序号0 最后1页
    }
    else if (currentPage==([slideImages count]+1))
    {
        [scrollView scrollRectToVisible:CGRectMake(320,0,320,SCROLLVIEW_HEIGHT) animated:NO]; // 最后+1,循环第1页
    }
}

// pagecontrol 选择器的方法
- (void)turnPage
{
    int page = pageControl.currentPage; // 获取当前的page
    [scrollView scrollRectToVisible:CGRectMake(320*(page+1),0,320,SCROLLVIEW_HEIGHT) animated:NO]; // 触摸pagecontroller那个点点 往后翻一页 +1
}
// 定时器 绑定的方法
- (void)runTimePage
{
    int page = pageControl.currentPage; // 获取当前的page
    page++;
    page = page > slideImages.count-1 ? 0 : page ;
    pageControl.currentPage = page;
    [self turnPage];
}


-(void) updateAvatar{
    NSString *avatarName = [DataCenter sharedInstance].userVO.avatar;
    NSString *avatarString= [[RequestLinkUtil getUrlByKey:DOWNLOAD_FILE] stringByAppendingFormat:@"%@",avatarName];
    NSURL *avatarUrl=[NSURL URLWithString:avatarString];
    UIImageView *tempView = [[UIImageView alloc] initWithFrame:CGRectMake(240,170,70,70)];
    [tempView setImageWithURL:avatarUrl
             placeholderImage:[UIImage imageNamed:@"defAvatar"]
                      success:^(UIImage *image){
                          [self.avatarBtn setBackgroundImage:image forState:UIControlStateNormal];
                          [self.avatarBtn setBackgroundImage:image forState:UIControlStateHighlighted];
                      }
                      failure:^(NSError *error){}];
}




-(void) posterLoad{
    
    [posterArray removeAllObjects];
    //获取广告
    NSString *url = [RequestLinkUtil getUrlByKey:POSTER_LOAD];
    url = [url stringByAppendingFormat:@"?currentVillage=%@", [DataCenter sharedInstance].village.uuid];
    NSURL *theURL = [NSURL URLWithString:url];
    
    ASIFormDataRequest *posterListReq=[ASIFormDataRequest requestWithURL:theURL];
    [posterListReq setTimeOutSeconds:30];
    [posterListReq setDelegate:self];
    [posterListReq setCompletionBlock:^{//成功
        NSString *respString = posterListReq.responseString;
        NSDictionary *posterDict = [respString JSONValue];
        if ([@"success" isEqualToString:[posterDict objectForKey:@"resultCode"]]) {
            NSArray *_posterArray = [posterDict objectForKey:@"result"];
            PosterVO *posterVO;
            NSMutableArray *imageNames = [NSMutableArray array];
            for (NSDictionary *posterDict in _posterArray) {
                posterVO = [[PosterVO alloc] initWithDict:posterDict];
                [posterArray addObject:posterVO];
                [imageNames addObject:posterVO.imageName];
            }
            
            [[NSUserDefaults standardUserDefaults] setObject:imageNames forKey:@"advertisementURL"];
            [self setPosterView];
        }else{
            NSDictionary *eDict = [posterDict objectForKey:@"globalErrors"];
            NSDictionary *errorDict = [[eDict objectForKey:@"globalErrors"] objectAtIndex:0];
            UIAlertView *av1=[[UIAlertView alloc]initWithTitle:@"梧桐邑" message:[errorDict objectForKey:@"errorMsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [av1 show];
        }
        
    }];
    [posterListReq setFailedBlock:^{//失败
        UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"梧桐邑" message:@"服务器异常" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [av show];
    }];
    [posterListReq startAsynchronous];
}


-(void) setPosterView{
    self.backgroundColor = [UIColor whiteColor];
    // 定时器 循环
    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(runTimePage) userInfo:nil repeats:YES];
    // 初始化 scrollview
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, SCROLLVIEW_HEIGHT)];
    scrollView.bounces = YES;
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
    scrollView.userInteractionEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:scrollView];
    
    // 初始化 数组 并添加四张图片
    slideImages = [[NSMutableArray alloc] initWithArray:posterArray];
    
    
    // 初始化 pagecontrol
    pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(120,SCROLLVIEW_HEIGHT-20,100,18)]; // 初始化mypagecontrol
    [pageControl setCurrentPageIndicatorTintColor:[UIColor blackColor]];
    [pageControl setPageIndicatorTintColor:[UIColor grayColor]];
    pageControl.numberOfPages = [slideImages count];
    pageControl.currentPage = 0;
    [pageControl addTarget:self action:@selector(turnPage) forControlEvents:UIControlEventValueChanged]; // 触摸mypagecontrol触发change这个方法事件
    [self addSubview:pageControl];
    
    // 创建四个图片 imageview
    for (int i = 0;i<[slideImages count];i++)
    {
        PosterVO *posterVO = [slideImages objectAtIndex:i];
        NSString *ulrString= [[RequestLinkUtil getUrlByKey:DOWNLOAD_FILE] stringByAppendingFormat:@"%@",posterVO.imageName];
        NSURL *url=[NSURL URLWithString:ulrString];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((320 * i) + 320, 0, 320, SCROLLVIEW_HEIGHT)];
        UIImageView *tempView = [[UIImageView alloc] initWithFrame:CGRectMake((320 * i) + 320, 0, 320, SCROLLVIEW_HEIGHT)];
        [tempView setImageWithURL:url
                 placeholderImage:[UIImage imageNamed:@"defAvatar"]
                          success:^(UIImage *image){
                              [imageView setImage:image];
                          }
                          failure:^(NSError *error){}];
        [scrollView addSubview:imageView]; // 首页是第0页,默认从第1页开始的。所以+320。。。
        
        
        
//        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[slideImages objectAtIndex:i]]];
//        imageView.frame = CGRectMake((320 * i) + 320, 0, 320, SCROLLVIEW_HEIGHT);
//        [scrollView addSubview:imageView]; // 首页是第0页,默认从第1页开始的。所以+320。。。
    }
    // 取数组最后一张图片 放在第0页
    PosterVO *pvo = [slideImages lastObject];
    NSString *ulrString= [[RequestLinkUtil getUrlByKey:DOWNLOAD_FILE] stringByAppendingFormat:@"%@",pvo.imageName];
    NSURL *url=[NSURL URLWithString:ulrString];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((320 * ([slideImages count] + 1)) , 0, 320, SCROLLVIEW_HEIGHT)];
    UIImageView *tempView = [[UIImageView alloc] initWithFrame:CGRectMake((320 * ([slideImages count] + 1)) , 0, 320, SCROLLVIEW_HEIGHT)];
    [tempView setImageWithURL:url
                      success:^(UIImage *image){
                          [imageView setImage:image];
                      }
                      failure:^(NSError *error){}];
    [scrollView addSubview:imageView]; // 首页是第0页,默认从第1页开始的。所以+320。。。
    
    // 取数组第一张图片 放在最后1页
    pvo = [slideImages objectAtIndex:0];
    ulrString= [[RequestLinkUtil getUrlByKey:DOWNLOAD_FILE] stringByAppendingFormat:@"%@",pvo.imageName];
    url=[NSURL URLWithString:ulrString];
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake((320 * ([slideImages count] + 1)) , 0, 320, SCROLLVIEW_HEIGHT)];
    tempView = [[UIImageView alloc] initWithFrame:CGRectMake((320 * ([slideImages count] + 1)) , 0, 320, SCROLLVIEW_HEIGHT)];
    [tempView setImageWithURL:url
                      success:^(UIImage *image){
                          [imageView setImage:image];
                      }
                      failure:^(NSError *error){}];
    [scrollView addSubview:imageView]; // 首页是第0页,默认从第1页开始的。所以+320。。。
    
    
//    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[slideImages objectAtIndex:([slideImages count]-1)]]];
//    imageView.frame = CGRectMake(0, 0, 320, SCROLLVIEW_HEIGHT); // 添加最后1页在首页 循环
//    [scrollView addSubview:imageView];
    // 取数组第一张图片 放在最后1页
//    imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[slideImages objectAtIndex:0]]];
//    imageView.frame = CGRectMake((320 * ([slideImages count] + 1)) , 0, 320, SCROLLVIEW_HEIGHT); // 添加第1页在最后 循环
//    [scrollView addSubview:imageView];
    
    [scrollView setContentSize:CGSizeMake(320 * ([slideImages count] + 2), SCROLLVIEW_HEIGHT)]; //  +上第1页和第4页  原理：4-[1-2-3-4]-1
    [scrollView setContentOffset:CGPointMake(0, 0)];
    [scrollView scrollRectToVisible:CGRectMake(320,0,320,SCROLLVIEW_HEIGHT) animated:NO]; // 默认从序号1位置放第1页 ，序号0位置位置放第4页
    
    //昵称
    self.userNameLab = [[UILabel alloc]initWithFrame:CGRectMake(20, 180, 200, 30)];
    [self.userNameLab setText:[DataCenter sharedInstance].userVO.nickName];
    [self.userNameLab setFont:[UIFont fontWithName:@"TrebuchetMS-Bold" size:18]];
    [self.userNameLab setTextColor:[UIColor whiteColor]];
    [self.userNameLab setBackgroundColor:[UIColor clearColor]];
    self.userNameLab.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.userNameLab];
    
    
    //用户头像
    self.avatarBtn = [[ParamButton alloc]initWithFrame:CGRectMake(240,170,70,70)];
    [self.avatarBtn.layer setMasksToBounds:YES];
    [self.avatarBtn.layer setBorderWidth:2.0]; //边框宽度
    [self.avatarBtn.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    [self.avatarBtn.param setValue:[DataCenter sharedInstance].userVO forKey:@"userVO"];
    [self addSubview:self.avatarBtn];
    
    [self updateAvatar];

}

@end
