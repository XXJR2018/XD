//
//  OrderDetialVC.m
//  TGWSCAPP
//
//  Created by xxjr02 on 2019/1/3.
//  Copyright © 2019 xxjr03. All rights reserved.
//

#import "OrderDetialVC.h"
#import "AddressViewController.h"
#import "SelCouponVC.h"
#import "SelPayVC.h"
#import "PayResultVC.h"
#import "PhoneCheckViewController.h"
#import "paymentPWViewController.h"
#import "InvoiceInfoVC.h"

#define        AddrViewHeight        70
#define        BottomViewHeight      50

@interface OrderDetialVC ()<UITextFieldDelegate>
{
    UIScrollView  *scView;
    
    UIView *viewBottom;   // 底部view
    UIView *viewNoAddr;
    UIView *viewHaveAddr;
    UIView *viewList;   // 商品列表view
    UIView *viewTail;   // 底部详情view
    UIView *viewOtherMoney;   // 余额
    UILabel *labelYuEDK;      // 余额抵扣
    
    UILabel *labelAddrPhone;
    UILabel *labelAddrName;
    UILabel *labelAddr;
    
    UILabel *lableYHJ;       // 优惠券
    UITextField  *textMJLY;  // 买家留言
    UILabel *labelJF;       // 积分label
    
    UIButton *btnBalance;  // 余额抵扣按钮
    UILabel  *labelDZFP;   // 电子发票label
    UILabel  *lableDZQType;  // 电子发票的类型
    UIButton *btnDZFP;      // 电子发票的按钮
    
    NSDictionary *dicOfUI;
    NSArray *arrOfUI;
    BOOL isCheckXY;  // 协议勾选标记位
    BOOL isCheckDZFP;  // 电子发票勾选标记位
    
    NSString *promocardId; // 优惠券类型ID
    float promocardValue;  // 优惠券的面值
    float goodsTotalAmt;   // 商品的总价值
    float postage;         // 运费
    BOOL  isEmployee;      // 是否有余额
    float usableAmount;   // 余额的值
    float fYEDK;          // 余额抵扣的值
    int  iISYuEPay;       // 是否余额支付
    NSString *tradePassword;    // 余额交易密码
    NSString  *addrId;           // 收货地址ID
    
    NSDictionary *dicLastAddrInfo;  // 上一次的地址信息
    
    int   invoiceFlag;    //是否开发票标志(0-否 1-是)
    NSString   *invoiceId;    //发票ID


}

@property (nonatomic,assign) BOOL  isNotLoadData;     // 不需要加载数据
@property (nonatomic, strong) NSString *custPromocardId;  // 优惠券的唯一ID

@end

@implementation OrderDetialVC

#pragma mark ---  lifecycle
-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"订单详情页面"];
    
    if (!_isNotLoadData)
     {
        [self getUIDataFromWeb];
     }
    _isNotLoadData = NO;

}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"订单详情页面"];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    // 首页切换到别的页面的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getPayPassWord:) name:DDGPayPassWordNotification object:nil];
    
    addrId = @"";
    tradePassword = @"";
    iISYuEPay = 0;
    fYEDK = 0.0;
    
    [self initData];
    
    [self layoutNaviBarViewWithTitle:@"确认订单"];
    
    [self getUIDataFromWeb];
}

-(void) initData
{
    dicOfUI = nil;
    arrOfUI = nil;
    promocardValue = 0;
    goodsTotalAmt = 0;
    usableAmount = 0;
    promocardId = @"";
    _custPromocardId = @"";
    isEmployee = NO;
    
    isCheckXY = YES;
    
    invoiceFlag = 0;    //是否开发票标志(0-否 1-是)
    invoiceId = @"";    //发票ID
}

#pragma mark --- 布局UI
-(void) layoutUI:(NSDictionary*) dicValue  andArr:(NSArray*)arrValue
{
    // 布局底部按钮
    [self layoutBottomView];
    
    scView = [[UIScrollView alloc]initWithFrame:CGRectMake(0.f, NavHeight, SCREEN_WIDTH, SCREEN_HEIGHT-NavHeight - BottomViewHeight)];
    [self.view addSubview:scView];
    scView.contentSize = CGSizeMake(0, 1000);
    scView.pagingEnabled = NO;
    scView.bounces = NO;
    scView.showsVerticalScrollIndicator = FALSE;
    scView.showsHorizontalScrollIndicator = FALSE;
    scView.backgroundColor = [ResourceManager viewBackgroundColor];
    
    int iTopY = 0;
    int iLeftX = 0;
    
    UIImageView *imgCiaoTiao = [[UIImageView alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH, 3)];
    [scView addSubview:imgCiaoTiao];
    imgCiaoTiao.image = [UIImage imageNamed:@"od_caitiao"];
    
    iTopY += imgCiaoTiao.height;
    //  布局无地址view
    [self layoutNoAddrAtLeftX:iLeftX AtTopY:iTopY];
    
    // 布局有地址view
    [self layoutHaveAddrAtLeftX:iLeftX AtTopY:iTopY  AddrDic:dicOfUI];
    
    int iHasAddr = [dicOfUI[@"hasAddr"] intValue];
    if (0 == iHasAddr)
     {
        viewNoAddr.hidden = NO;
        viewHaveAddr.hidden = YES;
     }
    else
     {
        viewNoAddr.hidden = YES;
        viewHaveAddr.hidden = NO;
     }
    
    iTopY += AddrViewHeight + 10;
    // 布局商品列表
    [self layoutShopListAtLeftX:iLeftX AtTopY:iTopY AndArr:arrOfUI];
    
    iTopY += viewList.height;
    // 布局底部详情view
    [self layoutTailViewAtLeftX:iLeftX AtTopY:iTopY AndDic:dicOfUI];
    
    
//    // 画虚线
//    UIImageView * lineView1 = [[UIImageView alloc] initWithFrame:CGRectMake(35, 100, SCREEN_WIDTH, 1)];
//    [scView addSubview:lineView1];
//    lineView1.image = [ToolsUtlis imageWithLineWithImageView:lineView1];

    //添加手势点击空白处隐藏键盘
    UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TouchViewKeyBoard)];
    gesture.numberOfTapsRequired  = 1;
    [self.view addGestureRecognizer:gesture];
}


