//
//  EvaluateView.m
//  TGWSCAPP
//
//  Created by xxjr02 on 2019/2/19.
//  Copyright © 2019 xxjr03. All rights reserved.
//

#import "EvaluateView.h"

@implementation EvaluateView
{
    UITextField *filedYY;
    
    NSMutableArray *arrAnserBtn;
    NSMutableArray *arrPJBtn;

    int iAnserNo;  // 是否已经解决   -1 表示未选择， 1  表示已经解决， 2 表示 未解决
    int iPJNo;     // 评价的星级，  -1 表示未选择， 1到5表示 星级
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    arrAnserBtn = [[NSMutableArray alloc] init];
    arrPJBtn = [[NSMutableArray alloc] init];
    iAnserNo = -1;
    iPJNo = -1;
    
    //添加手势点击空白处隐藏键盘
    UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TouchViewKeyBoard)];
    gesture.numberOfTapsRequired  = 1;
    [self addGestureRecognizer:gesture];
    
    int iPopWidth = 300;
    int iPopHeight = 500;
    UIView *viewPop = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-iPopWidth)/2, NavHeight+20, iPopWidth, iPopHeight)];
    [self addSubview:viewPop];
    viewPop.backgroundColor = [UIColor whiteColor];
    viewPop.layer.masksToBounds = YES;
    viewPop.layer.cornerRadius = 10;
    
    
    int iLeftX = (iPopWidth - 30);
    int iTopY = 10;
    UIButton * btnBack = [[UIButton alloc] initWithFrame:CGRectMake(iLeftX, 0, 30, 30)];
    [viewPop addSubview:btnBack];
    //btnBack.backgroundColor = [UIColor yellowColor];
    [btnBack setImage:[UIImage imageNamed:@"com_colse"] forState:UIControlStateNormal];
    [btnBack addTarget:self action:@selector(actionCancel) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *lableTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, iTopY, iPopWidth, 30)];
    [viewPop addSubview:lableTitle];
    lableTitle.font = [UIFont systemFontOfSize:14];
    lableTitle.textColor = [ResourceManager color_1];
    lableTitle.textAlignment = NSTextAlignmentCenter;
    lableTitle.text = @"满意度调查";
    
    iTopY += lableTitle.height + 10;
    UIView *viewFG1 = [[UIView alloc] initWithFrame:CGRectMake(0, iTopY, iPopWidth, 1)];
    [viewPop addSubview:viewFG1];
    viewFG1.backgroundColor = [ResourceManager color_5];
    
    // 第一个输入项目
    iLeftX = 10;
    iTopY += viewFG1.height + 10;
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, iPopWidth-iLeftX -10, 20)];
    [viewPop addSubview:label1];
    label1.font = [UIFont systemFontOfSize:14];
    label1.textColor = [ResourceManager color_1];
    label1.text = @"1.本次服务是否解决了您的问题";
    
    iTopY += label1.height + 5;
    UIButton *btnAnswer1 = [[UIButton alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 100, 30)];
    [viewPop addSubview:btnAnswer1];
    [btnAnswer1 setImage:[UIImage imageNamed:@"chat_deal_unsel"] forState:UIControlStateNormal];
    [btnAnswer1 setTitle:@"   已解决" forState:UIControlStateNormal];
    [btnAnswer1 setTitleColor:[ResourceManager midGrayColor] forState:UIControlStateNormal];
    btnAnswer1.titleLabel.font = [UIFont systemFontOfSize:14];
    btnAnswer1.tag = 1;
    [arrAnserBtn addObject:btnAnswer1];
    [btnAnswer1 addTarget:self action:@selector(actionAnser:) forControlEvents:UIControlEventTouchUpInside];
    

    UIButton *btnAnswer2 = [[UIButton alloc] initWithFrame:CGRectMake(iLeftX+105, iTopY, 100, 30)];
    [viewPop addSubview:btnAnswer2];
    [btnAnswer2 setImage:[UIImage imageNamed:@"chat_deal_unsel"] forState:UIControlStateNormal];
    [btnAnswer2 setTitle:@"   未解决" forState:UIControlStateNormal];
    [btnAnswer2 setTitleColor:[ResourceManager midGrayColor] forState:UIControlStateNormal];
    btnAnswer2.titleLabel.font = [UIFont systemFontOfSize:14];
    btnAnswer2.tag = 2;
    [arrAnserBtn addObject:btnAnswer2];
    [btnAnswer2 addTarget:self action:@selector(actionAnser:) forControlEvents:UIControlEventTouchUpInside];
    
    
    // 第二个输入项目
    iTopY += btnAnswer1.height + 5;
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, iPopWidth-iLeftX -10, 20)];
    [viewPop addSubview:label2];
    label2.font = [UIFont systemFontOfSize:14];
    label2.textColor = [ResourceManager color_1];
    label2.text = @"2.请您针对此次服务打分";
    
    iTopY += label2.height + 5;
    iLeftX = 20;
    for (int i = 1; i < 6; i++)
     {
        UIButton *btnPJ1 = [[UIButton alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 30, 30)];
        [viewPop addSubview:btnPJ1];
        btnPJ1.tag = i;
        [btnPJ1 setImage:[UIImage imageNamed:@"chat_pj_unsel"] forState:UIControlStateNormal];
        [arrPJBtn addObject:btnPJ1];
        [btnPJ1 addTarget:self action:@selector(actionPJ:) forControlEvents:UIControlEventTouchUpInside];
        
        if (1 == i)
         {
            UILabel *labelTemp = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY+28, 40, 12)];
            [viewPop addSubview:labelTemp];
            labelTemp.font = [UIFont systemFontOfSize:9];
            labelTemp.textColor = [ResourceManager midGrayColor];
            labelTemp.text = @"不满意";
         }
        
        if (5 == i)
         {
            UILabel *labelTemp = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY+28, 30, 12)];
            [viewPop addSubview:labelTemp];
            labelTemp.font = [UIFont systemFontOfSize:9];
            labelTemp.textColor = [ResourceManager midGrayColor];
            labelTemp.textAlignment = NSTextAlignmentCenter;
            labelTemp.text = @"满意";
         }
        
        iLeftX += btnPJ1.width + 5;
     }
    
    // 第三个输入项目
    iTopY +=  30 +  18 + 5;
    iLeftX = 10;
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, iPopWidth-iLeftX -10, 20)];
    [viewPop addSubview:label3];
    label3.font = [UIFont systemFontOfSize:14];
    label3.textColor = [ResourceManager color_1];
    label3.text = @"3.您给予这个评分的原因?";
    
    iTopY +=  label3.height + 10;
    iLeftX = 20;
    filedYY = [[UITextField alloc] initWithFrame:CGRectMake(iLeftX, iTopY, iPopWidth-2*iLeftX, 30)];
    [viewPop addSubview:filedYY];
    filedYY.layer.borderColor = [ResourceManager lightGrayColor].CGColor;
    filedYY.layer.borderWidth = 0.3;
    filedYY.placeholder = @"  因为...";
    filedYY.font = [UIFont systemFontOfSize:14];
   

    // 底部按钮
    iTopY +=  filedYY.height + 30;
    UIButton *btnCommit = [[UIButton alloc] initWithFrame:CGRectMake(iLeftX, iTopY, iPopWidth - 2*iLeftX , 35)];
    [viewPop addSubview:btnCommit];
    btnCommit.backgroundColor = [ResourceManager mainColor];
    btnCommit.cornerRadius = btnCommit.height/2;
    [btnCommit setTitle:@"提交" forState:UIControlStateNormal];
    btnCommit.titleLabel.font = [UIFont systemFontOfSize:14];
    [btnCommit addTarget:self action:@selector(actionCommit) forControlEvents:UIControlEventTouchUpInside];
    
    
    viewPop.height = iTopY + btnCommit.height +30;
    
}


