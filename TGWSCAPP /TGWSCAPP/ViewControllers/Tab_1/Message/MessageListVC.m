//
//  MessageListVC.m
//  TGWSCAPP
//
//  Created by xxjr02 on 2019/1/14.
//  Copyright © 2019 xxjr03. All rights reserved.
//

#import "MessageListVC.h"
#import "CouponViewController.h"
#import "MyBalanceViewController.h"

const  int  iMessageListCellHeight = 100;
@interface MessageListVC ()

@end

@implementation MessageListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *strTitle = @"通知消息";
    if (2 == _msgType)
     {
        strTitle = @"我的资产";
     }
    [self layoutNaviBarViewWithTitle:strTitle];

    [self layoutUI];
}


#pragma mark  ---  布局UI
-(void) layoutUI
{
    // 设置 tabelView 的位置
    int originY = NavHeight;
    self.tableView.frame =  CGRectMake(0, originY, SCREEN_WIDTH, SCREEN_HEIGHT - originY);
    
    // 隐藏分割线的颜色
    self.tableView.separatorColor = [UIColor clearColor];
}



#pragma mark === UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.dataArray.count == 0) {
        return  1;
    }else{
        return self.dataArray.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataArray.count == 0) {
        return  tableView.frame.size.height - tableView.tableHeaderView.frame.size.height;
    }else{
        NSDictionary *dicValue =  self.dataArray[indexPath.row];
        int iTextHeight =   [self getStrHeight: [NSString stringWithFormat:@"%@", dicValue[@"content"]]];
        return iMessageListCellHeight  + iTextHeight;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataArray.count == 0) {
        return  [self noDataCell:tableView];
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageList_Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MessageList_Cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.backgroundColor = [UIColor clearColor];
    
    [self layoutCell:cell withData:self.dataArray[indexPath.row]];
    
    //cell.dataDicionary = self.dataArray[indexPath.row];
    
    //    cell.employBlock = ^{
    //        [self.navigationController popToRootViewControllerAnimated:NO];
    //        [[NSNotificationCenter defaultCenter] postNotificationName:DDGSwitchTabNotification object:@{@"tab":@"1"}];
    //    };
    
    return cell;
}


-(void) layoutCell:(UIView*) viewCell   withData:(NSDictionary *) dicValue
{
    int iTopY = 10;
    UILabel *labelTime = [[UILabel alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 20)];
    [viewCell addSubview:labelTime];
    labelTime.backgroundColor = [ResourceManager lightGrayColor];
    labelTime.font = [UIFont systemFontOfSize:13];
    labelTime.textColor = [UIColor whiteColor];
    labelTime.text = [NSString stringWithFormat:@"  %@  ", dicValue[@"sendTime"]];
    
    [labelTime sizeToFit];
    labelTime.height = 20;
    labelTime.left = (SCREEN_WIDTH - labelTime.width)/2;
    
    iTopY += labelTime.height+10;
    UIView *viewKuang = [[UIView alloc] initWithFrame:CGRectMake(15, iTopY, SCREEN_WIDTH - 30, 100)];
    [viewCell addSubview:viewKuang];
    viewKuang.backgroundColor = [UIColor whiteColor];
    
    UILabel *labelTitle = [[UILabel alloc]  initWithFrame:CGRectMake(10, 10, viewKuang.width - 20, 20)];
    [viewKuang addSubview:labelTitle];
    labelTitle.font = [UIFont systemFontOfSize:14];
    labelTitle.textColor = [ResourceManager color_1];
    labelTitle.text = [NSString stringWithFormat:@"%@", dicValue[@"subject"]];
    
    iTopY = 10 + labelTime.height + 10;
    UIView *viewFG = [[UIView alloc] initWithFrame:CGRectMake(10, iTopY, viewKuang.width - 20, 1)];
    [viewKuang addSubview:viewFG];
    viewFG.backgroundColor = [ResourceManager color_5];
    
    iTopY += 10;
    UILabel *labelContent = [[UILabel alloc] initWithFrame:CGRectMake(10, iTopY, viewKuang.width-40, 100)];
    [viewKuang addSubview:labelContent];
    labelContent.font = [UIFont systemFontOfSize:14];
    labelContent.textColor = [ResourceManager midGrayColor];
    labelContent.numberOfLines = 0;
    labelContent.text = [NSString stringWithFormat:@"%@", dicValue[@"content"]];
    [labelContent sizeToFit];
    
    iTopY += [self getStrHeight: [NSString stringWithFormat:@"%@", dicValue[@"content"]]] +10;
    viewKuang.height = iTopY;
    
    
    UIImageView *imgRight = [[UIImageView alloc] initWithFrame:CGRectMake(viewKuang.width - 20,  20 +(iTopY - 19*ScaleSize)/2, 11*ScaleSize, 19*ScaleSize)];
    [viewKuang addSubview:imgRight];
    imgRight.image = [UIImage imageNamed:@"arrow_right"];
    
}