//  布局无地址view
-(void) layoutNoAddrAtLeftX:(int) iLeftValue  AtTopY:(int ) iTopValue
{
    viewNoAddr = [[UIView alloc] initWithFrame:CGRectMake(iLeftValue, iTopValue, SCREEN_WIDTH, AddrViewHeight)];
    [scView addSubview:viewNoAddr];
    viewNoAddr.backgroundColor = [UIColor whiteColor];
    
    UILabel *labelNoAddr = [[UILabel alloc] initWithFrame:CGRectMake(15, viewNoAddr.height/4, SCREEN_WIDTH-30, viewNoAddr.height/2)];
    [viewNoAddr addSubview:labelNoAddr];
    labelNoAddr.textColor = [ResourceManager priceColor];
    labelNoAddr.font = [UIFont systemFontOfSize:15];
    labelNoAddr.text = @"没有地址信息，请点击后添加地址";
    
    UIButton *btnAddr = [[UIButton alloc] initWithFrame:viewNoAddr.bounds];
    [viewNoAddr addSubview:btnAddr];
    [btnAddr addTarget:self action:@selector(actionAddAddress) forControlEvents:UIControlEventTouchUpInside];
    
}

// 布局有地址view
-(void) layoutHaveAddrAtLeftX:(int) iLeftValue  AtTopY:(int ) iTopValue  AddrDic:(NSDictionary*)dicValue
{
    NSDictionary *dicAddrInfo = dicValue[@"addrInfo"];
    if (!dicAddrInfo)
     {
        dicAddrInfo = [[NSDictionary alloc] init];
     }
    
    addrId = [ NSString stringWithFormat:@"%@", dicAddrInfo[@"addrId"]];
    
    viewHaveAddr = [[UIView alloc] initWithFrame:CGRectMake(iLeftValue, iTopValue, SCREEN_WIDTH, AddrViewHeight)];
    [scView addSubview:viewHaveAddr];
    viewHaveAddr.backgroundColor = [UIColor whiteColor];
    
    int iTopY = 10;
    int iLeftX = 15;
    labelAddrName = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 150, 20)];
    [viewHaveAddr addSubview:labelAddrName];
    labelAddrName.textColor = [ResourceManager color_1];
    labelAddrName.font = [UIFont systemFontOfSize:14];
    labelAddrName.text = dicAddrInfo[@"receiveName"];
    
    labelAddrPhone = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 170, iTopY, 130, 20)];
    [viewHaveAddr addSubview:labelAddrPhone];
    labelAddrPhone.textColor = [ResourceManager color_1];
    labelAddrPhone.textAlignment = NSTextAlignmentRight;
    labelAddrPhone.font = [UIFont systemFontOfSize:14];
    labelAddrPhone.text = dicAddrInfo[@"receiveTel"];
    
    iTopY += labelAddrName.height ;
    labelAddr = [[UILabel alloc] initWithFrame:CGRectMake(15, iTopY, SCREEN_WIDTH - 50, 30)];
    [viewHaveAddr addSubview:labelAddr];
    labelAddr.textColor = [ResourceManager color_1];
    labelAddr.font = [UIFont systemFontOfSize:11];
    labelAddr.numberOfLines = 0;
    labelAddr.text = dicAddrInfo[@"fullAddrDesc"];
    
    
    UIImageView *imgRight = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 20, (AddrViewHeight - 19*ScaleSize)/2, 11*ScaleSize, 19*ScaleSize)];
    [viewHaveAddr addSubview:imgRight];
    imgRight.image = [UIImage imageNamed:@"arrow_right"];
    
    UIButton *btnAddr = [[UIButton alloc] initWithFrame:viewHaveAddr.bounds];
    [viewHaveAddr addSubview:btnAddr];
    [btnAddr addTarget:self action:@selector(actionUpdateAddress) forControlEvents:UIControlEventTouchUpInside];
    
}

// 布局商品列表
-(void) layoutShopListAtLeftX:(int) iLeftValue  AtTopY:(int ) iTopValue  AndArr:(NSArray*) arrValue
{
    viewList = [[UIView alloc] initWithFrame:CGRectMake(iLeftValue, iTopValue, SCREEN_WIDTH, 100)];
    [scView addSubview:viewList];
    viewList.backgroundColor = [UIColor whiteColor];
    
    int iShopCount = (int)[arrValue count];
    int iCellHeight = 95;
    int iCellTopY = 0;
    for (int i = 0; i < iShopCount; i++)
     {
        UIView *viewCell = [[UIView alloc] initWithFrame:CGRectMake(0, iCellTopY, SCREEN_WIDTH, iCellHeight)];
        [viewList addSubview:viewCell];
        //viewCell.backgroundColor = [UIColor whiteColor];
        
        NSDictionary *objGood = arrValue[i];
        
        int iTopY = 10;
        int iLeftX = 15;
        UIImageView *imgShop = [[UIImageView alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 75, 75)];
        [viewCell addSubview:imgShop];
        [imgShop setImageWithURL:[NSURL URLWithString:objGood[@"goodsUrl"]]];
        
        iTopY += 5;
        iLeftX += imgShop.width + 10;
        UILabel *labelName = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH - iLeftX - 10, 20)];
        [viewCell addSubview:labelName];
        labelName.textColor = [ResourceManager color_1];
        labelName.font = [UIFont systemFontOfSize:14];
        labelName.text = objGood[@"goodsName"];
        
        
        iTopY += labelName.height + 5;
        UILabel *labelGuige = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH - iLeftX - 10, 20)];
        [viewCell addSubview:labelGuige];
        labelGuige.textColor = [ResourceManager midGrayColor];
        labelGuige.font = [UIFont systemFontOfSize:11];
        labelGuige.text = objGood[@"skuDesc"];
        
        iTopY += labelGuige.height + 5;
        UILabel *labelPrice = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH - iLeftX - 10 - 60, 20)];
        [viewCell addSubview:labelPrice];
        labelPrice.textColor = [ResourceManager priceColor];
        labelPrice.font = [UIFont systemFontOfSize:15];
        labelPrice.text =   [NSString stringWithFormat:@"¥%@",objGood[@"price"]];
        
        
        UILabel *lableNum = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-65, iTopY, 50, 20)];
        [viewCell addSubview:lableNum];
        lableNum.textColor = [ResourceManager midGrayColor];
        lableNum.font = [UIFont systemFontOfSize:15];
        lableNum.textAlignment = NSTextAlignmentRight;
        lableNum.text =   [NSString stringWithFormat:@"×%@",objGood[@"num"]];
        
        UIView *viewFG = [[UIView alloc] initWithFrame:CGRectMake(15, iCellHeight-1, SCREEN_WIDTH - 2*15, 1)];
        [viewCell addSubview:viewFG];
        viewFG.backgroundColor = [ResourceManager color_5];
        
        iCellTopY += iCellHeight;
     }
    
    viewList.height = iCellTopY;
    
}


