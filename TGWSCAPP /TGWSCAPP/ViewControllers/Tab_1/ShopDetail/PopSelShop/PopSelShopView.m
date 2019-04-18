//
//  PopSelShopView.m
//  TGWSCAPP
//
//  Created by xxjr02 on 2018/12/25.
//  Copyright © 2018 xxjr03. All rights reserved.
//

#import "PopSelShopView.h"
#import "OrderDetialVC.h"


#define   ShopRedColor     UIColorFromRGB(0x9f1421)

@interface PopSelShopView ()
{
    UIScrollView  *scView;
    UILabel *labelCurSel;
    UILabel *labelCurPrice;
    
    UIView *viewSelCount;  //选择数量View
    UILabel *labelCount;
    int iViewSelCountTopY;  // 选择数量View的顶点坐标
    int iSelCount;  // 数量的计数器
    
    
    UIView *viewNormal;  // 可销售的的view
    UIView *viewSellOut; // 售罄的view
    
    // 最多展示10组规格属性
    NSMutableArray  *arrSepcBtn[10];
    NSDictionary  *dicSpecSel[10];   // 每个规格属性的选择
    NSString  *strSpecTitle[10]; // 每个规格属性的名称
    int iSpecCount;  // 后台返回的，总共有多少规格熟悉
    
    NSString *strSKUCode;  // 当前所选规格的 SKUCode
    int iAbleStock; // 所选规则的库存
    
    
}

@property (nonatomic, weak) UIWindow *keyWindow; ///< 当前窗口
@property (nonatomic, strong) UIView *tailView;  // 底部的弹出View
@property (nonatomic, strong) UIView *shadeView; ///< 遮罩层
@property (nonatomic, weak) UITapGestureRecognizer *tapGesture; ///< 点击背景阴影的手

@property (nonatomic, assign) CGFloat windowWidth; ///< 窗口宽度
@property (nonatomic, assign) CGFloat windowHeight; ///< 窗口高度

@end

@implementation PopSelShopView



#pragma mark - Lift Cycle
- (instancetype)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame])) return nil;
    [self initialize];
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    [self initialize];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self drawUI];
}


#pragma mark - Private
/*! @brief 初始化相关 */
- (void)initialize {
    
    // data init
    for (int i  = 0; i < 10; i++ )
     {
        arrSepcBtn[i] = [[NSMutableArray alloc] init];  // 每个规格的按钮集合
        strSpecTitle[i] = nil; // 每个规格属性的名称
        dicSpecSel[i] = nil;   // 每个规格属性的选择
     }


    // current view
    self.backgroundColor = [UIColor whiteColor];
    // keyWindow
    _keyWindow = [UIApplication sharedApplication].keyWindow;
    _windowWidth = CGRectGetWidth(_keyWindow.bounds);
    _windowHeight = CGRectGetHeight(_keyWindow.bounds);
    // shadeView
    _shadeView = [[UIView alloc] initWithFrame:_keyWindow.bounds];
    //[self setShowShade:NO];
    
    // tailview
    _tailView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _windowWidth, _windowHeight*2/3)];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
    [_shadeView addGestureRecognizer:tapGesture];
    _tapGesture = tapGesture;

    [self addSubview:_tailView];
    
}


