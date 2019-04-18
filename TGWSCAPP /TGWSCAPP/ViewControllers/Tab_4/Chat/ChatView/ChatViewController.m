//
//  ViewController.m
//  XMPPChat
//
//  Created by 123 on 2017/12/14.
//  Copyright © 2017年 123. All rights reserved.
//

// Demo的Url
// https://www.jianshu.com/p/c58ad8ad75a5

#import "ChatViewController.h"
#import "CSMessageCell.h"
#import "CSMessageModel.h"
#import "CSRecord.h"
#import "EvaluateView.h"
#import "SocketManager.h"
#import "WebSocketManager.h"




#define ScreenWidth  [UIScreen mainScreen].bounds.size.width
#define ScreenHight [UIScreen mainScreen].bounds.size.height

@interface ChatViewController ()< UITableViewDelegate, UITableViewDataSource, UITextViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,CSMessageCellDelegate, EmojiViewDelegate>
{
    UITextView *textSendView;  // 发送文本框
    UIButton *sendBtn;         // 发送按钮
    
    CustomNavigationBarView *nav;
    UIButton *btnRGKF;  // 人工客服按钮
    UIButton *btnPJ;    // 评价按钮
    UIButton *btnExit;  // 退出按钮
    
    UIImageView *imgBtnPJ;
    UILabel   *lableBtnPJ;
    
    EvaluateView  *evaluteView; // 评价view
    
    WebSocketManager   *socketManager; // 通讯管理组件
    
    NSMutableArray  *arrQuestion;  // 热门问题数组
    NSMutableArray  *arrAnswer;    // 热门问题的答案数组
    
    BOOL  isRGFW;   // 是否人工服务
    BOOL isGetData;  // 是否获取过历史记录
}



@end

@implementation ChatViewController


#pragma mark --- lifecyle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self initData];
    
    nav = [self layoutNaviBarViewWithTitle:@"客服聊天"];
    
    [self layoutNavButton];
    
    _dataArray = [NSMutableArray arrayWithCapacity:0];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NavHeight, SCREEN_WIDTH, SCREEN_HEIGHT-NavHeight - 44)   style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    _tableView.backgroundColor = [[UIColor alloc] initWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    
    // 设置数据库的名字
    NSDictionary *dic = [CommonInfo userInfo];
    if (dic)
     {
        bg_chat_tablename = [NSString stringWithFormat:@"chatmessage%@",dic[@"telephone"]];
     }
    
    
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getDBData)];

    //[self getDBData];
    
    // 从后台获取热门问题
    [self queryHotQuestion];
    
    
    // 人工客服初始化代码
    socketManager = [[WebSocketManager alloc] init];
    
    
    _bigImageView = [[CSBigView alloc] init];
    _bigImageView.frame = [UIScreen mainScreen].bounds;
    
    _ev = [[EmojiView alloc] initWithFrame:CGRectMake(0, ScreenHight - 180, ScreenWidth, 180)];
    _ev.hidden = YES;
    _ev.delegate = self;
    [self.view addSubview:_ev];
    
    _tableView.separatorColor = [UIColor clearColor];
    
    
    
    //添加手势点击空白处隐藏 弹出框
    UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TouchHideView)];
    gesture.numberOfTapsRequired  = 1;
    [_tableView addGestureRecognizer:gesture];

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    // 注册收到消息的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reciveChatMsg:) name:DDGReciveChatMsgNotification object:nil];

}

-(void)keyboardWillShow:(NSNotification *)aNotification
{
    _ev.hidden = YES;
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;

    // 调整_tableView 的滚动位置
    [self tabeleViewMidScorllEnd:height];
    
    UIView *vi = [self.view viewWithTag:100];
    CGRect rec = vi.frame ;
    rec.origin.y = _nowHeight - height;
    vi.frame = rec;
}

- (void)keyboardWillHide:(NSNotification *)aNotification
{
    _ev.hidden = YES;

    // 滚动到最后一列
    [self tabeleViewScorllEnd];
    
    UIView *vi = [self.view viewWithTag:100];
    vi.frame = CGRectMake(0, _nowHeight, [UIScreen mainScreen].bounds.size.width, 44);
}


-(void) initData
{
    arrQuestion = [[NSMutableArray alloc] init];  // 热门问题数组
    arrAnswer = [[NSMutableArray alloc] init];    // 热门问题的答案数组
}


#pragma mark  ---  布局UI
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    UIView *vi = [self.view viewWithTag:100];
    if (!vi)
    {
       _nowHeight =  SCREEN_HEIGHT- 44; //_tableView.frame.size.height;
       [self bottomView];
       
       [self tabeleViewScorllEnd];
       
       [self laytoutEvaluateView];
    }
    
}