// 布局底部详情view
-(void) layoutTailViewAtLeftX:(int) iLeftValue  AtTopY:(int ) iTopValue  AndDic:(NSDictionary*) dicValue
{
    viewTail = [[UIView alloc] initWithFrame:CGRectMake(iLeftValue, iTopValue, SCREEN_WIDTH, 100)];
    [scView addSubview:viewTail];
    
    int iTopY = 0;
    int iLeftX = 15;
    int iCellHeight = 50;
    // 买家留言
    UIView *viewMJLY = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, iCellHeight)];
    [viewTail addSubview:viewMJLY];
    viewMJLY.backgroundColor = [UIColor whiteColor];
    
    UILabel *labelMJYY = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 60, iCellHeight)];
    [viewTail addSubview:labelMJYY];
    labelMJYY.font = [UIFont systemFontOfSize:14];
    labelMJYY.textColor = [ResourceManager color_1];
    labelMJYY.text = @"买家留言";
    
    iLeftX += labelMJYY.width+10;
    textMJLY = [[UITextField alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH - iLeftX - 10, iCellHeight)];
    [viewTail addSubview:textMJLY];
    textMJLY.font = [UIFont systemFontOfSize:14];
    textMJLY.textColor = [ResourceManager color_1];
    textMJLY.placeholder = @"需与商家协商并确认，45字以内";
    textMJLY.tag = 1000;
    textMJLY.delegate = self;
    
    // 余额抵扣
    NSDictionary *dicUser =  [CommonInfo userInfo];
    BOOL  isEmployee  = NO;
    int iOtherMoneyHeight = 90;
    if (dicUser)
     {
        isEmployee = [dicUser[@"isEmployee"] boolValue];
        isEmployee = TRUE; // 所有人都展示
        if (isEmployee)
         {
            iTopY += iCellHeight + 10;
            viewOtherMoney = [[UIView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, iOtherMoneyHeight)];
            [viewTail addSubview:viewOtherMoney];
            viewOtherMoney.backgroundColor = [UIColor whiteColor];
            
            UILabel *labelYuE = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, 200, 20)];
            [viewOtherMoney addSubview:labelYuE];
            labelYuE.textColor = [ResourceManager color_1];
            labelYuE.font = [UIFont systemFontOfSize:14];
            labelYuE.text = [NSString stringWithFormat:@"余额 :¥%@", dicUser[@"usableAmount"]]; //@"余额 :¥100";
            
           
            labelYuEDK = [[UILabel alloc] initWithFrame:CGRectMake(15, 20+25, 270, 20)];
            [viewOtherMoney addSubview:labelYuEDK];
            labelYuEDK.textColor = [ResourceManager color_1];
            labelYuEDK.font = [UIFont systemFontOfSize:14];
            fYEDK = 0.00;
            labelYuEDK.text = [NSString stringWithFormat:@"余额抵扣 :¥%.2f",0.00 ];
            
            btnBalance = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-90, 25, 75, 30)];
            [viewOtherMoney addSubview:btnBalance];
            [btnBalance setImage:[UIImage imageNamed:@"pay_ye_colse"] forState:UIControlStateNormal];
            [btnBalance setImage:[UIImage imageNamed:@"pay_ye_open"] forState:UIControlStateSelected];
            btnBalance.selected = NO;
            [btnBalance addTarget:self action:@selector(actionBalance:) forControlEvents:UIControlEventTouchUpInside];
            //actionBalance
            
            UIView *viewOtherFG = [[UIView alloc] initWithFrame:CGRectMake(0, iOtherMoneyHeight-1, SCREEN_WIDTH, 1)];
            [viewOtherMoney addSubview:viewOtherFG];
            viewOtherFG.backgroundColor = [ResourceManager color_5];
            
         }
        
     }
    
    // @"优惠券/优惠码",@"购买所得积分",@"配送方式" 布局
    if (isEmployee)
     {
        iTopY += iOtherMoneyHeight;
     }
    else
     {
        iTopY += iCellHeight + 10;
     }
    NSArray *arrName = @[@"优惠券/购物券",@"购买所得积分",@"配送方式",@"我要开发票"];
    for(int i= 0 ; i <[arrName count]; i++)
     {
        iLeftX = 15;
        UIView *viewCell = [[UIView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, iCellHeight)];
        [viewTail addSubview:viewCell];
        viewCell.backgroundColor = [UIColor whiteColor];
        
        UILabel *labelName = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, 0, 150, iCellHeight)];
        [viewCell addSubview:labelName];
        labelName.font = [UIFont systemFontOfSize:14];
        labelName.textColor = [ResourceManager color_1];
        labelName.text = arrName[i];
        
        
        if (3 == i)
         {
            //  电子发票
            labelName.left = 15 + 20;
            labelDZFP = labelName;
            
            UIButton *btnCheck = [[UIButton alloc] initWithFrame:CGRectMake(iLeftX,17, 15, 15)];
            [viewCell addSubview:btnCheck];
            [btnCheck setBackgroundImage:[UIImage imageNamed:@"com_gou3"] forState:UIControlStateNormal];
            [btnCheck setBackgroundImage:[UIImage imageNamed:@"com_gou4"] forState:UIControlStateSelected];
            btnCheck.selected = NO;
            [btnCheck addTarget:self action:@selector(actionCheckDZFP:) forControlEvents:UIControlEventTouchUpInside];
            
            lableDZQType = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 100, (iCellHeight-20)/2, 80, 20)];
            [viewCell addSubview:lableDZQType];
            lableDZQType.font = [UIFont systemFontOfSize:14];
            lableDZQType.textColor = [ResourceManager midGrayColor];
            lableDZQType.text = @"";
            lableDZQType.textAlignment = NSTextAlignmentRight;
            //lableDZQType.hidden = YES;
            
            
            UIImageView *imgRight = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-20, (iCellHeight - 19*ScaleSize)/2, 11*ScaleSize, 19*ScaleSize)];
            [viewCell addSubview:imgRight];
            imgRight.image = [UIImage imageNamed:@"arrow_right"];
            
            
            btnDZFP = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-150, 0, 150, 50)];
            [viewCell addSubview:btnDZFP];
            [btnDZFP addTarget:self action:@selector(actionDZFP) forControlEvents:UIControlEventTouchUpInside];
            btnDZFP.hidden = YES;
         }
        
        
        if (0 == i)
         {
            //优惠券特殊编码
            lableYHJ = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 100, (iCellHeight-20)/2, 80, 20)];
            [viewCell addSubview:lableYHJ];
            lableYHJ.font = [UIFont systemFontOfSize:14];
            lableYHJ.textColor = [ResourceManager midGrayColor];
            lableYHJ.textAlignment = NSTextAlignmentRight;
            lableYHJ.text = @"暂无可用";
            
            UILabel *lableYHJ2 = [[UILabel alloc] initWithFrame:CGRectMake(110, (iCellHeight-20)/2, 60, 20)];
            [viewCell addSubview:lableYHJ2];
            lableYHJ2.font = [UIFont systemFontOfSize:13];
            lableYHJ2.textColor = [UIColor whiteColor];
            lableYHJ2.text = @"";
            lableYHJ2.textAlignment = NSTextAlignmentCenter;
            lableYHJ2.backgroundColor = [ResourceManager priceColor];
            lableYHJ2.hidden = YES;
            
            
            NSArray *arr = dicOfUI[@"promocardList"];
            if (arr &&
                [arr isKindOfClass:[NSArray class]]&&
                [arr count] >=1)
             {
                lableYHJ2.hidden = NO;
                lableYHJ2.text = [NSString stringWithFormat:@"可选%ld张",[arr count]];
                lableYHJ.text = [NSString stringWithFormat:@"-¥%.2f",promocardValue]; // 优惠券的面值
             }
            
            UIImageView *imgRight = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-20, (iCellHeight - 19*ScaleSize)/2, 11*ScaleSize, 19*ScaleSize)];
            [viewCell addSubview:imgRight];
            imgRight.image = [UIImage imageNamed:@"arrow_right"];
            
            //添加手势, 选择券
            UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actionSelQuan)];
            gesture.numberOfTapsRequired  = 1;
            [viewCell addGestureRecognizer:gesture];
            
         }
        else if(1 == i)
         {
            // 购买所得积分
            labelJF = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 100, (iCellHeight-20)/2, 90, 20)];
            [viewCell addSubview:labelJF];
            labelJF.font = [UIFont systemFontOfSize:14];
            labelJF.textColor = [ResourceManager midGrayColor];
            labelJF.textAlignment = NSTextAlignmentRight;
            float fTotalPrice = goodsTotalAmt - promocardValue - fYEDK;
            labelJF.text = [NSString stringWithFormat:@"%d", (int) (fTotalPrice * [dicOfUI[@"scorePrice"] floatValue])];
         }
        else if (2 == i)
         {
            // 配送方式
            UILabel *labelPSFS = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 100, (iCellHeight-20)/2, 90, 20)];
            [viewCell addSubview:labelPSFS];
            labelPSFS.font = [UIFont systemFontOfSize:14];
            labelPSFS.textColor = [ResourceManager midGrayColor];
            labelPSFS.textAlignment = NSTextAlignmentRight;
            labelPSFS.text = [NSString stringWithFormat:@"%@",dicValue[@"deliveryType"]];
         }
            
        
        if (i < ([arrName count] - 1))
         {
            UIView *viewFG = [[UIView alloc] initWithFrame:CGRectMake(0, iCellHeight-1, SCREEN_WIDTH, 1)];
            [viewCell addSubview:viewFG];
            viewFG.backgroundColor = [ResourceManager color_5];
         }
        
        iTopY += iCellHeight;
     }
    
    
    iTopY += 10;
    arrName = @[@"商品总价",@"运费"];
    for(int i= 0 ; i <[arrName count]; i++)
     {
        iLeftX = 15;
        UIView *viewCell = [[UIView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, iCellHeight)];
        [viewTail addSubview:viewCell];
        viewCell.backgroundColor = [UIColor whiteColor];
        
        UILabel *labelName = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, 0, 150, iCellHeight)];
        [viewCell addSubview:labelName];
        labelName.font = [UIFont systemFontOfSize:14];
        labelName.textColor = [ResourceManager color_1];
        labelName.text = arrName[i];
        
        
        
        if(0 == i)
         {
            // 商品总价
            UILabel *labelSPZJ = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 100, (iCellHeight-20)/2, 90, 20)];
            [viewCell addSubview:labelSPZJ];
            labelSPZJ.font = [UIFont systemFontOfSize:14];
            labelSPZJ.textColor = [ResourceManager priceColor];
            labelSPZJ.textAlignment = NSTextAlignmentRight;
            labelSPZJ.text = [NSString stringWithFormat:@"¥%@",dicValue[@"goodsTotalAmt"]];
         }
        else if (1 == i)
         {
            // 运费
            UILabel *labelYF = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 100, (iCellHeight-20)/2, 90, 20)];
            [viewCell addSubview:labelYF];
            labelYF.font = [UIFont systemFontOfSize:14];
            labelYF.textColor = [ResourceManager priceColor];
            labelYF.textAlignment = NSTextAlignmentRight;
            labelYF.text = [NSString stringWithFormat:@"¥%@",dicValue[@"postage"]];
         }
        
        
        if (i < ([arrName count] - 1))
         {
            UIView *viewFG = [[UIView alloc] initWithFrame:CGRectMake(0, iCellHeight-1, SCREEN_WIDTH, 1)];
            [viewCell addSubview:viewFG];
            viewFG.backgroundColor = [ResourceManager color_5];
         }
        
        iTopY += iCellHeight;
     }
    
    iTopY += 20;
    iLeftX = 15;
    UIButton *btnCheck = [[UIButton alloc] initWithFrame:CGRectMake(iLeftX,iTopY+3, 15, 15)];
    [viewTail addSubview:btnCheck];
    //[btnCheck setImage:[UIImage imageNamed:@"sc_gou1"] forState:UIControlStateNormal];
    //[btnCheck setImage:[UIImage imageNamed:@"sc_gou2"] forState:UIControlStateSelected];
    [btnCheck setBackgroundImage:[UIImage imageNamed:@"com_gou3"] forState:UIControlStateNormal];
    [btnCheck setBackgroundImage:[UIImage imageNamed:@"com_gou4"] forState:UIControlStateSelected];
    btnCheck.selected = YES;
    [btnCheck addTarget:self action:@selector(actionCheck:) forControlEvents:UIControlEventTouchUpInside];
    
    iLeftX += btnCheck.width +10;
    UILabel *labelXY1 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 58, 20)];
    [viewTail addSubview:labelXY1];
    labelXY1.textColor = [ResourceManager midGrayColor];
    labelXY1.font = [UIFont systemFontOfSize:14];
    labelXY1.text = @"我已同意";
    
    iLeftX += labelXY1.width;
    UILabel *labelXY2 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 200, 20)];
    [viewTail addSubview:labelXY2];
    labelXY2.textColor = [ResourceManager color_1];
    labelXY2.font = [UIFont systemFontOfSize:14];
    labelXY2.text = @"《天狗窝商城服务协议》";
    
    
    
    //添加手势点击空白处隐藏键盘
    UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actionXieYi)];
    gesture.numberOfTapsRequired  = 1;
    labelXY2.userInteractionEnabled = YES;
    [labelXY2 addGestureRecognizer:gesture];
    
    
    iTopY += btnCheck.height +20;
    viewTail.height = iTopY;
    
    scView.contentSize = CGSizeMake(0, iTopY + iTopValue);
    
    
    
   
}