-(void) drawUI
{
    UIButton *btnColse = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 40, 0, 30, 30)];
    [_tailView addSubview:btnColse];
    [btnColse setImage:[UIImage imageNamed:@"com_colse"] forState:UIControlStateNormal];
    [btnColse addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    
    
    int iLeftX = 15;
    int iTopY = 20;
    int iIMGWdith = 100;
    int iIMGHeight = 100;
    UIImageView *imgShop = [[UIImageView alloc] initWithFrame:CGRectMake(iLeftX, iTopY, iIMGWdith, iIMGHeight)];
    [_tailView addSubview:imgShop];
    //imgShop.backgroundColor = [UIColor yellowColor];
    [imgShop setImageWithURL:[NSURL URLWithString:_shopModel.strGoodsImgUrl]];
    
    iLeftX += imgShop.width + 10;
    UILabel *labelName = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH - iLeftX - 10, 50)];
    [_tailView addSubview:labelName];
    labelName.font = [UIFont systemFontOfSize:15];
    labelName.textColor = [ResourceManager color_1];
    labelName.numberOfLines = 0;
    labelName.text =  self.shopModel.strGoodsSubName;
    
    iTopY += 50;
    labelCurPrice = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH - iLeftX - 10, 20)];
    [_tailView addSubview:labelCurPrice];
    labelCurPrice.font = [UIFont systemFontOfSize:16];
    labelCurPrice.textColor = ShopRedColor;
    if ([self.shopModel.strMinPrice isEqualToString:self.shopModel.strMaxPrice])
     {
        labelCurPrice.text = [NSString stringWithFormat:@"¥%@",self.shopModel.strMaxPrice];
     }
    else
     {
        labelCurPrice.text = [NSString stringWithFormat:@"¥%@-%@",self.shopModel.strMinPrice,self.shopModel.strMaxPrice];
     }
    
    
    
    iTopY += labelCurPrice.height + 10;
    labelCurSel = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH - iLeftX - 10, 20)];
    [_tailView addSubview:labelCurSel];
    labelCurSel.font = [UIFont systemFontOfSize:13];
    labelCurSel.textColor = [ResourceManager midGrayColor];
    labelCurSel.text = @"请选择规格属性";// self.shopModel.strGoodsSubName;
    
    iTopY += labelCurSel.height + 10;
    int iButtonViewHeight = 50;  // 最底部按钮的view的高度
    // 加入滚动view
    scView = [[UIScrollView alloc]initWithFrame:CGRectMake(0.f, iTopY, SCREEN_WIDTH, _tailView.height - iTopY - iButtonViewHeight )];
    [_tailView addSubview:scView];
    scView.contentSize = CGSizeMake(0, 2000);
    scView.pagingEnabled = NO;
    scView.bounces = NO;
    scView.showsVerticalScrollIndicator = FALSE;
    scView.showsHorizontalScrollIndicator = FALSE;
    //scView.backgroundColor = [UIColor yellowColor];
    
    
    [self layoutScrollView];
    
    // 普通销售的view
    int iBtnWidth = (SCREEN_WIDTH - 30)/2;
    int iBtnHegiht = 40;
    viewNormal = [[UIView alloc] initWithFrame:CGRectMake(0, _tailView.height - iButtonViewHeight , SCREEN_WIDTH, iButtonViewHeight)];
    [_tailView addSubview:viewNormal];
    //viewNormal.backgroundColor = [UIColor blueColor];
    
    UIButton *btnBuy = [[UIButton alloc] initWithFrame:CGRectMake(10, 5, iBtnWidth, iBtnHegiht)];
    [viewNormal addSubview:btnBuy];
    btnBuy.layer.borderColor = [ResourceManager mainColor].CGColor;
    btnBuy.layer.borderWidth = 1;
    btnBuy.cornerRadius = btnBuy.height/2;
    [btnBuy setTitle:@"立即购买" forState:UIControlStateNormal];
    [btnBuy setTitleColor:[ResourceManager mainColor] forState:UIControlStateNormal];
    btnBuy.titleLabel.font = [UIFont systemFontOfSize:15];
    [btnBuy addTarget:self action:@selector(actionBuy) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *btnShopCart = [[UIButton alloc] initWithFrame:CGRectMake(10 + iBtnWidth +10, 5, iBtnWidth, iBtnHegiht)];
    [viewNormal addSubview:btnShopCart];
    btnShopCart.cornerRadius = btnShopCart.height/2;
    btnShopCart.backgroundColor = ShopRedColor;
    [btnShopCart setTitle:@"加入购物车" forState:UIControlStateNormal];
    [btnShopCart setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnShopCart.titleLabel.font = [UIFont systemFontOfSize:15];
    [btnShopCart addTarget:self action:@selector(actionShopCart) forControlEvents:UIControlEventTouchUpInside];
    
    
    // 售罄的view
    viewSellOut = [[UIView alloc] initWithFrame:CGRectMake(0, _tailView.height - iButtonViewHeight, SCREEN_WIDTH, iButtonViewHeight)];
    [_tailView addSubview:viewSellOut];
    viewSellOut.hidden = YES;
    
    
    UIButton *btnSellOut = [[UIButton alloc] initWithFrame:CGRectMake(20, 5, SCREEN_WIDTH - 40, iBtnHegiht)];
    [viewSellOut addSubview:btnSellOut];
    btnSellOut.cornerRadius = btnSellOut.height/2;
    btnSellOut.backgroundColor = [ResourceManager lightGrayColor];
    [btnSellOut setTitle:@"已经售罄" forState:UIControlStateNormal];
    [btnSellOut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnSellOut.titleLabel.font = [UIFont systemFontOfSize:15];

    
    int iIsSellOut = _shopModel.iIsSellOut; //  "isSellOut": 0 代表售罄 1代表尚有库存
    if (0 ==  iIsSellOut)
     {
        viewSellOut.hidden = NO;
        viewNormal.hidden = YES;
     }
    else
     {
        viewSellOut.hidden = YES;
        viewNormal.hidden = NO;
     }
    
    
    int iSaleStatus = _shopModel.iSaleStatus; // // 0 saleStatus  已下架 1 出售中
    if (iSaleStatus == 0)
     {
        viewSellOut.hidden = NO;
        viewNormal.hidden = YES;
        [btnSellOut setTitle:@"已经下架" forState:UIControlStateNormal];
     }
    
    
}

-(void) layoutScrollView
{
    int iTopY = 0;
    
    for (int i = 0; i < [_arrSkuShow count]; i++)
     {
        NSDictionary *dicOptions = _arrSkuShow[i];
        if (!dicOptions ||
            [dicOptions count] <=0)
         {
            continue;
         }
        
        iTopY = [self layoutBtnView:scView fromDicData:dicOptions atCurY:iTopY  atNO:i];
        
     }
    
    iViewSelCountTopY = iTopY ;
    
    scView.contentSize =  CGSizeMake(0, iViewSelCountTopY);
    
    // 显示选择数量 的view
    [self layoutViewSelCount:0];
    
}

// 布局属性按钮view
-(int) layoutBtnView:(UIView*)parentView  fromDicData:(NSDictionary*) dicData  atCurY:(int) iCurY  atNO:(int) iNO;
{
    int iTopY = iCurY;
    int iLeftX = 15;
    UIView *viewTemp = parentView;
    // 设置属性的 标题名
    UILabel *labelName = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH - 2*iLeftX, 20)];
    [viewTemp addSubview:labelName];
    labelName.textColor = [ResourceManager color_1];
    labelName.font = [UIFont systemFontOfSize:12];
    
    NSString *strName = dicData[@"propName"];
    labelName.text = strName;
    strSpecTitle[iNO] = strName;  // 标题数组 没弄好
    iTopY += labelName.height +5;
    
    // 设置属性按钮
    NSArray *options = dicData[@"options"];
    if (!options ||
        [options count] == 0)
     {
        return iTopY;
     }
    
    
    int iBtnLeftX = iLeftX;
    int iBtnWidth = 200;
    int iBtnHeight = 30;
    int iBtnBettwen = 10;
    for (int i = 0; i < [options count]; i++)
     {
        NSDictionary *obj = options[i];
        
        NSString *btnTitle = obj[@"optionName"];
        iBtnWidth  = [ToolsUtlis getSizeWithString:btnTitle withFrame:CGRectMake(0, 0, 200, iBtnHeight) withFontSize:14].width + 30;
        if ( (iBtnLeftX + iBtnWidth  + iLeftX) >  SCREEN_WIDTH)
         {
            iBtnLeftX = iLeftX;
            iTopY += iBtnHeight + iBtnBettwen;
         }
        
        
        UIButton *btnTemp = [[UIButton alloc] initWithFrame:CGRectMake(iBtnLeftX, iTopY, iBtnWidth, iBtnHeight)];
        [parentView addSubview:btnTemp];
        [btnTemp setTitle:btnTitle forState:UIControlStateNormal];
        [btnTemp setTitleColor:[ResourceManager color_1] forState:UIControlStateNormal];
        btnTemp.titleLabel.font = [UIFont systemFontOfSize:14];
        btnTemp.layer.borderWidth = 1;
        btnTemp.layer.borderColor = [ResourceManager lightGrayColor].CGColor;
        btnTemp.cornerRadius = 5;
        
        
        btnTemp.tag = iNO*100 + i;  // 100个按钮为 一组规格属性
        [arrSepcBtn[iNO] addObject:btnTemp];
        [btnTemp addTarget:self action:@selector(actionSpecBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        // 设置按钮 obj
        objc_setAssociatedObject(btnTemp, "withObject", obj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

        
        iBtnLeftX += iBtnWidth + iBtnBettwen;
    
     }
    
    iTopY += iBtnHeight + 10;
    
    return  iTopY;
    
}

// 布局 数量View
-(void) layoutViewSelCount:(int) iKCCount
{
    if (viewSelCount)
     {
        [viewSelCount removeAllSubviews];
     }
    else
     {
        viewSelCount = [[UIView alloc] initWithFrame:CGRectMake(0, iViewSelCountTopY, SCREEN_WIDTH, 100)];  //选择数量View
        [scView addSubview:viewSelCount];
        
        int iScViewScorrlHeight = iViewSelCountTopY + viewSelCount.height;
        scView.contentSize =  CGSizeMake(0, iScViewScorrlHeight);
     }
    
    iSelCount = 1;
    int iTopY = 0;
    int iLeftX = 15;
    // 设置属性的 标题名
    UILabel *labelName = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH - 2*iLeftX, 20)];
    [viewSelCount addSubview:labelName];
    labelName.textColor = [ResourceManager color_1];
    labelName.font = [UIFont systemFontOfSize:12];
    labelName.text = @"数量";
    
    iTopY += labelName.height + 5;
    UIButton  *btnSub = [[UIButton alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 35, 30)];
    [viewSelCount addSubview:btnSub];
    [btnSub addTarget:self action:@selector(actionSub) forControlEvents:UIControlEventTouchUpInside];
    [btnSub setTitleColor:[ResourceManager color_1] forState:UIControlStateNormal];
    [btnSub setTitle:@"—" forState:UIControlStateNormal];
    btnSub.titleLabel.font = [UIFont systemFontOfSize:10];
    btnSub.borderColor = [ResourceManager lightGrayColor];
    btnSub.borderWidth = 1;
    
    iLeftX += btnSub.width -1;
    labelCount = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 60, 30)];
    [viewSelCount addSubview:labelCount];
    labelCount.borderColor = [ResourceManager lightGrayColor];
    labelCount.borderWidth = 1;
    labelCount.text = [NSString stringWithFormat:@"%d",iSelCount];
    labelCount.textColor = [ResourceManager color_1];
    labelCount.font = [UIFont systemFontOfSize:16];
    labelCount.textAlignment = NSTextAlignmentCenter;
    
    
    iLeftX += labelCount.width -1;
    UIButton  *btnAdd = [[UIButton alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 35, 30)];
    [viewSelCount addSubview:btnAdd];
    [btnAdd addTarget:self action:@selector(actionAdd) forControlEvents:UIControlEventTouchUpInside];
    [btnAdd setTitle:@"+" forState:UIControlStateNormal];
    [btnAdd setTitleColor:[ResourceManager color_1] forState:UIControlStateNormal];
    btnAdd.titleLabel.font = [UIFont systemFontOfSize:18];
    btnAdd.borderColor = [ResourceManager lightGrayColor];
    btnAdd.borderWidth = 1;
    
    iLeftX += btnAdd.width + 5;
    UILabel *labelKC = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY+15, SCREEN_WIDTH - iLeftX - 15, 15)];
    [viewSelCount addSubview:labelKC];
    labelKC.textColor = [ResourceManager lightGrayColor];
    labelKC.font = [UIFont systemFontOfSize:11];
    labelKC.text = [NSString stringWithFormat:@"(剩余%d件)",iKCCount];
    if (iKCCount <= 0)
     {
        viewSelCount.hidden = YES;
        iSelCount = -1;
     }
    else
     {
        viewSelCount.hidden = NO;
     }
    
    
}