-(void) layoutNavButton
{
    float fRightBtnTopY =  NavHeight - 50;
//    if (IS_IPHONE_X_MORE)
//     {
//        fRightBtnTopY = NavHeight - 36;
//     }
    
    //导航右边按钮
    {
       UIButton *rightNavBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 60.f,fRightBtnTopY,60.f, 46.0f)];
       [nav addSubview:rightNavBtn];
       //rightNavBtn.backgroundColor = [UIColor yellowColor];
       [rightNavBtn addTarget:self action:@selector(actionRGKF) forControlEvents:UIControlEventTouchUpInside];
       
       UIImageView *imgViewTop = [[UIImageView alloc] initWithFrame:CGRectMake(21, 10, 18, 18)];
       [rightNavBtn addSubview:imgViewTop];
       imgViewTop.image = [UIImage imageNamed:@"chat_rgkf"];
       
       UILabel *labelT = [[UILabel alloc] initWithFrame:CGRectMake(0, 28, 60, 20)];
       [rightNavBtn addSubview:labelT];
       labelT.font = [UIFont systemFontOfSize:10];
       labelT.textColor = [ResourceManager navgationTitleColor];
       labelT.textAlignment = NSTextAlignmentCenter;
       labelT.text = @"人工客服";
       
       btnRGKF = rightNavBtn;
    }
    
    // 导航栏右侧的两个按钮
    {
       int iBtnWidth = 35;
       UIButton *rightNavBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - iBtnWidth -5,fRightBtnTopY,iBtnWidth, 46.0f)];
       [nav addSubview:rightNavBtn];
       //rightNavBtn.backgroundColor = [UIColor yellowColor];
       [rightNavBtn addTarget:self action:@selector(actionExit) forControlEvents:UIControlEventTouchUpInside];
       
       UIImageView *imgViewTop = [[UIImageView alloc] initWithFrame:CGRectMake((iBtnWidth-18)/2, 10, 18, 18)];
       [rightNavBtn addSubview:imgViewTop];
       imgViewTop.image = [UIImage imageNamed:@"chat_exit"];
       
       UILabel *labelT = [[UILabel alloc] initWithFrame:CGRectMake(0, 28, iBtnWidth, 20)];
       [rightNavBtn addSubview:labelT];
       labelT.font = [UIFont systemFontOfSize:10];
       labelT.textColor = [ResourceManager navgationTitleColor];
       labelT.textAlignment = NSTextAlignmentCenter;
       labelT.text = @"退出";
       
       btnExit = rightNavBtn;
       btnExit.hidden = YES;
    
    }
    
     // 导航栏右侧的两个按钮
    {
       int iBtnWidth = 35;
       UIButton *rightNavBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 2*iBtnWidth -5,fRightBtnTopY,iBtnWidth, 46.0f)];
       [nav addSubview:rightNavBtn];
       //rightNavBtn.backgroundColor = [UIColor yellowColor];
       [rightNavBtn addTarget:self action:@selector(actionPJ) forControlEvents:UIControlEventTouchUpInside];
       
       UIImageView *imgViewTop = [[UIImageView alloc] initWithFrame:CGRectMake((iBtnWidth-18)/2, 10, 18, 18)];
       [rightNavBtn addSubview:imgViewTop];
       imgViewTop.image = [UIImage imageNamed:@"chat_pj"];
       
       UILabel *labelT = [[UILabel alloc] initWithFrame:CGRectMake(0, 28, iBtnWidth, 20)];
       [rightNavBtn addSubview:labelT];
       labelT.font = [UIFont systemFontOfSize:10];
       labelT.textColor = [ResourceManager navgationTitleColor];
       labelT.textAlignment = NSTextAlignmentCenter;
       labelT.text = @"评价";
       
       imgBtnPJ = imgViewTop;
       lableBtnPJ = labelT;
       
       btnPJ = rightNavBtn;
       btnPJ.hidden = YES;
    
    }
    
    
    
    
    
}