-(int ) getStrHeight:(NSString *) strValue
{
    int iHeight = 20;
    iHeight =  [ToolsUtlis getSizeWithString:strValue withFrame:CGRectMake(0, 0, SCREEN_WIDTH - 30 - 20 - 40, 100) withFontSize:14].height;
    
    if (iHeight  <= 20)
     {
        iHeight = 20;
     }
    return  iHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //（这种是没有点击后的阴影效果)
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    NSDictionary *dic = self.dataArray[indexPath.row];
    
    
    
    //  `skipType` smallint(1) DEFAULT '0' COMMENT '跳转类型，0，不跳转，1，到原生界面，2.到指定界面',
    int skipType = [dic[@"skipType"] intValue];
    if (2 == skipType)
     {
        NSString *strUrl = dic[@"appSkipUrl"];
        //NSString *url = [NSString stringWithFormat:@"%@tgwproject/AgreePrivacy",[PDAPI WXSysRouteAPI]];
        [CCWebViewController showWithContro:self withUrlStr:strUrl withTitle:@"消息"];
     }
    if (1 == skipType &&
        _msgType == 1)
     {
        NSString *strURL = dic[@"appSkipUrl"];
        NSData *jsonData = [strURL dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err = nil;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                            options:NSJSONReadingMutableContainers
                                                              error:&err];
        
        if(err) {
            NSLog(@"json解析失败：%@",err);
            //return nil;
        }
        
        if (dic)
         {
            NSString *strIosClassName = dic[@"iosClassName"];
            if (strIosClassName.length > 0) {
                [self PushNextViewControllerWith:strIosClassName];
            }
         }
        
     }
    
    NSString *strSubject = dic[@"subject"];
    if([strSubject containsString:@"余额"] &&
       _msgType == 2)
     {
        //我的余额
        MyBalanceViewController *ctl = [[MyBalanceViewController alloc]init];
        [self.navigationController pushViewController:ctl animated:YES];
     }
    else if ([strSubject containsString:@"优惠券"]&&
             _msgType == 2)
     {
        //优惠券
        CouponViewController *ctl = [[CouponViewController alloc]init];
        [self.navigationController pushViewController:ctl animated:YES];
     }
}


- (void)PushNextViewControllerWith:(NSString *)VCName {
    // 类名
    const char *className = [VCName cStringUsingEncoding:NSASCIIStringEncoding];
    // 从一个字串返回一个类
    Class newClass = objc_getClass(className);
    if (!newClass){
        // 创建一个类
        Class superClass = [NSObject class];
        newClass = objc_allocateClassPair(superClass, className, 0);
        // 注册你创建的这个类
        objc_registerClassPair(newClass);
    }
    // 创建对象
    id instance = [[newClass alloc] init];
    [self.navigationController pushViewController:instance animated:YES];
    
}

#pragma mark  ---  网络请求
-(void)loadData{
    [MBProgressHUD showHUDAddedTo:self.view];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[kPage] = @(self.pageIndex);
    params[kPageSize] = @(10);
    params[@"msgType"] = @(_msgType);
    
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",[PDAPI getBaseUrlString],kURLmsgList];
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:strUrl
                                                                               parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      [self handleErrorData:operation];
                                                                                  }];
    [operation start];
}


-(void)handleData:(DDGAFHTTPRequestOperation *)operation{
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    [_tableView.mj_header endRefreshing];
    [_tableView.mj_footer endRefreshing];
    
    if (operation.jsonResult.rows.count > 0) {
        [self reloadTableViewWithArray:operation.jsonResult.rows];
    }else{
        
        if (self.pageIndex > 1) {
            [MBProgressHUD showErrorWithStatus:@"没有更多数据了" toView:self.view];
        }
        
        self.pageIndex --;
        if (self.pageIndex <= 1)
         {
            [self reloadTableViewWithArray:operation.jsonResult.rows];
         }
    }
    
}

-(void)handleErrorData:(DDGAFHTTPRequestOperation *)operation{
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
    [_tableView.mj_header endRefreshing];
    [_tableView.mj_footer endRefreshing];
}

@end