// 布局底部按钮view
- (void)layoutBottomView
{
    viewBottom = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - BottomViewHeight, SCREEN_WIDTH, BottomViewHeight)];
    [self.view addSubview:viewBottom];
    viewBottom.backgroundColor = [UIColor whiteColor];
    
    UIView *lineView = [[UIView alloc]init];
    lineView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 1);
    lineView.backgroundColor = [ResourceManager color_5];
    [viewBottom addSubview:lineView];
    
    int iLeftX = 15;
    int iTopY = 10;
    UILabel *lableHJ = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 50, 20)];
    [viewBottom addSubview:lableHJ];
    lableHJ.textColor = [ResourceManager color_1];
    lableHJ.font = [UIFont systemFontOfSize:14];
    lableHJ.text = @"合计:";

    
    iLeftX += lableHJ.width;
    UILabel *lableTotalPrice = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX,iTopY , SCREEN_HEIGHT-iLeftX-120, 20)];
    [viewBottom addSubview: lableTotalPrice];
    lableTotalPrice.textColor = [ResourceManager priceColor];
    lableTotalPrice.font = [UIFont systemFontOfSize:18];
    float fTotalPrice = goodsTotalAmt - promocardValue - fYEDK + postage;
    if (fTotalPrice <= 0.000)
     {
        fTotalPrice = 0.00;
     }
    lableTotalPrice.text = [NSString stringWithFormat:@"¥%.2f", fTotalPrice  ];
    
    int  iJF = goodsTotalAmt - promocardValue;
    if (iJF < 0)
     {
        iJF = 0;
     }
    labelJF.text = [NSString stringWithFormat:@"%d", iJF];

    
    iTopY += lableTotalPrice.height;
    UILabel *lableYHPrice = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX,iTopY , SCREEN_HEIGHT-iLeftX-120, 15)];
    [viewBottom addSubview: lableYHPrice];
    lableYHPrice.textColor = [ResourceManager midGrayColor];
    lableYHPrice.font = [UIFont systemFontOfSize:12];
    lableYHPrice.text = [NSString stringWithFormat:@"已优惠: ¥%.2f", promocardValue];//@"已优惠: ¥50.00";
    
    

    //结算按钮
    UIButton *btnOK = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 120, 0, 120, BottomViewHeight)];
    [viewBottom addSubview:btnOK];
    btnOK.backgroundColor = [ResourceManager priceColor];
    [btnOK setTitle:@"去支付" forState:UIControlStateNormal];
    btnOK.titleLabel.font = [UIFont systemFontOfSize:14];
    [btnOK addTarget:self action:@selector(actionPay) forControlEvents:UIControlEventTouchUpInside];
    