#pragma mark - Public

/*! @brief 指向指定的View来显示弹窗 */
- (void)show {

    // 遮罩层
    _shadeView.backgroundColor = [UIColor blackColor];
    _shadeView.alpha = 0.4f;
    [_keyWindow addSubview:_shadeView];

    CGFloat currentH = _tailView.height;
    self.frame = CGRectMake(0, _windowHeight, _windowWidth, currentH);
    [_keyWindow addSubview:self];
    
    //弹出动画
    [UIView animateWithDuration:0.25f delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        // 从底部弹出
        self.frame = CGRectMake(0, self.windowHeight - currentH, self.windowWidth, currentH);
        
        // 从顶部弹出
        //self.frame = CGRectMake(0, 0, self.windowWidth, currentH);
    } completion:^(BOOL finished) {
        
    }];
}


-(void) hide {
    [UIView animateWithDuration:0.25f delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{

        // 从底部消失
        self.frame = CGRectMake(0, self.windowHeight, self.windowWidth, self.tailView.height);
        
        // 从顶部消失
        //self.frame = CGRectMake(0, -self.windowHeight, self.windowWidth, self.tailView.height);
        
    } completion:^(BOOL finished) {
        [self.shadeView removeFromSuperview];
        [self removeFromSuperview];
    }];
}


