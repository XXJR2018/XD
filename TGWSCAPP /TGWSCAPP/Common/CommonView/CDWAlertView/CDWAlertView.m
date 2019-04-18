//
//  GoldAlertView.m
//  DDGAPP
//
//  Created by ddgbank on 15/11/18.
//  Copyright © 2015年 Cary. All rights reserved.
//

#import "CDWAlertView.h"
#import "CCWebViewController.h"

#define  BTN_WDITH      90
#define  BTN_HEIGHT     45

@implementation AlertButton

@end


@interface CDWAlertView ()

@property (nonatomic, strong) NSMutableArray *buttons;

@property (nonatomic, strong) UIViewController *rootViewController;

@property (nonatomic, strong) UIView *shadowView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) RCLabel *subTitleLabel;
//@property (nonatomic, assign) float subTitleLabelHeight;
@property (nonatomic, strong) UITapGestureRecognizer *gestureRecognizer;
@property (nonatomic, assign) BOOL  isAgreeSelect;



@end

@implementation CDWAlertView

CGFloat kWindowHeight;
CGFloat kWindowWidth;
NSString *kButtonFont = @"HelveticaNeue-Bold";

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        kWindowWidth = 270.0*ScaleSize;
        kWindowHeight = 20.0 * 2 * ScaleSize;
        _buttons = [[NSMutableArray alloc] init];
        
        // Shadow View
        _shadowView = [[UIView alloc] init];
        self.shadowView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        self.shadowView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.shadowView.backgroundColor = [UIColor blackColor];
        
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.layer.cornerRadius = 5.0;
        _contentView.layer.masksToBounds = YES;
        _contentView.layer.borderColor = UIColorFromRGB(0xCCCCCC).CGColor;
        [self.view addSubview:_contentView];
    }
    return self;
}

/** 增加当前Alert的高度
 *
 * TODO
 */
- (void) addAlertCurHeight:(CGFloat) fValue
{
    kWindowHeight += fValue;
}

/** 降低当前Alert的高度
 *
 * TODO
 */
- (void) subAlertCurHeight:(CGFloat) fValue
{
    kWindowHeight -= fValue;
}

#pragma mark - View Cycle

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    CGSize sz = [UIScreen mainScreen].bounds.size;
    
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
    if ([systemVersion floatValue] < 8.0)
    {
        // iOS versions before 7.0 did not switch the width and height on device roration
        if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]))
        {
            CGSize ssz = sz;
            sz = CGSizeMake(ssz.height, ssz.width);
        }
    }
    
    // Set background frame
    CGRect newFrame = self.shadowView.frame;
    newFrame.size = sz;
    self.shadowView.frame = newFrame;
    
    // Set frames
    CGRect r;
    if (self.view.superview != nil)
    {
        // View is showing, position at center of screen
        r = CGRectMake((sz.width-kWindowWidth)/2, (sz.height-kWindowHeight)/2, kWindowWidth, kWindowHeight);
    }
    else
    {
        // View is not visible, position outside screen bounds
        r = CGRectMake((sz.width-kWindowWidth)/2, -kWindowHeight, kWindowWidth, kWindowHeight);
    }
    
    self.view.frame = r;
    _contentView.frame = CGRectMake(0.f, 0.f, kWindowWidth, kWindowHeight);

    // Buttons
    CGFloat y =  kWindowHeight - BTN_HEIGHT; //CGRectGetMaxY(_subTitleLabel.frame) + 12.0;
    CGFloat x = kWindowWidth - 20.0*ScaleSize - 80.0;
    
    if (_buttons.count == 1)
     {
        AlertButton *btn  =  _buttons[0];
        x = 0;//(kWindowWidth - 80.0) /2;
        btn.frame = CGRectMake(x, y, kWindowWidth, BTN_HEIGHT);
        [btn setTitleColor:[ResourceManager redColor2] forState:UIControlStateNormal];
        if (btn.showRed) {
            [btn setTitleColor:[ResourceManager redColor1] forState:UIControlStateNormal];
        }
        // 当按钮为可变颜色风格时，  设置按钮的颜色
        if (btn.showMyColor)
         {
            [btn setTitleColor:btn.myColor forState:UIControlStateNormal];
         }
     }
    else if (_buttons.count == 2)
     {
        
        CGFloat  intervalBtn = kWindowWidth/2;//(kWindowWidth - 2 *BTN_WDITH)/3   ;
        x = 0;// kWindowWidth - (intervalBtn + BTN_WDITH) ;
        
        for (AlertButton *btn in _buttons)
         {
            btn.frame = CGRectMake(x, y, kWindowWidth/2, BTN_HEIGHT);
            [btn setTitleColor:[ResourceManager redColor2] forState:UIControlStateNormal];
            if (btn.showRed) {
                [btn setTitleColor:[ResourceManager redColor1] forState:UIControlStateNormal];
            }
            // 当按钮为可变颜色风格时，  设置按钮的颜色
            if (btn.showMyColor)
             {
                [btn setTitleColor:btn.myColor forState:UIControlStateNormal];
             }
            x = intervalBtn;
         }
     }
    else
     {
        x = 0;
        int iBtnWdith = kWindowWidth/ _buttons.count;
        for (AlertButton *btn in _buttons)
         {
            

            
            btn.frame = CGRectMake(x, y, iBtnWdith, BTN_HEIGHT);
            [btn setTitleColor:[ResourceManager redColor2] forState:UIControlStateNormal];
            if (btn.showRed) {
                [btn setTitleColor:[ResourceManager redColor1] forState:UIControlStateNormal];
            }
            // 当按钮为可变颜色风格时，  设置按钮的颜色
            if (btn.showMyColor)
             {
                [btn setTitleColor:btn.myColor forState:UIControlStateNormal];
             }
            x += iBtnWdith ;
         }
     }

    
    UIView *viewFG = [[UIView alloc] initWithFrame:CGRectMake(0, y, kWindowWidth, 1)];
    [self.contentView addSubview:viewFG];
    viewFG.backgroundColor = [ResourceManager color_5];
}