#pragma mark  ---  布局底部输入框
-(void)bottomView
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, _nowHeight, [UIScreen mainScreen].bounds.size.width, 44)];
    bgView.tag = 100;  // 底部view的 tag
    bgView.backgroundColor = [[UIColor alloc] initWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    bgView.layer.masksToBounds = YES;
    bgView.layer.borderColor = [[UIColor alloc] initWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1].CGColor;
    bgView.layer.borderWidth = 1;
    [self.view addSubview:bgView];
    
    textSendView = [[UITextView alloc] initWithFrame:CGRectMake(49, 0, bgView.bounds.size.width - 122, 44)];
    textSendView.delegate = self;
    textSendView.tag = 101;
    textSendView.returnKeyType = UIReturnKeySend;
    textSendView.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    textSendView.text = @"";
    [bgView addSubview:textSendView];
    
    
    
    //    UIButton *recordBtn = [[UIButton alloc] init];
    //    recordBtn.frame = CGRectMake(10, 5, 34, 34);
    //    [recordBtn setBackgroundImage:[UIImage imageNamed:@"record"] forState:UIControlStateNormal];
    //    [recordBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    //    [recordBtn addTarget:self action:@selector(leaveBtnClicked:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    //    [recordBtn addTarget:self action:@selector(touchDown:)forControlEvents: UIControlEventTouchDragInside];
    //    [bgView addSubview:recordBtn];
    
    UIButton *emojiBtn = [[UIButton alloc] init];
    emojiBtn.frame = CGRectMake(10, 10, 24, 24);//CGRectMake(bgView.frame.size.width - 83, 5, 34, 34);
    [emojiBtn setBackgroundImage:[UIImage imageNamed:@"emoji"] forState:UIControlStateNormal];
    [emojiBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    emojiBtn.tag = 12;
    [bgView addSubview:emojiBtn];
    
    sendBtn = [[UIButton alloc] init];
    sendBtn.frame = CGRectMake(bgView.frame.size.width - 60, 5, 50, 34);
    [bgView addSubview:sendBtn];
    sendBtn.backgroundColor = UIColorFromRGB(0xb7b7b7);
    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sendBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [sendBtn addTarget:self action:@selector(actionSendMessage) forControlEvents:UIControlEventTouchUpInside];
    sendBtn.tag = 13;
    sendBtn.cornerRadius = 3;
    
    
}


//-(void)bottomView
//{
//    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, _nowHeight, [UIScreen mainScreen].bounds.size.width, 44)];
//    bgView.tag = 100;  // 底部view的 tag
//    bgView.backgroundColor = [[UIColor alloc] initWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
//    bgView.layer.masksToBounds = YES;
//    bgView.layer.borderColor = [[UIColor alloc] initWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1].CGColor;
//    bgView.layer.borderWidth = 1;
//    [self.view addSubview:bgView];
//
//    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(49, 0, bgView.bounds.size.width - 152, 44)];
//    textView.delegate = self;
//    textView.tag = 101;
//    textView.returnKeyType = UIReturnKeySend;
//    textView.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
//    textView.text = @"";
//    [bgView addSubview:textView];
//
//
//
//    UIButton *recordBtn = [[UIButton alloc] init];
//    recordBtn.frame = CGRectMake(10, 5, 34, 34);
//    [recordBtn setBackgroundImage:[UIImage imageNamed:@"record"] forState:UIControlStateNormal];
//    [recordBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [recordBtn addTarget:self action:@selector(leaveBtnClicked:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
//    [recordBtn addTarget:self action:@selector(touchDown:)forControlEvents: UIControlEventTouchDragInside];
//    [bgView addSubview:recordBtn];
//
//    UIButton *emojiBtn = [[UIButton alloc] init];
//    emojiBtn.frame = CGRectMake(bgView.frame.size.width - 83, 5, 34, 34);
//    [emojiBtn setBackgroundImage:[UIImage imageNamed:@"emoji"] forState:UIControlStateNormal];
//    [emojiBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
//    emojiBtn.tag = 12;
//    [bgView addSubview:emojiBtn];
//
//    UIButton *imageBtn = [[UIButton alloc] init];
//    imageBtn.frame = CGRectMake(bgView.frame.size.width - 39, 5, 34, 34);
//    [imageBtn setBackgroundImage:[UIImage imageNamed:@"image"] forState:UIControlStateNormal];
//    [imageBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
//    imageBtn.tag = 13;
//    [bgView addSubview:imageBtn];
//
//}


-(void) laytoutEvaluateView
{
    evaluteView = [[EvaluateView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:evaluteView];
    evaluteView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.7];
    evaluteView.hidden = YES;
    
    
    __weak WebSocketManager *weakSockM = socketManager;
    __weak EvaluateView *weakEvaluteView= evaluteView;
    __weak typeof(self) weakSelf = self;
    evaluteView.bolck_comit = ^(id obj) {
      
        NSLog(@"evaluteView.bolck_comit :%@", obj);
        
        if(obj)
         {
            BOOL sendSucees =   [weakSockM sendDic:obj];
            if (sendSucees)
             {
                weakEvaluteView.hidden = YES;
                
                [weakSelf chagePJState];
             }
            else
             {
                [MBProgressHUD showErrorWithStatus:@"网络异常，请稍后再发送" toView:weakSelf.view];
             }
         }
    };
}

-(void) chagePJState
{
    imgBtnPJ.image = [UIImage imageNamed:@"chat_pj_success"];;
    lableBtnPJ.text = @"已评价";
}

#pragma mark ---  智能客服相关代码
-(void) initCustonSerivce
{
    CSMessageModel *model = [[CSMessageModel alloc] init];
    model.messageSenderType = MessageSenderTypeOther;
    model.messageType = MessageTypeQuestion;
    model.messageText = textSendView.text;

    model.tiltleQuestion = @"热门问题";
    //NSArray *arrQuestion = @[@"如何退差价",@"如何退货",@"退换快递单号填写错误了"];
    model.arrQuestion = arrQuestion;
    
    [self setShowTime:model];
    [_dataArray addObject:model];
    [model bg_save];
    
    [_tableView reloadData];
    [self tabeleViewScorllEnd];
    
}

-(void) answerCostonService:(NSString*) strQuestion
{
    int iAllQuestionCount = (int)arrAnswer.count;
    for (int i  = 0; i < iAllQuestionCount; i++)
     {
        NSString *strNo = [NSString stringWithFormat:@"%d",i+1];
        NSString *strAnswer = arrAnswer[i]; //[NSString stringWithFormat:@"正在回答第%d个问题",i];
        if ([strQuestion isEqualToString:strNo])
         {
            CSMessageModel *model = [[CSMessageModel alloc] init];
            model.messageSenderType = MessageSenderTypeOther;
            model.messageType = MessageTypeText;
            model.messageText = strAnswer;
            
            [self setShowTime:model];
            [_dataArray addObject:model];
            [model bg_save];
            
            [_tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:_dataArray.count - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:_dataArray.count - 1 inSection:0]
                                        animated:YES
                                  scrollPosition:UITableViewScrollPositionMiddle];
         }
     }

    
}

-(void) exitCustonSerivce
{
    CSMessageModel *model = [[CSMessageModel alloc] init];
    model.messageSenderType = MessageSenderTypeOther;
    model.messageType = MessageTypeText;
    model.messageText = @"";
    
    [self setShowTime:model];
    //FIXME: 此处为“人工客服已经退出”的的显示， 只发送时间字符串， 不显示头像和文本字符！！！！！！！！！
    model.onlyShowTime = YES;
    model.showMessageTime = YES;
    model.messageTime = @"人工客服已经退出";
    
    [self setShowTime:model];
    [_dataArray addObject:model];
    [model bg_save];
    
}

#pragma mark ---  UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CSMessageCell *cell=[CSMessageCell cellWithTableView:tableView messageModel:_dataArray[indexPath.row]];
    cell.delegate = self;
    cell.backgroundColor = [[UIColor alloc] initWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CSMessageModel *model = _dataArray[indexPath.row];
    return [model cellHeight];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}