//
//    //合计
//    UILabel *label = [[UILabel alloc]init];
//    label.font = [UIFont systemFontOfSize:15];
//    label.textColor = [ResourceManager priceColor];
//    [backgroundView addSubview:label];
//
//    label.attributedText = [self LZSetString:@"¥0.00"];
//    CGFloat maxWidth = LZSCREEN_WIDTH - selectAll.bounds.size.width - btn.bounds.size.width - 30;
//    //    CGSize size = [label sizeThatFits:CGSizeMake(maxWidth, LZTabBarHeight)];
//    label.frame = CGRectMake(selectAll.bounds.size.width + 20, 0, maxWidth - 10, LZTabBarHeight);
//    self.totlePriceLabel = label;
}



#pragma mark --- 网络请求
-(void) getUIDataFromWeb
{
    [self initData];
    [MBProgressHUD showHUDAddedTo:self.view];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params = _dicToWeb;
    
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBusiUrlString],kURLsingleOrderInfo];
    if (2 == _iType)
     {
        strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBusiUrlString],kURLbatchOrderInfo];
     }
    
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

-(void)commitOrder
{
    
    
    [MBProgressHUD showHUDAddedTo:self.view];
    

    NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBusiUrlString],kURLcommitOrder];

    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params = _dicToWeb;
    params[@"addrId"] = addrId;
    params[@"cartIds"] = _dicToWeb[@"cartIds"];  // 多个的话，用逗号隔开
    params[@"remark"] =  textMJLY.text;
    params[@"clientType"] = @"APP";
    params[@"custPromocardId"] = _custPromocardId;
    params[@"promocardId"] = promocardId;
    params[@"totalOrderAmt"] = [NSString stringWithFormat:@"%.2f", goodsTotalAmt - promocardValue - fYEDK];
    
    params[@"invoiceFlag"] = @(0);
    if(isCheckDZFP)
     {
        if (invoiceId.length <=0)
         {
            [MBProgressHUD showErrorWithStatus:@"请选择发票类型并保存" toView:self.view];
            return;
         }
        
        //invoiceFlag    是否开发票标志(0-否 1-是)
        //invoiceId    发票ID
        params[@"invoiceFlag"] = @(1);
        params[@"invoiceId"] = invoiceId;
     }

    params[@"useBalanceFlag"] = @(0);  //是否开启余额支付(1-开启 0-未开启)
    if (iISYuEPay)
     {
        params[@"useBalanceFlag"] = @(1);  //是否开启余额支付(1-开启 0-未开启)
        params[@"tradePassword"] = tradePassword; // 支付密码(余额开启需要)
     }
    
    
    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:strUrl
                                                                               parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      [self handleData:operation];
                                                                                  }failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      [self handleErrorData:operation];
                                                                                  }];
    operation.tag = 1001;
    [operation start];
}