//
//-(void)viewWillLayoutSubviews
//{
//    [super viewWillLayoutSubviews];
//
//    CGSize sz = [UIScreen mainScreen].bounds.size;
//
//    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
//    if ([systemVersion floatValue] < 8.0)
//     {
//        // iOS versions before 7.0 did not switch the width and height on device roration
//        if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]))
//         {
//            CGSize ssz = sz;
//            sz = CGSizeMake(ssz.height, ssz.width);
//         }
//     }
//
//    // Set background frame
//    CGRect newFrame = self.shadowView.frame;
//    newFrame.size = sz;
//    self.shadowView.frame = newFrame;
//
//    // Set frames
//    CGRect r;
//    if (self.view.superview != nil)
//     {
//        // View is showing, position at center of screen
//        r = CGRectMake((sz.width-kWindowWidth)/2, (sz.height-kWindowHeight)/2, kWindowWidth, kWindowHeight);
//     }
//    else
//     {
//        // View is not visible, position outside screen bounds
//        r = CGRectMake((sz.width-kWindowWidth)/2, -kWindowHeight, kWindowWidth, kWindowHeight);
//     }
//
//    self.view.frame = r;
//    _contentView.frame = CGRectMake(0.f, 0.f, kWindowWidth, kWindowHeight);
//
//    // Buttons
//    CGFloat y =  kWindowHeight - BTN_HEIGHT - 20; //CGRectGetMaxY(_subTitleLabel.frame) + 12.0;
//    CGFloat x = kWindowWidth - 20.0*ScaleSize - 80.0;
//
//    if (self.isBtnCenter &&
//        _buttons.count == 1)
//     {
//        AlertButton *btn  =  _buttons[0];
//        x = (kWindowWidth - 80.0) /2;
//        btn.frame = CGRectMake(x, y, BTN_WDITH, BTN_HEIGHT);
//        btn.layer.cornerRadius = 5;
//        btn.backgroundColor = [ResourceManager redColor2];
//        if (btn.showRed) {
//            [btn setImage:[UIImage imageNamed:@"redDot"] forState:UIControlStateNormal];
//            [btn setImageEdgeInsets:UIEdgeInsetsMake(10, 50, 10, 60)];
//        }
//        // 当按钮为可变颜色风格时，  设置按钮的颜色
//        if (btn.showMyColor)
//         {
//            btn.backgroundColor = btn.myColor;
//         }
//     }
//    else if (_buttons.count == 2)
//     {
//
//        CGFloat  intervalBtn = (kWindowWidth - 2 *BTN_WDITH)/3   ;
//        x =  kWindowWidth - (intervalBtn + BTN_WDITH) ;
//
//        for (AlertButton *btn in _buttons)
//         {
//            btn.frame = CGRectMake(x, y, BTN_WDITH, BTN_HEIGHT);
//            btn.layer.cornerRadius = 5;
//            btn.backgroundColor = [ResourceManager redColor2];
//            if (btn.showRed) {
//                [btn setImage:[UIImage imageNamed:@"redDot"] forState:UIControlStateNormal];
//                [btn setImageEdgeInsets:UIEdgeInsetsMake(10, 50, 10, 60)];
//            }
//            // 当按钮为可变颜色风格时，  设置按钮的颜色
//            if (btn.showMyColor)
//             {
//                btn.backgroundColor = btn.myColor;
//             }
//            //        y += 33.0;
//            x = intervalBtn;
//         }
//     }
//    else
//     {
//        for (AlertButton *btn in _buttons)
//         {
//            btn.frame = CGRectMake(x, y, BTN_WDITH, BTN_HEIGHT);
//            btn.layer.cornerRadius = 5;
//            btn.backgroundColor = [ResourceManager redColor2];
//            if (btn.showRed) {
//                [btn setImage:[UIImage imageNamed:@"redDot"] forState:UIControlStateNormal];
//                [btn setImageEdgeInsets:UIEdgeInsetsMake(10, 50, 10, 60)];
//            }
//            // 当按钮为可变颜色风格时，  设置按钮的颜色
//            if (btn.showMyColor)
//             {
//                btn.backgroundColor = btn.myColor;
//             }
//            //        y += 33.0;
//            x -= (BTN_WDITH + 10) ;
//         }
//     }
//
//}

    
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - Handle gesture

