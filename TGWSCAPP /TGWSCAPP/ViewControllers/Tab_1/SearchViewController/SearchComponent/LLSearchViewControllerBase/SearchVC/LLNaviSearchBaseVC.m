//
//  LLNaviSearchBaseVC.m
//  LLSearchViewController
//
//  Created by 李龙 on 2017/7/15.
//
//

#import "LLNaviSearchBaseVC.h"
#import "LLSearchNaviBarView.h"
#import "LLSearchBar.h"
#import "NBSSearchShopCategoryView.h"
#import "HistoryAndCategorySearchCategoryViewP.h"
#import "NBSSearchShopCategoryViewCellP.h"
#import "NBSSearchShopHistoryView.h"
#import "HistoryAndCategorySearchHistroyViewP.h"
#import "LLSearchVCConst.h"
#import "UIView+LLRect.h"
#import "SearchSubVC.h"


@interface LLNaviSearchBaseVC () <UIScrollViewDelegate>
{
    NSMutableArray  *arrLinkKey;  //  搜索框匹配到的Key
}
@property (nonatomic,strong) LLSearchNaviBarView *searchNaviBarView;
@property (nonatomic,strong) LLSearchBar *searchBar;

@property (nonatomic,strong) NBSSearchShopCategoryView *shopCategoryView;
@property (nonatomic,strong) NBSSearchShopHistoryView *shopHistoryView;

@property (nonatomic,strong) SearchSubVC *searchSubView;  // 搜索子页面


@property (nonatomic,copy) beginSearchBlock beginSearchBlock;
@property (nonatomic,copy) searchBarDidChangeBlock srdidChangeBlock;

@property (nonatomic,copy) LLSearchResultListView *resultListView;

@property (nonatomic,copy) resultListViewCellDidClickBlock myCellDidClickBlock;

@end

@implementation LLNaviSearchBaseVC{
    CGFloat KeyboardHeightWhenShow;
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //[self.searchBar becomeFirstResponder];
    [self.view endEditing:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //导航条
    [self setupSearchNaviBar];
    
    [self getData];
    
    //监听键盘时间
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    
}

- (void)getData
{
    arrLinkKey = [[NSMutableArray alloc] init];
    
    @LLWeakObj(self);
    if (!_isOnlyShowHistoryView) {
        //开始获取数据
        [self.shopCategoryP fetchCategotyTypeData:^(NSError *error, id result) {
            @LLStrongObj(self);
            if(!error)
                [self setupShopCategory];
            else
                [self myBGScrollView];
        }];
    }
    
    
    //开始获取数据
    [self.shopHistoryP getSearchCache];
    [self.shopHistoryP fetchAndHaveSearchCache:^(BOOL isHave) {
        @LLStrongObj(self);
        if (isHave)
            [self setupShopHistory];
        else
            [self myBGScrollView];
    }];
}


//创建分类界面
- (void)setupShopCategory
{
    self.shopCategoryView = [NBSSearchShopCategoryView searchShopCategoryViewWithPresenter:self.shopCategoryP WithFrame:(CGRect){0,0,ZYHT_ScreenWidth,0}];
    
    @LLWeakObj(self);
    //分类搜索
    [self.shopCategoryView categoryTagonClick:^(NBSSearchShopCategoryViewCellP *cellP) {
        @LLStrongObj(self);
        [self beignToSearch:NaviBarSearchTypeCategory cellP:cellP tagLabel:nil searchBar:nil];
    }];
    
    
    [self.shopCategoryView setModifyFrameBlock:^(CGRect rect){
        @LLStrongObj(self);
        [self modifyViewFrame];
    }];
    
    //刷新数据
    [self.shopCategoryView reloadData];
    
    [self.myBGScrollView addSubview:self.shopCategoryView];
}


//创建历史搜索栏
- (void)setupShopHistory
{
    
    self.shopHistoryView = [NBSSearchShopHistoryView searchShopCategoryViewWithPresenter:self.shopHistoryP WithFrame:(CGRect){0,self.shopCategoryView.bottom,ZYHT_ScreenWidth,0}];
    
    @LLWeakObj(self);
    //开始搜索历史记录
    [self.shopHistoryView historyTagonClick:^(UILabel *tagLabel) {
        @LLStrongObj(self);
        [self beignToSearch:NaviBarSearchTypeHistory cellP:nil tagLabel:tagLabel searchBar:nil];
        
    }];
    
    //清空搜索历史
    [self.shopHistoryView setClearHistoryBtnOnClick:^{
        @LLStrongObj(self);
        //清空
        [self.shopHistoryP clearSearchHistoryWithResult:nil];
        
        [self.shopHistoryView removeFromSuperview];
    }];
    
    
    //刷新数据
    [self.shopHistoryView reloadData];
    
    [self.myBGScrollView addSubview:self.shopHistoryView];
}


//创建导航条
- (void)setupSearchNaviBar
{
    LLSearchNaviBarView *searchNaviBarView = [LLSearchNaviBarView new];
    searchNaviBarView.searbarPlaceHolder = @"请输入搜索关键词";
    searchNaviBarView.searchNaviBarViewType = searchNaviBarViewWhiteAndGray;
    self.searchBar = searchNaviBarView.naviSearchBar;
    
    @LLWeakObj(self);
    [searchNaviBarView showRightOneBtnWithTitle:@"取消" onClick:^(UIButton *btn) {
        @LLStrongObj(self);
        
        [searchNaviBarView.naviSearchBar resignFirstResponder];
        [self dismissVC];
    }];
    
    
    [searchNaviBarView showbackBtnWith:[UIImage imageNamed:@"return"] onClick:^(UIButton *btn) {
        @LLStrongObj(self);
        
        [searchNaviBarView.naviSearchBar resignFirstResponder];
        //[self dismissViewControllerAnimated:NO completion:nil];
        [self dismissVC];
    }];
    
    //开始搜索导航条输入
    [searchNaviBarView keyBoardSearchBtnOnClick:^(LLSearchBar *searchBar) {
        @LLStrongObj(self);
        //通知外界开始搜索
        [self beignToSearch:NaviBarSearchTypeDefault cellP:nil tagLabel:nil searchBar:searchBar];
        //保存搜索历史记录
        [self.shopHistoryP saveSearchCache:searchBar.text result:nil];
    }];
    
    
    //搜索框即时输入捕捉
    [searchNaviBarView textOfSearchBarDidChangeBlock:^(LLSearchBar *searchBar, NSString *searchText) {
        @LLStrongObj(self);

//        if(searchText &&
//           searchText.length == 0)
//         {
//            self.resultListView.hidden = YES;
//         }
//        else
//         {
//            self.resultListView.hidden = NO;
//         }
        
        self.resultListView.hidden = NO;
        self.searchSubView.view.hidden = YES;
        
        
        //FIXME:这里网络请求数据!!!
        [self loadData:searchBar.text];
        

    }];
    
    
    
    [self.view addSubview:searchNaviBarView];
}


-(void)loadData:(NSString *) strKey
{
   
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"goodsKey"] = strKey;
    
    NSString *strURL = [NSString stringWithFormat:@"%@%@",[PDAPI getBaseUrlString],kURLqueryGoodsKey];
    
    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:strURL
                                                                               parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      //[self handleErrorData:operation];
                                                                                  }];
    [operation start];
}