-(void)handleData:(DDGAFHTTPRequestOperation *)operation
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if (1000 == operation.tag )
     {
        dicOfUI = operation.jsonResult.attr;
        arrOfUI = operation.jsonResult.rows;
        
        
        goodsTotalAmt = [dicOfUI[@"goodsTotalAmt"] floatValue];
        postage =  [dicOfUI[@"postage"] floatValue];
        usableAmount = [dicOfUI[@"usableAmount"] floatValue];
        
        NSDictionary *defPromoCardInfo = dicOfUI[@"defPromoCardInfo"];
        if (defPromoCardInfo &&
            [defPromoCardInfo isKindOfClass:[NSDictionary class]]&&
            [defPromoCardInfo count] > 0)
         {
        
            if (defPromoCardInfo[@"custPromocardId"])
             {
                _custPromocardId = [NSString stringWithFormat:@"%@", defPromoCardInfo[@"custPromocardId"]];
             }
            if (defPromoCardInfo[@"promocardId"])
             {
                promocardId = [NSString stringWithFormat:@"%@", defPromoCardInfo[@"promocardId"]];
             }
            
            promocardValue = [defPromoCardInfo[@"promocardValue"] floatValue];
         }
        
        NSDictionary *curAddr = dicOfUI[@"addrInfo"];
        
        if ([dicLastAddrInfo isEqual:curAddr])
         {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            return;
         }
        
        [self layoutUI:dicOfUI andArr:arrOfUI];
        
        dicLastAddrInfo = dicOfUI[@"addrInfo"];
     }
    else if (1001 == operation.tag)
     {
        
        NSDictionary *dic = operation.jsonResult.attr;
        int  payStatus = [dic[@"payStatus"] intValue]; // （0-未完成支付需继续支付，1-完成支付）
        if (0 == payStatus)
         {
            SelPayVC  *VC = [[SelPayVC alloc] init];
            VC.dicPay = operation.jsonResult.attr;
            [self.navigationController pushViewController:VC animated:YES];
         }
        else if (1 == payStatus)
         {
            PayResultVC  *VC = [[PayResultVC alloc] init];
            VC.isSuceess = TRUE;
            [self.navigationController pushViewController:VC animated:YES];
         }
        

     }
}

-(void)handleErrorData:(DDGAFHTTPRequestOperation *)operation{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
    
}


#pragma mark  ---  action
//添加手势点击空白处隐藏键盘
-(void)TouchViewKeyBoard
{
    [self.view endEditing:YES];
}


-(void) actionAddAddress
{
    AddressViewController *ctl = [[AddressViewController alloc]init];
    [self.navigationController pushViewController:ctl animated:YES];
}

