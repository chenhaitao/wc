//
//  AboutWTYViewController.m
//  WuTongCity
//
//  Created by alan  on 13-9-2.
//  Copyright (c) 2013年 alan. All rights reserved.
//

#import "AboutWTYViewController.h"

@interface AboutWTYViewController ()

@end

@implementation AboutWTYViewController

- (id)init{
    self = [super init];
    if (self) {
        UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-44)];
        [webView loadHTMLString:@"<p>sdfsdfsdf</p><p>sdfsdfsdf</p><p>sdfsdfsdf</p><br><li>asdfasdfasdfadfasdf" baseURL:nil];
        [self.view addSubview:webView];
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