-(void)handleData:(DDGAFHTTPRequestOperation *)operation{
    
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    
    NSDictionary *dic = operation.jsonResult.attr;
    if (!dic)
     {
        return;
     }
    
    
    NSArray *arrRet = dic[@"goodsList"];
    if (!arrRet )
     {
        self.resultListArray  = nil;
        return;
     }
    
    [arrLinkKey removeAllObjects];
    for (int i = 0 ; i < [arrRet count]; i++)
     {
        NSDictionary *dic = arrRet[i];
        if (dic[@"goodsKey"])
         {
            [arrLinkKey addObject:dic[@"goodsKey"]];
         }
        
     }
    
    if ([arrLinkKey count] > 0)
     {
        self.resultListArray = arrLinkKey;
     }
    else
     {
        self.resultListArray  = nil;
     }

}

#pragma mark ================ 更新界面 Frame ================
-(void)modifyViewFrame
{
    self.shopHistoryView.y = self.shopCategoryView.bottom;
}



#pragma mark ================ UISCrollDelegate ================
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.searchBar resignFirstResponder];
}


//-----------------------------------------------------------------------------------------------------------
#pragma mark ================ 私有方法 ================
//-----------------------------------------------------------------------------------------------------------
- (UIScrollView *)myBGScrollView
{
    if (!_myBGScrollView) {
        _myBGScrollView = ({
            UIScrollView *bgScrollView =  [[UIScrollView alloc] initWithFrame:CGRectMake(0,64, ZYHT_ScreenWidth,ZYHT_ScreenHeight-64)];
            bgScrollView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
            bgScrollView.contentSize = CGSizeMake(ZYHT_ScreenWidth, ZYHT_ScreenHeight-60);
            bgScrollView.showsVerticalScrollIndicator = NO;
            bgScrollView.delegate = self;
            [self.view addSubview:bgScrollView];
            bgScrollView;
        });
    }
    return _myBGScrollView;
}