#pragma mark --- action
-(void) actionCancel
{
    [self endEditing:YES];
    self.hidden = YES;
}

-(void) TouchViewKeyBoard
{
    [self endEditing:YES];
}

-(void) actionCommit
{
    [self endEditing:YES];
    
    if (-1 == iAnserNo)
     {
        [MBProgressHUD showErrorWithStatus:@"请选择是否解决问题" toView:self];
        return;
     }
    
    if (-1 == iPJNo)
     {
        [MBProgressHUD showErrorWithStatus:@"请您打分" toView:self];
        return;
     }
    
    
    if (_bolck_comit)
     {
        if(iAnserNo == 2)
         {
            iAnserNo = 0;
         }
        
//        客户对服务进行评价{"reqType":"10","body"::{"solvestatus":"0","pfScore":"5","pfReason":"因为xxxx"}}     （solvestatus：是否解决问题（0未解决，1已解决））
        
        NSMutableDictionary *dicSend = [[NSMutableDictionary alloc] init];
        NSMutableDictionary *dicBody = [[NSMutableDictionary alloc] init];
        dicBody[@"solvestatus"] = @(iAnserNo);
        dicBody[@"pfScore"] = @(iPJNo);
        dicBody[@"pfReason"] = filedYY.text;
        
        dicSend[@"reqType"] = @(10);
        dicSend[@"body"] = dicBody;
    
        _bolck_comit(dicSend);
     }
    
    //self.hidden = YES;
}

-(void) actionAnser:(UIButton*) sender
{
    for (int i = 0;  i < arrAnserBtn.count ; i++)
     {
        UIButton *btnTemp = (UIButton*)arrAnserBtn[i];
        [btnTemp setImage:[UIImage imageNamed:@"chat_deal_unsel"] forState:UIControlStateNormal];
     }
    
    iAnserNo = (int)sender.tag;
    [sender setImage:[UIImage imageNamed:@"chat_deal_sel"] forState:UIControlStateNormal];
}

-(void) actionPJ:(UIButton*) sender
{
    for (int i = 0;  i < arrPJBtn.count ; i++)
     {
        UIButton *btnTemp = (UIButton*)arrPJBtn[i];
        [btnTemp setImage:[UIImage imageNamed:@"chat_pj_unsel"] forState:UIControlStateNormal];
     }
    
    iPJNo = (int)sender.tag;
    for (int i = 0; i < iPJNo; i++)
     {
        UIButton *btnTemp = (UIButton*)arrPJBtn[i];
        [btnTemp setImage:[UIImage imageNamed:@"chat_pj_sel"] forState:UIControlStateNormal];
        //[sender setImage:[UIImage imageNamed:@"chat_pj_sel"] forState:UIControlStateNormal];
     }
}

@end
