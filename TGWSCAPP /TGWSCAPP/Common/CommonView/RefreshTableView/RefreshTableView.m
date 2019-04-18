//
//  HomeTableView.m
//  DDGAPP
//
//  Created by Cary on 15/3/2.
//  Copyright (c) 2015年 Cary. All rights reserved.
//

#import "RefreshTableView.h"


@interface RefreshTableView ()

@property (nonatomic,strong) UIButton *msgButton;

@end

@implementation RefreshTableView

- (void)dealloc
{
//        [_tableView.mj_header free];
//        _tableView.mj_header = nil;
//    
//    if (_tableView.mj_footer) {
//        [_tableView.mj_footer free];
//    }
}

#pragma mark === initData


#pragma mark === init
- (id)initWithFrame:(CGRect)frame footView:(BOOL)withFooter
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        if (_tableView == nil) {
            _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
            _tableView.delegate = self;
            _tableView.dataSource = self;
            _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            [_tableView setBackgroundColor:UIColorFromRGB(0xf7f7f7)];
            
            [self addHeader]; // 下拉刷新
            
            if (withFooter) {
                [self addFooter]; // 上拉刷新
            }
        }
        if (_dataArray == Nil) {
            _dataArray = [[NSMutableArray alloc] init];
        }
        if (_paramsDic == nil) {
            _paramsDic = [[NSMutableDictionary alloc] init];
        }
        
        self.pageIndex = 1;
        
        [self addSubview:_tableView];
    }
    
    return self;
}

#pragma mark -- 下拉刷新
- (void)addHeader{
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.pullDown = YES;
        self.pageIndex = 1;
        
        self.isLoading = YES;
        
        [self loadData];
    }];
}

#pragma mark -- 上拉刷新
- (void)addFooter{
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.pullDown = NO;
        self.pageIndex ++;
        
        self.isLoading = YES;
        
        [self loadData];
    }];
}

#pragma mark 列表刷新
-(void)reloadData{
    double delayInSeconds = 0.1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self endRefresh];
        [self.tableView.mj_header beginRefreshing];
    });
}


-(void) foceeReload
{
    [_tableView reloadData];
}

/**
 *  子类要重写
 *
 *  @return <#return value description#>
 */
-(NSDictionary *)fetchParams{
    return nil;
}

-(void)loadData{
    if ([ToolsUtlis isNetworkReachable]){
        DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:self.urlString
                                                                                   parameters:[self fetchParams] HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                      success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                          [self handleData:operation];
                                                                                      }
                                                                                      failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                          NSLog(@"error is %@",[error localizedDescription]);
                                                                                          [MBProgressHUD hideAllHUDsForView:self.tableView animated:NO];
                                                                                          [self handleErrorData:operation];
                                                                                      }];
        operation.tag = self.tag;
        [[NSOperationQueue mainQueue] addOperation:operation];
    }else{
        [self performSelector:@selector(endRefresh) withObject:nil afterDelay:0.01];
        [MBProgressHUD showErrorWithStatus:[LanguageManager networkUnreachableTipsString] toView:self];
    }
}

-(void)handleData:(DDGAFHTTPRequestOperation *)operation{
    [self endRefresh];
    self.secondLoading = YES;
    
    if (self.pullDown) {
        [self.dataArray removeAllObjects];
    }
    
    if (operation.jsonResult.rows) {
        [self.dataArray addObjectsFromArray:operation.jsonResult.rows];
    }
    
    [_tableView reloadData];
}

-(void)handleErrorData:(DDGAFHTTPRequestOperation *)operation{
    [self endRefresh];
   
    if (self.pullDown) {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }else if (!self.pullDown){
        self.pageIndex --;
    }
    
    [self showErrorView:[operation.errorDDG localizedDescription]];
}

/*
 *  结束请求
 */
