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
        [webView loadHTMLString:@"<p style='text-align:center'>梧桐邑网站注册协议</p> <p>梧桐邑网站的服务和权利：<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;您可以在梧桐邑上与邻居即时聊天，找物业的相关人员，您可以在本网站上浏览编辑或邻居发布的信息等功能。梧桐邑对于基本服务实行免费（除有偿的商业服务）。<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;因网站受到攻击或者技术改版而导致的聊天记录丢失或者用户信息丢失，梧桐邑不承担责任。<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;本网站的第三方板块（物业服务、商业服务）以及有关内容由第三方商家或用户自行发布或更改，梧桐邑网站对其真实性、实际可操作性和合法性概不负责，亦不承担任何法律责任。<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;有义务维护网站的正常秩序，对有损梧桐邑网站及可能为其他会员或第三方带来不利的内容和行为，在不与通知的情况下采取必要行动的权利。<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;保护个人信息：<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1、保护用户个人信息是梧桐邑的一项基本原则，梧桐邑将会采取合理的措施保护用户的个人信息。除法律法规规定的情形外，未经用户许可网站不会向第三方公开、透露用户个人信息。梧桐邑对相关信息采用专业加密存储与传输方式，保障用户个人信息的安全。<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2、未经您的同意，梧桐邑不会向梧桐邑以外的任何公司、组织和个人披露您的个人信息，但法律法规另有规定的除外。<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;3、梧桐邑非常重视对未成年人个人信息的保护。若您是18周岁以下的未成年人，在使用梧桐邑的服务前，应事先取得您家长或法定监护人的书面同意。<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;会员应该遵守哪些：<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;您在梧桐邑上不得发布、传送、传播、储存侵害他人名誉权、肖像权、知识产权、商业秘密等合法权利的内容，及违反国家法律、危害国家安全统一、社会稳定、公序良俗、社会公德以及侮辱、诽谤、淫秽或含有任何性或性暗示的、暴力的内容。您发表的信息不应涉及他人隐私、个人信息或资料。<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;干扰网站正常运营和侵犯其他用户或第三方合法权益内容的信息，您均不能再本网站发表。<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;任何人若以复制、转播梧桐邑网上的相关信息，必须注明出处。<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;您不得发表、传送、传播骚扰、广告信息及垃圾信息（本条的广告信息不函括梧桐邑的合作商家，你若在梧桐邑发布了广告信息将默认为您同意梧桐邑网站的广告协议，详见<梧桐邑广告协议>，梧桐邑将有权向您追缴广告费用。）<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;您有义务，遵守梧桐邑网站的其他声明条款及有关法律法规。<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" baseURL:nil];
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