#pragma mark ---  action
-(void) actionBuy
{
    if (strSKUCode.length <= 0)
     {
        [MBProgressHUD showErrorWithStatus:@"请选择正确的规格参数" toView:_keyWindow];
        return;
     }
    
    if (iSelCount < 1)
     {
        [MBProgressHUD showErrorWithStatus:@"请选择购物数量" toView:_keyWindow];
        return;
     }
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"goodsCode"] = _shopModel.strGoodsCode;
    params[@"num"] = @(iSelCount);
    params[@"skuCode"] = strSKUCode;
    
    OrderDetialVC  *VC = [[OrderDetialVC alloc] init];
    VC.dicToWeb = params;
    VC.iType = 1;
    [self.parentVC.navigationController pushViewController:VC animated:YES];
    [self hide];
}

-(void) actionShopCart
{
    
    if (![CommonInfo isLoggedIn])
     {
        [self hide];
     }

    if (strSKUCode.length <= 0)
     {
        [MBProgressHUD showErrorWithStatus:@"请选择正确的规格参数" toView:_keyWindow];
        return;
     }
    
    if (iSelCount < 1)
     {
        [MBProgressHUD showErrorWithStatus:@"请选择购物数量" toView:_keyWindow];
        return;
     }
    
    [self addOrderInfo];
}

