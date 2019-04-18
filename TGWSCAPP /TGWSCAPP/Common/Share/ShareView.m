//
//  ShareView.m
//  DDGAPP
//
//  Created by ddgbank on 15/8/8.
//  Copyright (c) 2015年 Cary. All rights reserved.
//

#import "ShareView.h"

#define Icon_Size  85.f
#define ShareView_Size 320.f/4

@interface ShareIcon : CSAnimationView

/**
 *  图标按钮
 */
@property(nonatomic,strong) UIButton *button;

/**
 *  文本
 */
@property(nonatomic,strong) UILabel *label;

/**
 *  回调
 */
@property (nonatomic,copy) Block_Tap block;


/**
 *  根据类型初始化
 *
 *  @param type 类型
 *
 *  @return
 */
-(id)initWithType:(NSArray *)types index:(int)index block:(Block_Tap)block;

@end

@implementation ShareIcon

-(UIButton *)button{
    if (!_button) {
        CGFloat width = 50.f;
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.frame = CGRectMake((ShareView_Size - width)/2, 0.f, width, width);
        [_button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        _button.titleLabel.font = [UIFont systemFontOfSize:16.f];
        _button.layer.cornerRadius = 25.f;
        [_button setBackgroundColor:[UIColor whiteColor]];
        
//        UIEdgeInsets insets; // 设置按钮内部图片间距
//        insets.top = insets.bottom = insets.right = insets.left = 10.5f;
//        _button.contentEdgeInsets = insets;
    }
    return _button;
}

-(UILabel *)label{
    if (!_label) {
        CGFloat width = 75.f;
        _label = [[UILabel alloc] initWithFrame:CGRectMake((ShareView_Size - width)/2, ShareView_Size - 20.f, width, 9.f)];
        _label.font = [ResourceManager font_10];
        _label.textColor = [ResourceManager color_7];
        _label.textAlignment = NSTextAlignmentCenter;
    }
    return _label;
}

-(id)initWithType:(NSArray *)types index:(int)index block:(Block_Tap)block{
    if (self = [super initWithFrame:CGRectMake((ShareView_Size - (index == 0 ? 0 : 10)) * index, 0.f, ShareView_Size + 10, ShareView_Size)]) {
        
        _block = block;
        //        self.backgroundColor = RandomColor;
        if ([types[index] isEqualToString:DDGShareTypeWeChat_pengyouquan]) {
            self.label.text = @"分享到朋友圈";
        }else if ([types[index] isEqualToString:DDGShareTypeWeChat_haoyou]){
            self.label.text = @"分享给微信好友";
        }else if ([types[index] isEqualToString:DDGShareTypeQQ]){
            self.label.text = @"分享到QQ好友";
        }else if ([types[index] isEqualToString:DDGShareTypeQQqzone]){
            self.label.text = @"分享到QQ空间";
        }else if ([types[index] isEqualToString:DDGShareTypeCopyUrl]){
            self.label.text = @"复制链接";
        }
        
        [self.button setImage:[UIImage imageNamed:[types objectAtIndex:index]] forState:UIControlStateNormal];
        self.button.tag = 1000 + index;
        
        [self addSubview:self.button];
        [self addSubview:self.label];
    }
    
    return self;
}

#pragma mark ===
-(void)click:(UIButton *)button{
    if (_block) {
        _block((int)button.tag - 1000);
    }
}

@end


#import "AppDelegate.h"

@implementation ShareView
{
    CGFloat _viewHeight;
    UIView *_backGroundView;   // 全尺寸的黑色半透明背景
    CSAnimationView *_shareView;        // 选项区
}

+(void)showIn:(UIViewController *)viewController types:(NSArray *)types block:(Block_Tap)block{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    ShareView *view = [[ShareView alloc] initWithTypes:types frame:appDelegate.window.frame];
    view.block = block;
    
    //    [view showAnimation:YES inView:viewController.view];
    [view showAnimation:YES inView:appDelegate.window];
}

- (instancetype)initWithTypes:(NSArray *)types frame:(CGRect)rect
{
    self = [super initWithFrame:rect];
    if (self) {
        _viewHeight = 175.f; // 20.f + ShareView_Size + CellHeight36 + 25.f;
        _backGroundView = [[UIView alloc] initWithFrame:rect];
        _backGroundView.backgroundColor = [UIColor blackColor];
        [self addSubview:_backGroundView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancel)];
        [_backGroundView addGestureRecognizer:tap];
        
        _shareView = [[CSAnimationView alloc] initWithFrame:CGRectMake(0, rect.size.height, rect.size.width, _viewHeight)];
        UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:[_shareView bounds]];
        [_shareView.layer insertSublayer:[toolBar layer] atIndex:0];
        [self addSubview:_shareView];

        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 18.f, SCREEN_WIDTH - 20, 12.f)];
        label.font = [ResourceManager font_8];
        label.textColor = [ResourceManager CellSubTitleColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"分享";
        [_shareView addSubview:label];
        
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(label.frame) + 22.f, SCREEN_WIDTH, ShareView_Size)];
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.contentSize = CGSizeMake((ShareView_Size - 10)* types.count, 0);
        [_shareView addSubview:scrollView];
        
        CSAnimationView *animationView = [[CSAnimationView alloc] initWithFrame:CGRectMake(0, 0, ShareView_Size * types.count, ShareView_Size)];
        [scrollView addSubview:animationView];
        
        for (int i = 0; i < types.count; i ++) {
            ShareIcon *icon = [[ShareIcon alloc] initWithType:types index:i block:^(int index){
                [self share:index];
            }];
            icon.delay = 0.1 + 0.06 * i;
            icon.duration = 0.2;
            icon.type = CSAnimationTypeBounceUp;
            [animationView addSubview:icon];
        }
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, _viewHeight - 40, _shareView.width, 40);
        button.backgroundColor = [UIColor whiteColor];
        [button setTitle:@"取消" forState:UIControlStateNormal];
        [button setTitleColor:[ResourceManager color_6] forState:UIControlStateNormal];
        [button setTitleColor:[ResourceManager CellTitleColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
        [_shareView addSubview:button];
        
        [_shareView startCanvasAnimation];
    }
    return self;
}

-(void)share:(int)index{
    _block(index);
    [self removeAnimation:YES];
}

-(void)cancel{
    [self removeAnimation:YES];
}

/**
 *  动画显示
 *
 *  @param animation 是否动画
 */
-(void)showAnimation:(BOOL)animation inView:(UIView *)view{
    _backGroundView.alpha = 0.f;
    [view addSubview:self];
    [UIView animateWithDuration:0.2f animations:^{
        _backGroundView.alpha = 0.4f;
        _shareView.frame = CGRectMake(0, view.frame.size.height - _viewHeight, view.frame.size.width, _viewHeight);
    } completion:^(BOOL finished) {}];
}

/**
 *  动画移除
 *
 *  @param animation 是否动画
 */
-(void)removeAnimation:(BOOL)animation {
    [UIView animateWithDuration:0.3f animations:^{
        _shareView.transform = CGAffineTransformMakeTranslation(0, self.frame.size.height + self.frame.origin.y);
        _backGroundView.alpha = 0.f;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


@end