-(void) actionUpdateAddress
{

    AddressViewController *ctl = [[AddressViewController alloc]init];
    ctl.selectType = 101;
    ctl.selAddressBlock = ^(id obj) {
        NSDictionary *dicAddr = (NSDictionary *)obj;
        
        addrId = [ NSString stringWithFormat:@"%@", dicAddr[@"addrId"]];
        labelAddrPhone.text = [ NSString stringWithFormat:@"%@", dicAddr[@"receiveTel"]];;
        labelAddrName.text = [ NSString stringWithFormat:@"%@", dicAddr[@"receiveName"]];;
        labelAddr.text = [ NSString stringWithFormat:@"%@", dicAddr[@"fullAddrDesc"]];;
        
    };
    [self.navigationController pushViewController:ctl animated:YES];
    
    _isNotLoadData = NO;
}


-(void) actionPay
{
    if (!isCheckXY)
     {
        [MBProgressHUD showErrorWithStatus:@"请同意天狗窝商城服务协议" toView:self.view];
        return;
     }
    
    int hasAddr = [dicOfUI[@"hasAddr"] intValue];
    if (0 ==  hasAddr)
     {
        [MBProgressHUD showErrorWithStatus:@"请选择收货地址" toView:self.view];
        return;
     }
    
    
    if (addrId.length <= 0)
     {
        [MBProgressHUD showErrorWithStatus:@"请选择收货地址" toView:self.view];
        return;
     }
    
    
    if (iISYuEPay == 1 )
     {
        if (tradePassword.length <= 0)
         {
            if (usableAmount >= (goodsTotalAmt - promocardValue - fYEDK))
             {
                paymentPWViewController *ctl = [[paymentPWViewController alloc]init];
                ctl.titleStr = @"验证支付密码";
                ctl.isValidatePassWord = YES;
                [self.navigationController pushViewController:ctl animated:YES];
                return;
             }
         }
     }
    
    NSLog(@"actionPay");
    
    _isNotLoadData = YES;
    
    [self commitOrder];

    
}

-(void) actionPopIsPay
{
    CDWAlertView *alertView = [[CDWAlertView alloc] init];
    
    alertView.shouldDismissOnTapOutside = NO;
    alertView.textAlignment = RTTextAlignmentCenter;
    
    // 降低高度
    [alertView subAlertCurHeight:10];
    //[alertView addSubTitle:[NSString stringWithFormat:@"<font size = 18 color=#000000>确定要放弃付款吗？</font>"]];
    
    // 加入message
    NSString *strXH= [NSString stringWithFormat:@"土豪，您用的%d元无门槛购物券，要不要多买点东西？",(int)promocardValue];
    [alertView addSubTitle:[NSString stringWithFormat:@"<font size = 14 color=#333333> %@ </font>",strXH]];
    
    [alertView subAlertCurHeight:10];
    
    //__weak typeof(self) weakSelf = self;
    
    [alertView addCanelButton:@"不差钱" actionBlock:^{
        
    }];
    
    [alertView addButton:@"好的" color:[ResourceManager priceColor] actionBlock:^{
        
        [self.navigationController popToRootViewControllerAnimated:NO];
        [[NSNotificationCenter defaultCenter] postNotificationName:DDGSwitchTabNotification object:@{@"tab":@(1),@"index":@(0)}];
    }];
    
    [alertView showAlertView:self.parentViewController duration:0.0];
    
    
}


-(void) actionSelQuan
{
    NSLog(@"actionSelQuan");
    if (dicOfUI)
     {
        NSArray *arr = dicOfUI[@"promocardList"];
        if (arr &&
            [arr isKindOfClass:[NSArray class]]&&
            [arr count] >=1)
         {
            SelCouponVC *VC = [[SelCouponVC alloc] init];
            VC.arrCoupon = arr;
            VC.custPromocardId = _custPromocardId;
            
            __weak OrderDetialVC *weakSelf = self;
            
            VC.sel_bolck = ^(id obj) {

                weakSelf.isNotLoadData = YES;
                
                //  没有优惠券
                if (!obj)
                 {
                    [self noYHQAfterSel];
                 }
                else
                 {
                    [self haveYHQAfterSel:obj];
                 }
            };
            
            [self.navigationController pushViewController:VC animated:YES];
            
         }
     }
}

-(void)  noYHQAfterSel
{
    promocardValue = 0;
    promocardId = @"";
    _custPromocardId = @"";
    lableYHJ.text = @"不用券"; // 优惠券的面值
    [self layoutBottomView];
    
    //fYEDK = (goodsTotalAmt - promocardValue);
    //labelYuEDK.text = [NSString stringWithFormat:@"余额抵扣 :¥0.00"];
    
    if (!btnBalance.selected)
     {
        iISYuEPay = 0;
        fYEDK = 0.0;
        labelYuEDK.text = [NSString stringWithFormat:@"余额抵扣 :¥%.2f",0.00 ];
     }
    else
     {
        if (usableAmount > (goodsTotalAmt - promocardValue + postage))
         {
            fYEDK = (goodsTotalAmt - promocardValue + postage);
         }
        else
         {
            fYEDK = usableAmount;
         }
        labelYuEDK.text = [NSString stringWithFormat:@"余额抵扣 :¥%.2f",fYEDK ];
     }
    
    [self layoutBottomView];
    
}

-(void)  haveYHQAfterSel:(NSDictionary *) dicValue
{
    promocardValue = [dicValue[@"promocardValue"] floatValue];
    promocardId = [NSString stringWithFormat:@"%@", dicValue[@"promocardId"]];
    _custPromocardId = [NSString stringWithFormat:@"%@", dicValue[@"custPromocardId"]];
    lableYHJ.text = [NSString stringWithFormat:@"-¥%.2f",promocardValue]; // 优惠券的面值
    
    if (btnBalance.selected)
     {
        if (usableAmount > (goodsTotalAmt - promocardValue + postage))
         {
            fYEDK = (goodsTotalAmt - promocardValue + postage);
         }
        else
         {
            fYEDK = usableAmount;
         }
        
        labelYuEDK.text = [NSString stringWithFormat:@"余额抵扣 :¥%.2f",fYEDK ];
     }
    else
     {
        iISYuEPay = 0;
        fYEDK = 0.0;
        labelYuEDK.text = [NSString stringWithFormat:@"余额抵扣 :¥%.2f",0.00 ];
     }
    
    [self layoutBottomView];
    
    float fTotalPrice = goodsTotalAmt - promocardValue - fYEDK + postage;
    if (fTotalPrice < 0.00)
     {
        // 如果抵扣券大于 实际支付的金额
        [self performSelector:@selector(actionPopIsPay) withObject:nil afterDelay:0.5];// 延迟执行;
     }
    
}

