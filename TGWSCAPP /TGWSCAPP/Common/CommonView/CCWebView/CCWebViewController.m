//
//  CCWebViewController.m
//  WebViewDemo
//
//  Created by dangxy on 16/9/6.
//  Copyright © 2016年 xproinfo.com. All rights reserved.
//

#define MainColor     UIColorFromRGB(0xfc6923)  //主色

#import <WebKit/WebKit.h>
#import "CCWebViewController.h"

@interface CCWebViewController ()<UIWebViewDelegate>

@property (strong, nonatomic) WebviewProgressLine *progressLine;
@property (strong, nonatomic) UIWebView *webView;

@end

@implementation CCWebViewController

/** 传入控制器、url、标题 */
+ (void)showWithContro:(UIViewController *)contro withUrlStr:(NSString *)urlStr withTitle:(NSString *)title {
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    CCWebViewController *webContro = [CCWebViewController new];
    webContro.homeUrl = [NSURL URLWithString:urlStr];
    webContro.titleStr = title;
    [contro.navigationController pushViewController:webContro animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layoutNaviBarViewWithTitle:self.titleStr];
    [self configUI];
}

- (void)configUI {
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, NavHeight, self.view.frame.size.width, self.view.frame.size.height - NavHeight)];
    _webView.scalesPageToFit = YES;
    _webView.backgroundColor = [UIColor whiteColor];
    _webView.delegate = self;
    [self.view addSubview:_webView];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:_homeUrl];
    [_webView loadRequest:request];
    
    // 进度条
    self.progressLine = [[WebviewProgressLine alloc] initWithFrame:CGRectMake(0, NavHeight, SCREEN_WIDTH, 1)];
    self.progressLine.lineColor = [ResourceManager mainColor];
    [self.view addSubview:self.progressLine];
    
}

#pragma mark - 返回按钮事件
-(void)clickNavButton:(UIButton *)button{
    if (self.isPresent) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else {
        if ([self.webView canGoBack]) {
            [self.webView goBack];
        }else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

#pragma mark - webView代理
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    //判断是否是单击
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        NSURL *url = [request URL];
        if([[UIApplication sharedApplication]canOpenURL:url]) {
           return YES;
        }
        return NO;
    }
    return YES;
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
    [self.progressLine startLoadingAnimation];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [self.progressLine endLoadingAnimation];
    NSString *webTitle = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    if (webTitle.length > 0) {
        [self layoutNaviBarViewWithTitle:webTitle];
    }
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [self.progressLine endLoadingAnimation];
}

@end