#pragma mark ---  !!!!!真正的搜索响应函数 ， （下拉列表的搜索，不在此处响应）
- (void)beignToSearch:(NaviBarSearchType)searchType cellP:(NBSSearchShopCategoryViewCellP *)cellP tagLabel:(UILabel *)tagLabel searchBar:(LLSearchBar *)searchBar{
//    if (searchType == NaviBarSearchTypeDefault)
//    {
//        LLBLOCK_EXEC(self.beginSearchBlock,searchType,nil,nil,searchBar);
//    }
//    else if (searchType == NaviBarSearchTypeCategory)
//    {
//        LLBLOCK_EXEC(self.beginSearchBlock,searchType,cellP,nil,searchBar);
//    }
//    else  if (searchType == NaviBarSearchTypeHistory)
//    {
//        LLBLOCK_EXEC(self.beginSearchBlock,searchType,nil,tagLabel,nil);
//    }
    
    //退出
    //[self dismissVC];
    
    if (!_searchSubView)
     {
        SearchSubVC *VC = [[SearchSubVC alloc] init];
        VC.view.frame = CGRectMake(0, ZYHT_StatusBarAndNavigationBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT - ZYHT_StatusBarAndNavigationBarHeight);
        [self.view addSubview:VC.view];
        [self addChildViewController:VC];  // 加了这句，才能让子ViewController响应生命周期函数
        
        _searchSubView = VC;
     }
    
    _resultListView.hidden = YES;
    _searchSubView.view.hidden = NO;
    _searchSubView.strSeacrhKey = @"";
    
    if (searchType == NaviBarSearchTypeDefault)
     {
        //LLBLOCK_EXEC(self.beginSearchBlock,searchType,nil,nil,searchBar);
        _searchSubView.strSeacrhKey = searchBar.text;
     }
    else if (searchType == NaviBarSearchTypeCategory)
     {
        //LLBLOCK_EXEC(self.beginSearchBlock,searchType,cellP,nil,searchBar);
        _searchSubView.strSeacrhKey = cellP.categotyTitle;
     }
    else  if (searchType == NaviBarSearchTypeHistory)
     {
        //LLBLOCK_EXEC(self.beginSearchBlock,searchType,nil,tagLabel,nil);
        _searchSubView.strSeacrhKey = tagLabel.text;
     }
    
    [_searchSubView loadData];
    
    [self.view endEditing:YES];
    
}

- (void)dismissVC{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self dismissViewControllerAnimated:NO completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}


//创建即时匹配页面
- (LLSearchResultListView *)resultListView
{

    
    if (!_resultListView) {
        _resultListView = [[LLSearchResultListView alloc] init];
        
        
#pragma mark  ---   !!!!!真正的搜索响应函数， 下拉列表的点击搜索
        __block  SearchSubVC *_blockSearchSubView = _searchSubView;
         __block  UIView *_blockScrollView = _myBGScrollView;
        //列表被点击
        @LLWeakObj(self);
        [_resultListView  resultListViewDidSelectedIndex:^(UITableView *tableView, NSInteger index) {
            @LLStrongObj(self);
            
            // 存储到历史搜索数据
            [self.shopHistoryP saveSearchCache:self.resultListArray[index] result:nil];

            //LLBLOCK_EXEC(self.myCellDidClickBlock,tableView,index);
            
            //退出搜索控制器
            //[self dismissVC];
 
            
            if (!_blockSearchSubView)
             {
                SearchSubVC *VC = [[SearchSubVC alloc] init];
                VC.view.frame = CGRectMake(0, ZYHT_StatusBarAndNavigationBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT - ZYHT_StatusBarAndNavigationBarHeight);
                [self.view addSubview:VC.view];
                [self addChildViewController:VC];  // 加了这句，才能让子ViewController响应生命周期函数
                
                _blockSearchSubView = VC;
             }
            
            _resultListView.hidden = YES;
            _blockSearchSubView.view.hidden = NO;
            
             _blockSearchSubView.strSeacrhKey = self.resultListArray[index];
            [_blockSearchSubView loadData];
            
             //_blockScrollView.hidden = YES;
            
        }];
        
        
        [self.view addSubview:_resultListView];
    }
    
    if (_searchSubView)
     {
        _searchSubView.view.hidden = YES;
     }
    
    return _resultListView;
}

#pragma mark UIKeyboardWillChangeFrameNotification/当键盘的位置大小发生改变时触发
- (void)keyboardWillChangeFrame:(NSNotification *)note
{
    CGRect rect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    KeyboardHeightWhenShow = rect.size.height;
}

//-----------------------------------------------------------------------------------------------------------
#pragma mark ================ 接口 ================
//-----------------------------------------------------------------------------------------------------------
- (void)beginSearch:(beginSearchBlock)beginSearchBlock {
    _beginSearchBlock = beginSearchBlock;
}

-(void)setSearchBarText:(NSString *)searchBarText{
}

-(void)setResultListArray:(NSArray<NSString *> *)resultListArray
{
    _resultListArray = resultListArray;
    self.resultListView.frame = CGRectMake(0, ZYHT_StatusBarAndNavigationBarHeight, self.view.width, ZYHT_ScreenHeight-KeyboardHeightWhenShow-ZYHT_StatusBarAndNavigationBarHeight);
    self.resultListView.resultArray = resultListArray;
}


- (void)searchbarDidChange:(searchBarDidChangeBlock)didChangeBlock;
{
    _srdidChangeBlock = didChangeBlock;
}


/**
 即时匹配结果列表cell点击事件
 */
- (void)resultListViewDidSelectedIndex:(resultListViewCellDidClickBlock)cellDidClickBlock
{
    _myCellDidClickBlock = cellDidClickBlock;
}


-(void)dealloc
{
    NSLog(@"LLNaviSearchBaseVC 页面销毁");
}

@end