- (void)messageCellSingleClickedWith:(CSMessageCell *)cell
{
    
    [self.view endEditing:YES];
    
    
    if (_ev.hidden == NO)
    {
        _ev.hidden = YES;
        // 调整tableView的高度
        //_tableView.height = SCREEN_HEIGHT - 44 - NavHeight;
       [self tabeleViewScorllEnd];
       
        UIView *vi = [self.view viewWithTag:100];
        vi.frame = CGRectMake(0, _nowHeight, [UIScreen mainScreen].bounds.size.width, 44);
    }
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    CSMessageModel *model = _dataArray[indexPath.row];
    if (model.messageType == MessageTypeVoice)
    {
        [[CSRecord ShareCSRecord] playRecord];
        
        if ([_selectIndex isEqual: indexPath] == NO)
        {
            
            CSMessageCell *cell1 = [self.tableView cellForRowAtIndexPath:_selectIndex];
            [cell1 stopVoiceAnimation];
            
            _selectIndex = indexPath;
            [cell startVoiceAnimation];
        }
        else
        {
            if (cell.voiceAnimationImageView.isAnimating)
            {
                [cell stopVoiceAnimation];
            }
            else
            {
                [cell startVoiceAnimation];
            }
        }
    }
    else if (model.messageType == MessageTypeImage)
    {
        _bigImageView.bigImageView.image = model.imageSmall;
        _bigImageView.show = YES;
        
//        [[UIApplication sharedApplication].keyWindow bringSubviewToFront:_bigImageView];
    }
    
}





#pragma mark --- action
-(void)clickNavButton:(UIButton *)button
{
    
    if (isRGFW)
     {
        [self performSelector:@selector(delayMethod) withObject:nil afterDelay:0.5];// 延迟执行
        return;
     }
    
    [self.navigationController popViewControllerAnimated:YES];
    return;
    
//    if (!isRGFW)
//     {
//        [self.navigationController popViewControllerAnimated:YES];
//        return;
//     }
//    
//    
//    CDWAlertView *alertView = [[CDWAlertView alloc] init];
//    
//    alertView.shouldDismissOnTapOutside = NO;
//    alertView.textAlignment = RTTextAlignmentCenter;
//    
//    // 降低高度
//    [alertView subAlertCurHeight:10];
//    //[alertView addSubTitle:[NSString stringWithFormat:@"<font size = 18 color=#000000>确定要放弃付款吗？</font>"]];
//    
//    // 加入message
//    NSString *strXH= [NSString stringWithFormat:@"离开后，聊天将在5分钟后结束。"];
//    [alertView addSubTitle:[NSString stringWithFormat:@"<font size = 14 color=#333333> %@ </font>",strXH]];
//    
//    [alertView subAlertCurHeight:10];
//    
//    [alertView addCanelButton:@"暂时离开" actionBlock:^{
//        
//        [self performSelector:@selector(delayMethod) withObject:nil afterDelay:0.5];// 延迟执行
//        
//    }];
//    
//    [alertView addButton:@"继续聊天" color:[ResourceManager priceColor] actionBlock:^{
//        
//        
//    }];
//    
//    [alertView showAlertView:self.parentViewController duration:0.0];
}


-(void) delayMethod
{
    [self exitCustonSerivce];
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) actionExit
{
    CDWAlertView *alertView = [[CDWAlertView alloc] init];
    
    alertView.shouldDismissOnTapOutside = NO;
    alertView.textAlignment = RTTextAlignmentCenter;
    
    // 降低高度
    [alertView subAlertCurHeight:10];
    //[alertView addSubTitle:[NSString stringWithFormat:@"<font size = 18 color=#000000>确定要放弃付款吗？</font>"]];
    
    // 加入message
    NSString *strXH= [NSString stringWithFormat:@"确认退出对话？"];
    [alertView addSubTitle:[NSString stringWithFormat:@"<font size = 14 color=#333333> %@ </font>",strXH]];
    
    [alertView subAlertCurHeight:10];
    
    __weak typeof(WebSocketManager*) weakSocketM = socketManager;
    
    [alertView addCanelButton:@"确定" actionBlock:^{
        
        [weakSocketM sendClose];
        
        [self performSelector:@selector(delayMethod) withObject:nil afterDelay:0.5];// 延迟执行
        
    }];
    
    [alertView addButton:@"取消" color:[ResourceManager priceColor] actionBlock:^{
        
    }];
    
    [alertView showAlertView:self.parentViewController duration:0.0];
    
    
}

// 隐藏所有输入框，笑脸符号框
-(void) TouchHideView
{
    [self.view endEditing:YES];
    _ev.hidden = YES;
    
    UIView *vi = [self.view viewWithTag:100];
    vi.frame = CGRectMake(0, SCREEN_HEIGHT-44, [UIScreen mainScreen].bounds.size.width, 44);
    
}