- (void)handleTap:(UITapGestureRecognizer *)gesture
{
    if (_shouldDismissOnTapOutside)
    {
        [self hideView];
    }
}

- (void)setShouldDismissOnTapOutside:(BOOL)shouldDismissOnTapOutside
{
    _shouldDismissOnTapOutside = shouldDismissOnTapOutside;
    
    if(_shouldDismissOnTapOutside)
    {
        self.gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [self.shadowView addGestureRecognizer:_gestureRecognizer];
    }
}

/** Show DDGAlertView
 *
 * TODO
 */
- (void)showAlertView:(UIViewController *)vc duration:(NSTimeInterval)duration{
    self.view.alpha = 0;
    self.rootViewController = vc;
    
    // Add subviews
    [self.rootViewController addChildViewController:self];
    self.shadowView.frame = vc.view.bounds;
    [self.rootViewController.view addSubview:self.shadowView];
    [self.rootViewController.view addSubview:self.view];

    // Animate in the alert view
    [UIView animateWithDuration:0.2f animations:^{
        self.shadowView.alpha = 0.5f;
        
        //New Frame
        CGRect frame = self.view.frame;
        frame.origin.y = self.rootViewController.view.center.y - 100.0f;
        self.view.frame = frame;
        
        self.view.alpha = 1.0f;
    } completion:^(BOOL completed) {
        [UIView animateWithDuration:0.2f animations:^{
            self.view.center = self.rootViewController.view.center;
        }];
    }];
}

-(void)addTitle:(NSString *)title{
    float width = kWindowWidth - 20.0 * 2 * ScaleSize ;
    
    // 返回文本绘制所占据的矩形空间
    // context上下文。包括一些信息，例如如何调整字间距以及缩放。最终，该对象包含的信息将用于文本绘制。该参数可为 nil
    NSDictionary *attributesDic = @{NSFontAttributeName:[UIFont systemFontOfSize:13.f]};
    CGSize size = [title boundingRectWithSize:CGSizeMake(width, 60) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:nil context:nil].size;
//    CGSize size = [title sizeWithFont:[UIFont systemFontOfSize:13.f] constrainedToSize:CGSizeMake(width, 60)];
    kWindowHeight = size.height + 25.f;
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 15.f, width, size.height)];
    _titleLabel.text = title;
    _titleLabel.numberOfLines = 0;
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.textColor = [ResourceManager CellSubTitleColor];
    _titleLabel.font = attributesDic[NSFontAttributeName];
    [_contentView addSubview:_titleLabel];
}


