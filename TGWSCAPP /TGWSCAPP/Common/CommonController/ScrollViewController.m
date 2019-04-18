//
//  ScrollViewController.m
//  DDGAPP
//
//  Created by ddgbank on 15/11/11.
//  Copyright © 2015年 Cary. All rights reserved.
//

#import "ScrollViewController.h"

@interface ScrollViewController ()
{
    int _menu_Button_Width;
    UIView *_colorBarView;
    
    UIButton *_selectBtn;
}

@end

@implementation ScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self layoutScrollView];
}

-(void)layoutScrollView{
    _menu_Button_Width = menu_button_width((int)self.titleArray.count);
    [self layoutScrollView:NavHeight];
}

static int menu_button_width(int count){
    switch (count) {
        case 1:
            return SCREEN_WIDTH;
            break;
        case 2:
            return SCREEN_WIDTH/2;
            break;
        case 3:
            return 107;
            break;
        case 4:
            return SCREEN_WIDTH/4;
            break;
        case 5:
            return SCREEN_WIDTH/5;
            break;
        default:
            return 60;
            break;
    }
}

#pragma mark === initData
 //是否要减去TabbarHeight高度，负责会挡住tabbar
- (CGFloat)scrollViewViewHeight
{
    return SCREEN_HEIGHT - CGRectGetMaxY(_navScrollView.frame);
}

#pragma mark - 初始化segment
-(void)layoutScrollView:(float)y
{
    if (!self.titleArray || [self.titleArray count] <= 0)
        return;
    
    _navScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, y, self.view.frame.size.width, MENU_HEIGHT)];
    [_navScrollView setShowsHorizontalScrollIndicator:NO];
    
    for (int i = 0; i < [self.titleArray count]; i++){
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(_menu_Button_Width * i, 0, _menu_Button_Width, MENU_HEIGHT - 3.0)];
        [btn setTitle:[self.titleArray objectAtIndex:i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.tag = i + 1;
        if(i==0)
        {
            [self changeColorForButton:btn red:1];
            btn.titleLabel.font = [UIFont systemFontOfSize:MAX_MENU_FONT];
        }else
        {
            btn.titleLabel.font = [UIFont systemFontOfSize:MAX_MENU_FONT];
            [self changeColorForButton:btn red:0.0];
        }
        [btn addTarget:self action:@selector(actionbtn:) forControlEvents:UIControlEventTouchUpInside];
        [_navScrollView addSubview:btn];
        
        // 小竖线
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(_menu_Button_Width * i- 0.5, 5, 0.4, MENU_HEIGHT - 10.0)];
        line.backgroundColor = [ResourceManager color_5];
        [_navScrollView addSubview:line];
    }
    
    // _colorBarView
//    _colorBarView = [[UIView alloc] initWithFrame:CGRectMake(30.0/2.0, _navScrollView.height - 3, (_menu_Button_Width - 30.0), 2.5)];
//    _colorBarView.backgroundColor = [ResourceManager redColor2];
//    [_navScrollView addSubview:_colorBarView];
    // line
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, _navScrollView.height - 0.5, _navScrollView.width, 0.4)];
    line.backgroundColor = [ResourceManager color_5];
    [_navScrollView addSubview:line];
    
    [_navScrollView setContentSize:CGSizeMake(_menu_Button_Width * [self.titleArray count], MENU_HEIGHT)];
    _navScrollView.backgroundColor = [ResourceManager color_3];
    [self.view addSubview:_navScrollView];
    
    _contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_navScrollView.frame), SCREEN_WIDTH, [self scrollViewViewHeight])];
    _contentScrollView.backgroundColor = [ResourceManager color_2];
    [_contentScrollView setPagingEnabled:YES];
    [_contentScrollView setShowsHorizontalScrollIndicator:NO];
    _contentScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * self.titleArray.count, 0);
    _contentScrollView.delegate = self;
    [self.view insertSubview:_contentScrollView belowSubview:_navScrollView];
    
}

/*
 *  子类必须实现
 */
-(void)layoutContentViews{

}

#pragma mark === RefreshTableViewDataSource
-(CGFloat)heightForRowAthIndexPath:(UITableView *)aTableView IndexPath:(NSIndexPath *)aIndexPath FromView:(RefreshTableView *)aView{
    return 44.f;
}

-(UITableViewCell *)cellForRowInTableView:(UITableView *)aTableView IndexPath:(NSIndexPath *)aIndexPath FromView:(RefreshTableView *)aView{
    return nil;
}

#pragma mark ===  UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self changeView:scrollView.contentOffset.x];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    float xx = scrollView.contentOffset.x * (_menu_Button_Width / self.view.frame.size.width) - _menu_Button_Width;
    [_navScrollView scrollRectToVisible:CGRectMake(xx, 0, _navScrollView.frame.size.width, _navScrollView.frame.size.height) animated:YES];
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    for (UIView *view in _navScrollView.subviews) {
        if ([view isKindOfClass:[UIButton class]] && (UIButton *)view != _selectBtn) {
            [self changeColorForButton:(UIButton *)view red:0];
        }
    }
}

#pragma mark - action
- (void)actionbtn:(UIButton *)btn
{
    _selectBtn = btn;
    [_contentScrollView setContentOffset:CGPointMake(_contentScrollView.frame.size.width * (btn.tag - 1),0) animated:YES];
    
    float xx = _contentScrollView.frame.size.width * (btn.tag - 1) * (_menu_Button_Width / self.view.frame.size.width) - _menu_Button_Width;
    [_navScrollView scrollRectToVisible:CGRectMake(xx, _navScrollView.frame.origin.y, _navScrollView.frame.size.width, _navScrollView.frame.size.height) animated:YES];
}

- (void)changeColorForButton:(UIButton *)btn red:(float)nBluePercent
{
    float rValue = nBluePercent * 245 + (1 - nBluePercent) * 154; // nBluePercent * 59;
    float gValue = nBluePercent * 84 + (1 - nBluePercent) * 154; // nBluePercent * 151;
    float bValue = nBluePercent * 29 + (1 - nBluePercent) * 154; // nBluePercent * 255;
    [btn setTitleColor:[UIColor colorWithRed:rValue/255.f green:gValue/255.f blue:bValue/255.f alpha:1.0] forState:UIControlStateNormal];
}

- (void)changeView:(float)x
{
    float xx = x * (_menu_Button_Width / self.view.frame.size.width);
    
    // 颜色滑块
//    CGRect rect = _colorBarView.frame;
//    rect.origin.x = xx + 30.0/2;
//    _colorBarView.frame = rect;
    
    float startX = xx;
    int page = (x)/_contentScrollView.frame.size.width + 1;
    
    if (page <= 0)
    {
        return;
    }
    UIButton *btn = (UIButton *)[_navScrollView viewWithTag:page];
    float percent = (startX - _menu_Button_Width * (page - 1))/_menu_Button_Width;
//    float value = MIN_MENU_FONT + (1 - percent) * (MAX_MENU_FONT - MIN_MENU_FONT);
//    btn.titleLabel.font = [UIFont systemFontOfSize:value];
    [self changeColorForButton:btn red:(1 - percent)];
    
    if((int)xx%_menu_Button_Width == 0)
        return;
    UIButton *btn2 = (UIButton *)[_navScrollView viewWithTag:page + 1];
//    float value2 = MIN_MENU_FONT + percent * (MAX_MENU_FONT - MIN_MENU_FONT);
//    btn2.titleLabel.font = [UIFont systemFontOfSize:value2];
    [self changeColorForButton:btn2 red:percent];
}


@end