#pragma mark ---  发送文本消息
-(void) actionSendMessage
{
    if (textSendView.text.length <= 0)
     {
        [MBProgressHUD showErrorWithStatus:@"请输入文本" toView:self.view];
        return;
     }
    

    CSMessageModel *model = [[CSMessageModel alloc] init];
    model.messageSenderType = MessageSenderTypeMe;
    model.messageType = MessageTypeText;
    model.messageText = textSendView.text;
    //model.showMessageTime=YES;
    //model.messageTime = @"16:40";
    
    
    if (isRGFW)
     {
        //人工客服  发送文本到后台服务器
        BOOL sendSuccess = [socketManager sendText:model.messageText];
        if (!sendSuccess)
         {
            [MBProgressHUD showErrorWithStatus:@"网络异常，请稍后再试" toView:self.view];
            return;
         }
     }
    
    [self setShowTime:model];
    [_dataArray addObject:model];
    
    [_tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:_dataArray.count - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:_dataArray.count - 1 inSection:0]
                                animated:YES
                          scrollPosition:UITableViewScrollPositionMiddle];
    textSendView.text = @"";
    _ev.hidden = YES;
    [self.view endEditing:YES];
    
    UIView *vi = [self.view viewWithTag:100];
    vi.frame = CGRectMake(0, _nowHeight, [UIScreen mainScreen].bounds.size.width, 44);
    
    [model bg_save];
    
    
    if (!isRGFW)
     {
        // 智能客服
        [self answerCostonService:model.messageText];
     }

    sendBtn.backgroundColor = UIColorFromRGB(0xb7b7b7);
}


#pragma mark ---  点击键盘的“发送按钮”,发送文本消息
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"])
    {
        if (textView.text.length == 0)
        {
           [MBProgressHUD showErrorWithStatus:@"请输入文本" toView:self.view];
            return NO;
        }
        CSMessageModel *model = [[CSMessageModel alloc] init];
       
        model.messageSenderType = MessageSenderTypeMe;
        model.messageType = MessageTypeText;
        model.messageText = textView.text;
        //model.showMessageTime=YES;
        //model.messageTime = @"16:40";
       
    
       
       if (isRGFW)
        {
           //人工客服  发送文本到后台服务器
           BOOL sendSuccess = [socketManager sendText:model.messageText];
           
           if (!sendSuccess)
            {
               [MBProgressHUD showErrorWithStatus:@"网络异常，请稍后再试" toView:self.view];
               return NO;
            }
        }
    
       [self setShowTime:model];
       [_dataArray addObject:model];
       
       
       [_tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:_dataArray.count - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
       [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:_dataArray.count - 1 inSection:0]
                                   animated:YES
                             scrollPosition:UITableViewScrollPositionMiddle];
       textView.text = @"";
       
       [self.view endEditing:YES];
       
       [model bg_save];
       
       
       if (!isRGFW)
        {
           // 智能客服
           [self answerCostonService:model.messageText];
        }
       
        sendBtn.backgroundColor = UIColorFromRGB(0xb7b7b7);
       
        return NO;
    }
    
    sendBtn.backgroundColor = UIColorFromRGB(0x167ef9); //[ResourceManager blueColor];
    
    return YES;
}


// 设置此信息的时间， 是否显示， 显示为何种类型 (2019-01-01 15:11   或者 15:11)
-(void) setShowTime:(CSMessageModel*) messageModel
{
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    long time = (long)[datenow timeIntervalSince1970] *1000; // *1000 是精确到毫秒，不乘就是精确到秒
    messageModel.lMessageTime = time;
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    messageModel.wholeMessageTime = currentTimeString;
    
    if([self.dataArray count] == 0)
     {
        messageModel.showMessageTime = YES;
        messageModel.messageTime = currentTimeString;
     }
    else
     {
        CSMessageModel* lastModel =   self.dataArray.lastObject;
        
        if ( messageModel.lMessageTime - lastModel.lMessageTime > 24*60*60*1000)
         {
            // 超过24小时
            messageModel.showMessageTime = YES;
            messageModel.messageTime = currentTimeString;
            
         }
        else if ( messageModel.lMessageTime - lastModel.lMessageTime > 30*60*1000)
         {
            // 超过30分钟
            messageModel.showMessageTime = YES;
        
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
            [formatter setDateFormat:@"HH:mm:ss"];
            NSString *showTimeString = [formatter stringFromDate:datenow];
            messageModel.messageTime = showTimeString;
         }
     }
    
//    if (!isRGFW)
//     {
//        // 如果是人工客服，时间显示屏蔽掉
//        messageModel.showMessageTime = NO;
//     }
    
    
}


-(void) actionRGKF
{
    if (![ToolsUtlis isNetworkReachable])
     {
        [MBProgressHUD showErrorWithStatus:@"网络不稳定，无法连接人工客服。" toView:self.view];
        return;
     }
    
    
    isRGFW = YES;
    btnRGKF.hidden = YES;
    btnExit.hidden = NO;
    btnPJ.hidden = NO;

    CSMessageModel *model = [[CSMessageModel alloc] init];
    model.messageSenderType = MessageSenderTypeMe;
    model.messageType = MessageTypeText;
    model.messageText = textSendView.text;
    //model.showMessageTime=YES;
    //model.messageTime = @"16:40";
    
    [self setShowTime:model];
    
    //FIXME: 此处为“人工客服接入”的的显示， 只发送时间字符串， 不显示头像和文本字符！！！！！！！！！
    model.onlyShowTime = YES;
    model.showMessageTime = YES;
    model.messageTime = @"人工客服正在接入，请等待";
    [_dataArray addObject:model];
    [model bg_save];
    
    [_tableView reloadData];
    [self tabeleViewScorllEnd];
    
    [socketManager socketConnectHost];
    
}

-(void) actionPJ
{
    evaluteView.hidden = NO;
}




// 把tableView 滚动到底部
-(void) tabeleViewScorllEnd
{
    if (_dataArray.count > 1)
     {
        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:_dataArray.count-1 inSection:0];
        [self.tableView scrollToRowAtIndexPath:indexpath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
     }
}