-(void) actionCheck:(UIButton*) sender
{
    sender.selected = !sender.selected;
    isCheckXY = sender.selected;
}

-(void) actionCheckDZFP:(UIButton*) sender
{
    sender.selected = !sender.selected;
    isCheckDZFP = sender.selected;
    
    if(isCheckDZFP)
     {
        btnDZFP.hidden = NO;
        labelDZFP.text = @"电子发票";
        lableDZQType.text = @"";
        [self actionDZFP];
     }
    else
     {
        btnDZFP.hidden = YES;
        labelDZFP.text = @"我要开发票";
        lableDZQType.text = @"";
     }
}

-(void) actionDZFP
{
    NSLog(@"actionDZFP");
    
    InvoiceInfoVC  *VC = [[InvoiceInfoVC alloc] init];
    
    float fTotalPrice = goodsTotalAmt - promocardValue - fYEDK;
    VC.price = [NSString stringWithFormat:@"¥%.2f", fTotalPrice];
    
    if (fTotalPrice <= 0)
     {
        [MBProgressHUD showErrorWithStatus:@"支付金额为零，不能开发票。" toView:self.view];
        isCheckDZFP = NO;
        return;
     }
    
    VC.invoiceBlock = ^(id invoiceData) {
        NSLog(@"actionDZFP  选择了 %@", invoiceData);
        NSDictionary *dic = invoiceData;
        
        lableDZQType.text = [NSString stringWithFormat:@"%@", dic[@"invoice"]];
        invoiceId = [NSString stringWithFormat:@"%@", dic[@"invoiceId"]];
        
    };
    
    [self.navigationController pushViewController:VC animated:YES];
    
    _isNotLoadData = YES;
    
    
}

-(void) actionXieYi
{
    NSLog(@"actionXieYi");
    NSString *url = [NSString stringWithFormat:@"%@webMall/protocol/service?type=ios",[PDAPI WXSysRouteAPI]];
    [CCWebViewController showWithContro:self withUrlStr:url withTitle:@"天狗窝商城服务协议"];
}

-(void) actionBalance:(UIButton*) sender
{
    if (usableAmount <= 0.00)
     {
        [MBProgressHUD showErrorWithStatus:@"可用余额为零，不支持余额抵扣" toView:self.view];
        return;
     }
    
    sender.selected = !sender.selected;
    if (!sender.selected)
     {
        iISYuEPay = 0;
        fYEDK = 0.0;
        labelYuEDK.text = [NSString stringWithFormat:@"余额抵扣 :¥%.2f",0.00 ];
     }
    else
     {
        iISYuEPay = 1;
        
        // 查询是否有支付密码
        if ([[[CommonInfo userInfo] objectForKey:@"hasTradePwd"] intValue] != 1) {
            PhoneCheckViewController *ctl = [[PhoneCheckViewController alloc]init];
            ctl.titleStr = @"设置支付密码";
            ctl.popVC = self;
            [self.navigationController pushViewController:ctl animated:YES];
        }
       
        
        // 计算余额抵扣
        if (usableAmount > (goodsTotalAmt - promocardValue + postage))
         {
            fYEDK = (goodsTotalAmt - promocardValue + postage);
         }
        else
         {
            fYEDK = usableAmount;
            
            if (tradePassword.length <= 0)
             {
                paymentPWViewController *ctl = [[paymentPWViewController alloc]init];
                ctl.titleStr = @"验证支付密码";
                ctl.isValidatePassWord = YES;
                [self.navigationController pushViewController:ctl animated:YES];
             }
         }
        labelYuEDK.text = [NSString stringWithFormat:@"余额抵扣 :¥%.2f",fYEDK ];
        
        NSString *strAll = [NSString stringWithFormat:@"余额抵扣 :¥%.2f",fYEDK ];;
        NSString *strSub = [NSString stringWithFormat:@"¥%.2f",fYEDK ];
        NSRange range = [strAll rangeOfString:strSub];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:strAll];
        [str addAttribute:NSForegroundColorAttributeName value:[ResourceManager priceColor] range:range]; //设置字体颜色
        labelYuEDK.attributedText = str;
     }
    
    [self layoutBottomView];
}

#pragma mark === UITextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (1000 == textField.tag)
     {
        [scView setContentOffset:CGPointMake(0,200) animated:YES];
     }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (1000 == textField.tag)
     {
        [scView setContentOffset:CGPointMake(0,0) animated:YES];
     }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (1000 == textField.tag)
     {
        //这里的if时候为了获取删除操作,如果没有次if会造成当达到字数限制后删除键也不能使用的后果.
        if (range.length == 1 && string.length == 0) {
            return YES;
        }
        if(textField.text.length >= 45) {
            //输入的字符个数大于45，则无法继续输入，返回NO表示禁止输入
            [MBProgressHUD showErrorWithStatus:@"输入字符长度大于45" toView:self.view];
            return NO;
        } else {
            return YES;
        }
     }
    return YES;
}

#pragma mark ---通知事件
-(void) getPayPassWord:(NSNotification *)notification
{
    NSLog(@"user info is %@",notification.object);
    NSDictionary *dic = notification.object;
    
    tradePassword = [dic objectForKey:@"password"] ;
    
    if (usableAmount >= (goodsTotalAmt - promocardValue))
     {
       [self  commitOrder];
     }
    
}

@end