-(void) actionSub
{
    if ( iSelCount >1)
     {
        iSelCount--;
        labelCount.text = [NSString stringWithFormat:@"%d",iSelCount];
     }
}

-(void) actionAdd
{
    if (iSelCount< iAbleStock)
     {
        iSelCount++;
        labelCount.text = [NSString stringWithFormat:@"%d",iSelCount];
     }
    else
     {
        [MBProgressHUD showErrorWithStatus:@"库存不足" toView:_keyWindow];
     }
}

-(void) actionSpecBtn:(UIButton*) sender
{
    int iTag = (int)sender.tag;
    int iLayerNO = iTag /100 ;  // 第几层的属性选择
    
    
    
    NSArray *arrBtn = arrSepcBtn[iLayerNO];
    for (int i = 0; i < [arrBtn count]; i++)
     {
        UIButton *btnTemp  = arrBtn[i];
        [btnTemp setTitleColor:[ResourceManager color_1] forState:UIControlStateNormal];
        btnTemp.layer.borderWidth = 1;
        btnTemp.layer.borderColor = [ResourceManager lightGrayColor].CGColor;
     }

    sender.layer.borderColor = [ResourceManager mainColor].CGColor;
    [sender setTitleColor:[ResourceManager mainColor] forState:UIControlStateNormal];
    
    // 获取按钮的 obj
    NSDictionary *objBtn = objc_getAssociatedObject(sender, "withObject");
    NSLog(@"objBtn:%@", objBtn);
    
    dicSpecSel[iLayerNO] = objBtn;
    
    [self getSelSpecToUI];
    
}