// 有弹出界面时， 需要将tableview 底部往上滚动
-(void) tabeleViewMidScorllEnd:(float) popViewHeight
{
    if (_dataArray.count < 1)
     {
        return;
     }
    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:_dataArray.count-1 inSection:0];
    CGRect rectInTableView = [self.tableView rectForRowAtIndexPath:indexpath];

    CGSize rect = self.tableView.contentSize;
    
    int iLastRecrodY = rectInTableView.origin.y + rectInTableView.size.height +NavHeight;
    
    int iViewPopY = SCREEN_HEIGHT - 44 - popViewHeight;
    
    // 文字弹框时，滚动位置
    if(iLastRecrodY > iViewPopY)
     {
        [self.tableView setContentOffset:CGPointMake(0,rect.height - popViewHeight) animated:YES];
     }
    
    // 笑脸弹框时，滚动位置
    if(iLastRecrodY > iViewPopY &&
       !_ev.hidden)
     {
        [self.tableView setContentOffset:CGPointMake(0,rect.height- iViewPopY + popViewHeight ) animated:YES];
        
     }
    
    //[self.tableView setContentOffset:CGPointMake(0,rectInTableView.origin.y - rectInTableView.size.height - fHeight) animated:YES];

    
    
    
}



static int iiii = 0;
- (void)touchDown:(UIButton *)btn
{
    if (iiii == 0)
    {
        [[CSRecord ShareCSRecord] beginRecord];
        iiii = 1;
    }
    
}
- (void)leaveBtnClicked:(UIButton *)btn
{
    iiii = 0;
    NSLog(@"松开了");
    [[CSRecord ShareCSRecord] endRecord];
}
- (void)btnClicked:(UIButton *)btn
{
    [self.view endEditing:YES];
    _ev.hidden = YES;

    
    UIView *vi = [self.view viewWithTag:100];
    vi.frame = CGRectMake(0, _nowHeight, [UIScreen mainScreen].bounds.size.width, 44);
    switch (btn.tag)
    {
        case 11:
            
            break;
        case 12:
            
        {
           // 表情输入框显示出来
            _ev.hidden = NO;
        
           // 调整_tableView的高度
           [self tabeleViewMidScorllEnd:180];
           
            UIView *vi = [self.view viewWithTag:100];
            CGRect rec = vi.frame ;
            rec.origin.y = _nowHeight - 180;
            vi.frame = rec;

        }
            
            break;
        case 13:
            {
                
                
                
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请选择" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
                [alertController addAction:[UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    UIImagePickerController * picker = [[UIImagePickerController alloc]init];
                    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                        
                        //图片选择是相册（图片来源自相册）
                        
                        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                        
                        //设置代理
                        
                        picker.delegate=self;
                        
                        //模态显示界面
                        
                        [self presentViewController:picker animated:YES completion:nil];
                        
                    }
                    
                    else {
                        
                        NSLog(@"不支持相机");
                        
                    }
                    

                    NSLog(@"点击确认");
                    
                }]];
                [alertController addAction:[UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    UIImagePickerController * picker = [[UIImagePickerController alloc]init];
                    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                        
                        //图片选择是相册（图片来源自相册）
                        
                        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                        
                        //设置代理
                        
                        picker.delegate=self;
                        
                        //模态显示界面
                        
                        [self presentViewController:picker animated:YES completion:nil];
                        
                        
                        
                    }
                    
                    NSLog(@"点击确认");
                    
                }]];
                [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                    [self dismissViewControllerAnimated:YES completion:nil];
                    NSLog(@"点击取消");
                    
                }]];
                
                [self presentViewController:alertController animated:YES completion:nil];
                
            }
            break;
        default:
            break;
    }
    NSLog(@"呀！我这个按钮别点击了！");
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
     if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary)
     {
        UIImage * image =info[UIImagePickerControllerOriginalImage];
        CSMessageModel * model = [[CSMessageModel alloc] init];
         //model.showMessageTime=YES;
         model.messageSenderType = MessageSenderTypeOther;
         model.messageType = MessageTypeImage;
         model.imageSmall = image;
         //model.messageTime = @"16:40";
         [_dataArray addObject:model];
         [model bg_save];
        
         [_tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:_dataArray.count - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
         [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:_dataArray.count - 1 inSection:0]
                                     animated:YES
                               scrollPosition:UITableViewScrollPositionMiddle];
         
        [self dismissViewControllerAnimated:YES completion:nil];
     }
   else if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        UIImage * image =info[UIImagePickerControllerOriginalImage];
        CSMessageModel * model = [[CSMessageModel alloc] init];
        //model.showMessageTime=YES;
        model.messageSenderType = MessageSenderTypeOther;
        model.messageType = MessageTypeImage;
        model.imageSmall = image;
        //model.messageTime = @"16:40";
        [_dataArray addObject:model];
        [model bg_save];
       
        
        [_tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:_dataArray.count - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:_dataArray.count - 1 inSection:0]
                                    animated:YES
                              scrollPosition:UITableViewScrollPositionMiddle];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
- (void)showBigImage
{
    
}