-(void)endRefresh{
    if (self.isLoading) {
        if (_tableView.mj_header) [_tableView.mj_header endRefreshing];
        if (_tableView.mj_footer) [_tableView.mj_footer endRefreshing];
    }
    self.isLoading = NO;
}

#pragma mark ===
/*
 * 错误数据的视图
 **/
-(void)showErrorView:(NSString *)errorMsg{

}

#pragma mark === UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count > 0 ? self.dataArray.count : 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!self.dataArray || self.dataArray.count <= 0)
        return self.tableView.height;
    if (_delegate && [_delegate respondsToSelector:@selector(heightForRowAthIndexPath:IndexPath:FromView:)]) {
        float vRowHeight = [_dataSource heightForRowAthIndexPath:tableView IndexPath:indexPath FromView:self];
        return vRowHeight;
    }
    return self.tableView.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!self.dataArray || self.dataArray.count <= 0)
        return [self noDataCell:tableView];
    
    if (_dataSource && [_dataSource respondsToSelector:@selector(cellForRowInTableView:IndexPath:FromView:)]) {
        UITableViewCell *vCell = [_dataSource cellForRowInTableView:tableView IndexPath:indexPath FromView:self];
        return vCell;
    }else{
        return nil;
    }
}

-(UITableViewCell *)noDataCell:(UITableView *)tableView{
    static NSString * cellID = @"noDataCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.contentView.backgroundColor = [UIColor whiteColor];
    [self noDataViewOnCell:cell.contentView];
    return cell;
}

-(void)noDataViewOnCell:(UIView *)view{
    
    UIImage *image = [UIImage imageNamed:@"interim"];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - image.size.width)/2, 80.0, image.size.width, image.size.height)];
    imageView.image = image;
    [view addSubview:imageView];
    
    if (self.noDataMsg) {
        UILabel * messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(40.0, CGRectGetMaxY(imageView.frame) + 30.0, self.tableView.width - 80.0, 15.0)];
        messageLabel.text = _noDataMsg;
        messageLabel.font = [UIFont systemFontOfSize:13];
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.textColor = [ResourceManager CellSubTitleColor];
        [view addSubview:messageLabel];
    }
    
    if (self.btnMsg) {
        
        CGSize size = [self.btnMsg sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0]}];
        float width = size.width + 60.0, height = 40.0;
        
        if (!_msgButton) {
            _msgButton = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - width)/2, CGRectGetMaxY(imageView.frame) + 65.0, width, height)];
            _msgButton.backgroundColor = [ResourceManager redColor2];
            _msgButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
            [_msgButton setTitle:self.btnMsg forState:UIControlStateNormal];
            _msgButton.layer.cornerRadius = 3.0;
            [_msgButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            [_msgButton addTarget:self action:@selector(noDataButtonClick) forControlEvents:UIControlEventTouchUpInside];
            
            [view addSubview:_msgButton];
        }
    }
}

-(void)setBtnMsg:(NSString *)btnMsg{
    if (_msgButton) {
        CGSize size = [self.btnMsg sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0]}];
        float width = size.width + 60.0, height = 40.0;
        
        CGRect rect = _msgButton.frame;
        _msgButton.frame = CGRectMake((SCREEN_WIDTH - width)/2, rect.origin.y, width, height);
        [_msgButton setTitle:btnMsg forState:UIControlStateNormal];
    }
    
    _btnMsg = btnMsg;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
-(void)noDataButtonClick{
    if (self.delegate != nil){
        if ([self.delegate respondsToSelector:@selector(noDataButtonClick:)]) {
            [self.delegate performSelector:@selector(noDataButtonClick:) withObject:self];
        }
        
    }
}
#pragma clang diagnostic pop

#pragma mark === UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([_delegate respondsToSelector:@selector(didSelectedRowAthIndexPath:IndexPath:FromView:)]) {
        [_delegate didSelectedRowAthIndexPath:tableView IndexPath:indexPath FromView:self];
    }
}



@end