// 根据所选的规格按钮， 做出UI改变
-(void) getSelSpecToUI
{
    strSKUCode = @"";
    iAbleStock = -1; // 所选规则的库存
    
    NSString *strSelText  = @"";
    NSString *strSelCode = @"";
    for (int i = 0; i < 10; i++)
     {
        NSDictionary *dicTemp = dicSpecSel[i];
        if (dicTemp)
         {
            NSString *strOptName = dicTemp[@"optionName"];
            NSString *strOptCode = dicTemp[@"optionCode"];
            
            strSelText = [strSelText stringByAppendingFormat:@"%@,", strOptName];
            strSelCode = [strSelCode stringByAppendingFormat:@"%@,", strOptCode];
         }
     }
    
    if (strSelText.length > 0)
     {
        strSelText = [strSelText substringWithRange:NSMakeRange(0, [strSelText length] - 1)];
     }
    labelCurSel.text = [NSString stringWithFormat:@"已选：%@", strSelText];
    
    
    if (strSelCode.length > 0)
     {
        strSelCode = [strSelCode substringWithRange:NSMakeRange(0, [strSelCode length] - 1)];
     }
    // 通过匹配OptionCodes， 获得 strSKUCode
    for (int i = 0; i < [_arrSku count]; i++)
     {
        NSDictionary *objSku = _arrSku[i];
        NSString *strSkuOptionCodes = objSku[@"skuOptionCodes"];
        // 如果选择的 OptionCodes 相等
        if ([strSkuOptionCodes isEqualToString:strSelCode])
         {
            strSKUCode = objSku[@"skuCode"];
            iAbleStock = [objSku[@"ableStock"] intValue];
            
            labelCurPrice.text = [NSString stringWithFormat:@"¥%@", [ToolsUtlis getnumber:objSku[@"price"]]];
            
            [self layoutViewSelCount:iAbleStock];
         }
     }
    
    if (strSKUCode.length > 0)
     {
        NSLog(@"strSKUCode:%@", strSKUCode);
        
        if (iAbleStock <= 0)
         {
            viewSellOut.hidden = NO;
            viewNormal.hidden = YES;
         }
        else
         {
            viewSellOut.hidden = YES;
            viewNormal.hidden = NO;
         }
     }
 
}

#pragma mark --- 网络通讯
// 添加到购物车
-(void) addOrderInfo
{
    [MBProgressHUD showHUDAddedTo:_keyWindow];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"goodsCode"] = _shopModel.strGoodsCode;
    params[@"num"] = @(iSelCount);
    params[@"skuCode"] = strSKUCode;
    

    NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBusiUrlString],kURLorderCartAdd];
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:strUrl
                                                                               parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      [self handleData:operation];
                                                                                  }failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      [self handleErrorData:operation];
                                                                                  }];

    operation.tag = 1000;

    [operation start];
}

-(void)handleData:(DDGAFHTTPRequestOperation *)operation
{
    [MBProgressHUD hideHUDForView:_keyWindow animated:YES];

    if (operation.tag == 1000)
    {
       // 需要刷新购物车下标
       [[NSNotificationCenter defaultCenter] postNotificationName:DDGCartNeedCountNotification object:nil];
       
       [MBProgressHUD showSuccessWithStatus:@"加入购物车成功" toView:_keyWindow];
       
       [self hide];
    }
}


-(void)handleErrorData:(DDGAFHTTPRequestOperation *)operation{
    [MBProgressHUD hideHUDForView:_keyWindow animated:NO];
    [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:_keyWindow];
    
}

@end