#pragma mark --- 收到消息
-(void) reciveChatMsg:(NSNotification *)notification
{
    // 收到后台的消息
    NSDictionary *obj = notification.object;

    NSString *strJson = obj[@"msg"];
    NSData *data = [strJson dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err = nil;
    NSDictionary *dicALL = [NSJSONSerialization JSONObjectWithData:data options:0 error:&err];
    if (err)
     {
         NSLog(@"reciveChatMsg  json解析失败：%@",err);
        return;
     }
    
    NSDictionary *dic = dicALL[@"body"];
    // sys系统信息， tips提示消息 text文本消息
    // content  消息具体内容
    NSString *strType = dic[@"type"];
    if (!strType)
     {
        NSString *strReqType  = dicALL[@"reqType"];
        if (strReqType &&
            [strReqType isEqualToString:@"12"])
         {
            // 12 为 是否有评价的返回
            NSDictionary *dicAttr = dic[@"attr"];
            int hasPf = [dicAttr[@"hasPf"] intValue];
            if (1 == hasPf)
             {
                [self chagePJState];
             }
         }
        
        return;
     }
    
    if ([strType isEqualToString:@"sys"])
     {
        // 系统级别的消息，放弃
        return;
     }
    
    NSString  *strMsg = dic[@"content"];
    CSMessageModel *model = [[CSMessageModel alloc] init];
    model.messageSenderType = MessageSenderTypeOther;
    model.messageType = MessageTypeText;
    model.messageText = strMsg;
    
    [self setShowTime:model];
    
    if ([strType isEqualToString:@"tips"])
     {
        // 提示消息
        model.onlyShowTime = YES;
        model.showMessageTime = YES;
        model.messageTime = strMsg;

     }
    
    
    [_dataArray addObject:model];
    [model bg_save];
    
    [_tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:_dataArray.count - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:_dataArray.count - 1 inSection:0]
                                animated:YES
                          scrollPosition:UITableViewScrollPositionMiddle];
}

#pragma mark --- EmojiViewDelegate
- (void)emojiClicked:(NSString *)strEmoji {
    UITextView *tv = [self.view viewWithTag:101];
    tv.text = [tv.text stringByAppendingString:strEmoji];
    
}




#pragma mark --- 数据库操作
-(void) initDB
{
    
    CSMessageModel *model = [[CSMessageModel alloc] init];
    model.showMessageTime=YES;
    model.messageTime = @"2017年12月12日 16:37";
    model.messageSenderType = MessageSenderTypeMe;
    model.messageType = MessageTypeText;
    model.messageText = @"推开窗看见星星依然守在夜空中心中不免多了些暖暖的感动一闪一闪的光努力把黑夜变亮气氛如此安详你在我的生命中是那最闪亮的星一直在无声夜空守护着我们的梦这世界那么大 我的爱只想要你懂 陪伴我孤寂旅程你知道我的梦 你知道我的痛你知道我们感受都相同    就算有再大的风也挡不住勇敢的冲动    努力的往前飞 再累也无所谓    黑夜过后的光芒有多美    分享你我的力量就能把对方的路照亮    我想我们都一样    渴望梦想的光芒    这一路喜悦彷徨    不要轻易说失望    回到最初时光    当时的你多么坚强    那鼓励让我难忘";
    
    // 存储到数据库
    [model bg_save];
    
    
    
    
    
    model = [[CSMessageModel alloc] init];
    model.showMessageTime=YES;
    model.messageSenderType = MessageSenderTypeOther;
    model.messageType = MessageTypeText;
    model.messageText = @"我们都一样";
    model.messageTime = @"16:40";
    [model bg_save];
    
    
    model = [[CSMessageModel alloc] init];
    model.showMessageTime=YES;
    model.messageSenderType = MessageSenderTypeMe;
    model.messageType = MessageTypeText;
    model.messageText = @"我们都一样";
    model.messageTime = @"16:40";
    [model bg_save];
    
    
    
    model = [[CSMessageModel alloc] init];
    model.showMessageTime=YES;
    model.messageTime = @"2017年12月12日 16:37";
    model.messageSenderType = MessageSenderTypeOther;
    model.messageType = MessageTypeText;
    model.messageText = @"推开窗看见星星依然守在夜空中心中不免多了些暖暖的感动一闪一闪的光努力把黑夜变亮气氛如此安详你在我的生命中是那最闪亮的星一直在无声夜空守护着我们的梦这世界那么大 我的爱只想要你懂 陪伴我孤寂旅程你知道我的梦 你知道我的痛你知道我们感受都相同    就算有再大的风也挡不住勇敢的冲动    努力的往前飞 再累也无所谓    黑夜过后的光芒有多美    分享你我的力量就能把对方的路照亮    我想我们都一样    渴望梦想的光芒    这一路喜悦彷徨    不要轻易说失望    回到最初时光    当时的你多么坚强    那鼓励让我难忘";
    [model bg_save];
    
    
    model = [[CSMessageModel alloc] init];
    model.showMessageTime=YES;
    model.messageSenderType = MessageSenderTypeMe;
    model.messageType = MessageTypeVoice;
    model.duringTime = 30;
    model.messageTime = @"16:40";
    [model bg_save];
    
    model = [[CSMessageModel alloc] init];
    model.showMessageTime=YES;
    model.messageSenderType = MessageSenderTypeMe;
    model.messageType = MessageTypeVoice;
    model.duringTime = 15;
    model.messageTime = @"16:40";
    [model bg_save];
    
    model = [[CSMessageModel alloc] init];
    model.showMessageTime=YES;
    model.messageSenderType = MessageSenderTypeMe;
    model.messageType = MessageTypeVoice;
    model.duringTime = 100;
    model.messageTime = @"16:40";
    [model bg_save];
    
    
    model = [[CSMessageModel alloc] init];
    model.showMessageTime=YES;
    model.messageSenderType = MessageSenderTypeOther;
    model.messageType = MessageTypeVoice;
    model.duringTime = 20;
    model.messageTime = @"16:40";
    [model bg_save];
    
    model = [[CSMessageModel alloc] init];
    model.showMessageTime=YES;
    model.messageSenderType = MessageSenderTypeOther;
    model.messageType = MessageTypeVoice;
    model.duringTime = 10;
    model.messageTime = @"16:40";
    [model bg_save];
    
    model = [[CSMessageModel alloc] init];
    model.showMessageTime=YES;
    model.messageSenderType = MessageSenderTypeOther;
    model.messageType = MessageTypeVoice;
    model.duringTime = 15;
    model.messageTime = @"16:40";
    [model bg_save];
    
    model = [[CSMessageModel alloc] init];
    model.showMessageTime=YES;
    model.messageSenderType = MessageSenderTypeMe;
    model.messageType = MessageTypeImage;
    model.imageSmall = [UIImage imageNamed:@"w"];
    model.messageTime = @"16:40";
    [model bg_save];
    
    
    model = [[CSMessageModel alloc] init];
    model.showMessageTime=YES;
    model.messageSenderType = MessageSenderTypeOther;
    model.messageType = MessageTypeImage;
    model.imageSmall = [UIImage imageNamed:@"mm"];
    model.messageTime = @"16:40";
    [model bg_save];
    
    
    model = [[CSMessageModel alloc] init];
    model.showMessageTime=YES;
    model.messageSenderType = MessageSenderTypeMe;
    model.messageType = MessageTypeImage;
    model.imageSmall = [UIImage imageNamed:@"w"];
    model.messageTime = @"16:40";
    [model bg_save];
    
    model = [[CSMessageModel alloc] init];
    model.showMessageTime=YES;
    model.messageSenderType = MessageSenderTypeOther;
    model.messageType = MessageTypeImage;
    model.imageSmall = [UIImage imageNamed:@"m"];
    model.messageTime = @"16:40";
    [model bg_save];
    
    model = [[CSMessageModel alloc] init];
    model.showMessageTime=YES;
    model.messageSenderType = MessageSenderTypeMe;
    model.messageType = MessageTypeImage;
    model.imageSmall = [UIImage imageNamed:@"dd"];
    model.messageTime = @"16:40";
   [model bg_save];
    
    model = [[CSMessageModel alloc] init];
    model.showMessageTime=YES;
    model.messageSenderType = MessageSenderTypeOther;
    model.messageType = MessageTypeImage;
    model.imageSmall = [UIImage imageNamed:@"ll"];
    model.messageTime = @"16:40";
    [model bg_save];
    
    model = [[CSMessageModel alloc] init];
    model.showMessageTime=YES;
    model.messageSenderType = MessageSenderTypeMe;
    model.messageType = MessageTypeImage;
    model.imageSmall = [UIImage imageNamed:@"ss"];
    model.messageTime = @"16:40";
    [model bg_save];
    
    model = [[CSMessageModel alloc] init];
    model.showMessageTime=YES;
    model.messageSenderType = MessageSenderTypeOther;
    model.messageType = MessageTypeImage;
    model.imageSmall = [UIImage imageNamed:@"m"];
    model.messageTime = @"16:40";
    [model bg_save];
}