-(void)addSubTitle:(NSString *)subTitle{
    float width = kWindowWidth - 16.0 * 2 * ScaleSize;
    
    _subTitleLabel = [[RCLabel alloc] initWithFrame:CGRectMake(16.0, kWindowHeight, width, 50)];
    _subTitleLabel.componentsAndPlainText = [RCLabel extractTextStyle:subTitle];
    CGSize optimalSize = [_subTitleLabel optimumSize];
    _subTitleLabel.frame = CGRectMake(16.0, kWindowHeight, width, optimalSize.height);
    
    if (_textAlignment)
     {
        _subTitleLabel.textAlignment = _textAlignment;
     }
    
    kWindowHeight += optimalSize.height + 8.0;
    
    [_contentView addSubview:_subTitleLabel];
    
}

/** Add View
 *
 *   leftX 为0 的话，  表示居中显示
 */
- (void ) addView:(UIView*) view  leftX:(int) leftX
{
    if (view)
     {
        view.top =   kWindowHeight;
        if (leftX > 0)
         {
            view.left = leftX;
         }
        else
         {
            view.left = (kWindowWidth - view.width)/2;
         }
        
        [_contentView addSubview:view];
        
        
        kWindowHeight += view.height;
        
        
        
     }
}




#pragma mark - Buttons

- (AlertButton *)addButton:(NSString *)title red:(BOOL)showRed
{
    // Update view height
    if (_buttons.count == 0) {
        kWindowHeight += BTN_HEIGHT + 30;
    }
    
    // Add button
    AlertButton *btn = [[AlertButton alloc] init];
    btn.layer.masksToBounds = YES;
    [btn setTitle:title forState:UIControlStateNormal];
    //btn.titleLabel.font = [UIFont fontWithName:kButtonFont size:16.0f];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    btn.showRed = showRed;


    [_contentView addSubview:btn];
    [_buttons addObject:btn];
    
    return btn;
}

- (AlertButton *)addButton:(NSString *)title red:(BOOL)showRed actionBlock:(ActionBlock)action
{
    AlertButton *btn = [self addButton:title red:showRed];
    btn.actionType = Block;
    btn.actionBlock = action;
    [btn addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

- (AlertButton *)addButton:(NSString *)title color:(UIColor*)color actionBlock:(ActionBlock)action
{
    AlertButton *btn = [self addButton:title red:NO];
    btn.showMyColor = YES;   // 设置显示自己颜色风格
    btn.myColor = color;    // 设置为当前颜色
    btn.actionType = Block;
    btn.actionBlock = action;
    [btn addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

/** Add Button
 *
 * TODO
 */
- (AlertButton *)addCanelButton:(NSString *)title  actionBlock:(ActionBlock)action
{
    AlertButton *btn = [self addButton:title red:NO];
    btn.showMyColor = YES;   // 设置显示自己颜色风格
    btn.myColor = [ResourceManager color_1];    // 设置为当前颜色
    btn.actionType = Block;
    btn.actionBlock = action;
    
    //btn.titleLabel.textColor = [ResourceManager lightGrayColor];
    
    [btn setTitleColor:[ResourceManager lightGrayColor] forState:UIControlStateNormal];
    btn.borderWidth = 1;
    btn.borderColor = [ResourceManager color_5];
    
    [btn addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}




- (AlertButton *)addButton:(NSString *)title red:(BOOL)showRed target:(id)target selector:(SEL)selector
{
    AlertButton *btn = [self addButton:title red:showRed];
    btn.actionType = Selector;
    btn.target = target;
    btn.selector = selector;
    [btn addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

- (void)buttonTapped:(AlertButton *)btn
{
    if (btn.actionType == Block)
    {
        if (btn.actionBlock)
            btn.actionBlock();
    }
    else if (btn.actionType == Selector)
    {
        UIControl *ctrl = [[UIControl alloc] init];
        [ctrl sendAction:btn.selector to:btn.target forEvent:nil];
    }
    else
    {
        NSLog(@"Unknown action type for button");
    }
    [self hideView];
}

#pragma mark - Hide Alert

// Close SCLAlertView
- (void)hideView
{
    [UIView animateWithDuration:0.2f animations:^{
        self.shadowView.alpha = 0;
        self.view.alpha = 0;
    } completion:^(BOOL completed) {
        [self.shadowView removeFromSuperview];
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }];
}


@end