-(void) getDBData
{
    [_tableView.mj_header endRefreshing];
    
    if (isGetData)
     {
        [MBProgressHUD showErrorWithStatus:@"没有更多聊天记录了" toView:self.view];
        return;
     }
    
    // 清除数据，开始读取历史数据
    [_dataArray removeAllObjects];
    
    bg_setDebug(YES);//打开调试模式,打印输出调试信息.
    
    /**
     当数据量巨大时采用分页范围查询.
     */
    NSInteger count = [CSMessageModel bg_count:bg_chat_tablename where:nil];
    
//    if (count == 0)
//     {
//        [self initDB];
//     }
    
    
    for(int i=1;i<=count;i+=50){
        NSArray* arr = [CSMessageModel bg_find:bg_chat_tablename range:NSMakeRange(i,50) orderBy:nil desc:NO];
        for(CSMessageModel* model in arr){
            //具体数据请断点查看
            //库新增两个自带字段createTime和updateTime方便开发者使用和做参考对比.
            NSLog(@"主键 = %@, 表名 = %@, 创建时间 = %@, 更新时间 = %@",model.bg_id,model.bg_tableName,model.bg_createTime,model.bg_updateTime);
            
            // 将数据中数据， 插入列表的_dataArray
            [_dataArray addObject:model];
        }
        
        
    }
    
    if (_dataArray.count > 0)
     {
        [_tableView reloadData];
        
        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView scrollToRowAtIndexPath:indexpath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        
        isGetData = TRUE;
     }
    
    
}


// 内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark --- 请求后台接口
-(void) queryHotQuestion
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    //params[@"msgType"] = @(1);
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBusiUrlString],kURLqueryqueryHotQuestion];
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
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if (operation.tag == 1000)
     {
        NSArray *arr = operation.jsonResult.rows;
        if (arr &&
            arr.count > 0)
         {
            for (int i = 0; i < arr.count ; i++)
             {
                NSDictionary *dicQ = arr[i];
                [arrQuestion addObject:dicQ[@"question"]];
                [arrAnswer addObject:dicQ[@"answer"]];
             }
            
            // 初始化职能客服
            [self initCustonSerivce];
         }
     }
    
}

-(void)handleErrorData:(DDGAFHTTPRequestOperation *)operation
{
    if (operation.tag == 1000)
     {
        
     }
}

// 视图被销毁
- (void)dealloc {
    NSLog(@"%s", __FUNCTION__);
    if (socketManager)
     {
        [socketManager stopConnectTimer];
     }
}

@end
