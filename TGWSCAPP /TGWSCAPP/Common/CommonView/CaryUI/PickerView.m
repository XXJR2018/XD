//
//  PickerView.m
//  JYApp
//
//  Created by xxjr02 on 16/6/2.
//  Copyright © 2016年 xxjr02. All rights reserved.
//

#import "PickerView.h"

@implementation PickerView

-(void)setPlaceHolder:(NSString *)placeHolder{
    if (placeHolder) {
        _placeHolder = placeHolder;
        _holderLabel.textColor = [ResourceManager color_7];
        _holderLabel.text = placeHolder;
        
        //重新设置字体颜色
        if (_colorStyle) {
//            _colorStyle = NO;
            _holderLabel.textColor = UIColorFromRGB(0xF3754D);
        }
    }
}

-(void)setUnnecessary:(BOOL)unnecessary{
    if (unnecessary) {
        // 添加选填label
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CellSpaceReserved + _titleWidth + 10, (CellHeight44 - CellTitleFontSize)/2, 60.0, CellTitleFontSize)];
        label.font = [UIFont systemFontOfSize:14.0];
        label.text = @"(选填)";
        label.textColor = [ResourceManager color_6];
        label.textAlignment = NSTextAlignmentLeft;
        [self addSubview:label];
    }
}

-(void)setSelectedIndex:(int)selectedIndex{
    
    _selectedIndex = selectedIndex;
    _holderLabel.textColor = [ResourceManager color_7];
   
    // 防止数组越界，导致崩溃
    if (selectedIndex >= 0  &&
        selectedIndex < [_itemsArray count])
     {
        _holderLabel.text = _itemsArray[_selectedIndex];
        if (_finishedBlock) {
            _finishedBlock(_selectedIndex);
        }
     }
    
}

-(void)layoutTitleLabel:(NSString *)title{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, (CellHeight44 - CellTitleFontSize)/2, 170.0, CellTitleFontSize)];
    label.font = [UIFont systemFontOfSize:14.0];
    label.text = title;
    label.textColor = [ResourceManager color_1];
    label.textAlignment = NSTextAlignmentLeft;
    [self addSubview:label];
}

-(void)layoutTitleLabel_left:(NSString *)title{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, (CellHeight44 - CellTitleFontSize)/2, 170.0, CellTitleFontSize)];
    label.font = [UIFont systemFontOfSize:14.0];
    label.text = title;
    label.textColor = [ResourceManager color_1];
    label.textAlignment = NSTextAlignmentLeft;
    [self addSubview:label];
}

-(void)layoutTitleLabel:(NSString *)title imageName:(NSString*) imageName{
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CellSpaceReserved, (CellHeight44 - CellTitleFontSize)/2, 170.0, CellTitleFontSize)];
//    label.font = [UIFont systemFontOfSize:14.0];
//    label.text = title;
//    label.textColor = [ResourceManager color_1];
//    label.textAlignment = NSTextAlignmentLeft;
//    [self addSubview:label];
    
    UIImage *image = [UIImage imageNamed:imageName];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CellSpaceReserved, (CellHeight44 - image.size.height)/2, image.size.width, image.size.height)];
    imageView.image = image;
    imageView.contentMode = UIViewContentModeCenter;
    [self addSubview:imageView];
    
    UIFont *font = [UIFont systemFontOfSize:14.0];
    _titleWidth = [title sizeWithAttributes:@{NSFontAttributeName:font}].width;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CellSpaceReserved+image.size.width, (CellHeight44 - CellTitleFontSize)/2, 140.0, CellTitleFontSize)];
    label.font = font;
    label.text = title;
    label.textColor = [ResourceManager color_1];
    label.textAlignment = NSTextAlignmentLeft;
    [self addSubview:label];
}

-(void)layoutHolderLabel:(NSString *)placeHolder{
    _holderLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.width - 150 * ScaleSize, (CellHeight44 - CellTitleFontSize)/2, 150 * ScaleSize - 28, CellTitleFontSize)];
    _holderLabel.font = [UIFont systemFontOfSize:14.0];
    _holderLabel.text = placeHolder;
    _holderLabel.textColor = [ResourceManager color_6];
    _holderLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:_holderLabel];
}

-(void)layoutHolderLabel:(NSString *)placeHolder width:(int) width{
    _holderLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - width - 14.0, (CellHeight44 - CellTitleFontSize)/2, width+100, CellTitleFontSize)];
    _holderLabel.font = [UIFont systemFontOfSize:14.0];
    _holderLabel.text = placeHolder;
    _holderLabel.textColor = [ResourceManager color_6];
    _holderLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_holderLabel];
}

-(void)layoutImagePicker:(BOOL)picker{
    _rightImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.width - 23, (CellHeight44 - 6)/2, 11, 6)];
    if (picker) {
        _rightImage.image = [UIImage imageNamed:@"arrow_down"];
    }else{
        _rightImage.image = [UIImage imageNamed:@"arrow_right"];
        _rightImage.frame = CGRectMake(self.width - 20, (CellHeight44 - 16)/2, 9, 16);
    }
    [self addSubview:_rightImage];
}

-(void)layoutButton{
    //UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(_holderLabel.frame), 0, 160, self.height)];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(_holderLabel.frame), 0, SCREEN_WIDTH-CGRectGetMinX(_holderLabel.frame), self.height)];
    [button addTarget:self action:@selector(showPickView) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
}



// 弹出框选择
-(PickerView *)initWithTitle:(NSString *)title placeHolder:(NSString *)placeHolder itemArray:(NSArray *)items origin_Y:(CGFloat)origin_Y{
    self = [super initWithFrame:CGRectMake(0, origin_Y, SCREEN_WIDTH, CellHeight44)];
    if (self) {
        self.linetype = LineTypeBotton;
        UIFont *font = [UIFont systemFontOfSize:14.0];
        _titleWidth = [title sizeWithAttributes:@{NSFontAttributeName:font}].width;
        
        [self layoutTitleLabel_left:title];
        [self layoutHolderLabel:placeHolder];
        //[self layoutImagePicker:YES];  // 右侧按钮向下
        [self layoutImagePicker:NO];   // 右侧按钮向右
        [self layoutButton];
        
        
        _itemsArray = items;
        _title = title;
        _selectedIndex = -1;
        _showPicker = YES;
    }
    return self;
}

// 弹出框选择2 (placeHolder 靠右， 宽度可自定义)  (修改，右侧箭头隐藏，底部划线隐藏)
-(PickerView *)initWithTitle:(NSString *)title placeHolder:(NSString *)placeHolder  width:(int)width  itemArray:(NSArray *)items origin_Y:(CGFloat)origin_Y
{
    self = [super initWithFrame:CGRectMake(0, origin_Y, SCREEN_WIDTH, CellHeight44)];
    if (self) {
        self.linetype = LineTypeNone;
        
        UIFont *font = [UIFont systemFontOfSize:14.0];
        _titleWidth = [title sizeWithAttributes:@{NSFontAttributeName:font}].width;
        
        [self layoutTitleLabel:title];
        //[self layoutHolderLabel:placeHolder];
        [self  layoutHolderLabel:placeHolder width:width];
        //[self layoutImagePicker:YES];  // 右侧按钮向下
        [self layoutImagePicker:NO];   // 右侧按钮向右
        [self layoutButton];
        _rightImage.hidden = YES;
        
        
        _itemsArray = items;
        _title = title;
        _selectedIndex = -1;
        _showPicker = YES;
    }
    return self;
}

-(PickerView *)initWithTitle:(NSString *)title imageName:(NSString*)imageName placeHolder:(NSString *)placeHolder itemArray:(NSArray *)items origin_Y:(CGFloat)origin_Y
{
    self = [super initWithFrame:CGRectMake(0, origin_Y, SCREEN_WIDTH, CellHeight44)];
    if (self) {
        self.linetype = LineTypeBotton;
        
        UIFont *font = [UIFont systemFontOfSize:14.0];
        _titleWidth = [title sizeWithAttributes:@{NSFontAttributeName:font}].width;
        
        [self layoutTitleLabel:title imageName:imageName];
        [self layoutHolderLabel:placeHolder];
        //[self layoutImagePicker:YES];  // 右侧按钮向下
        [self layoutImagePicker:NO];   // 右侧按钮向右
        [self layoutButton];
        
        
        _itemsArray = items;
        _title = title;
        _selectedIndex = -1;
        _showPicker = YES;
    }
    return self;

}

// 跳页面选择
-(PickerView *)initWithTitle:(NSString *)title placeHolder:(NSString *)placeHolder origin_Y:(CGFloat)origin_Y{
    self = [super initWithFrame:CGRectMake(0, origin_Y, SCREEN_WIDTH, CellHeight44)];
    if (self) {
        self.linetype = LineTypeBotton;
        
        [self layoutTitleLabel:title];
        [self layoutHolderLabel:placeHolder];
        //[self layoutImagePicker:YES];  // 右侧按钮向下
        [self layoutImagePicker:NO];   // 右侧按钮向右
        [self layoutButton];
        
        _title = title;
        _selectedIndex = -1;
        
        _showPicker = NO;
    }
    return self;
}

// 跳页面选择(风格2， placeHolder靠右)
-(PickerView *)initWithTitle:(NSString *)title placeHolder:(NSString *)placeHolder width:(int)width origin_Y:(CGFloat)origin_Y{
    self = [super initWithFrame:CGRectMake(0, origin_Y, SCREEN_WIDTH, CellHeight44)];
    if (self) {
        self.linetype = LineTypeBotton;
        
        [self layoutTitleLabel:title];
        //[self layoutHolderLabel:placeHolder];
        [self layoutHolderLabel:placeHolder width:width];
        //[self layoutImagePicker:YES];  // 右侧按钮向下
        [self layoutImagePicker:NO];   // 右侧按钮向右
        [self layoutButton];
        
        _title = title;
        _selectedIndex = -1;
        
        _showPicker = NO;
    }
    return self;
}

// 选择照片
-(PickerView *)initWithTitle:(NSString *)title placeHolderImage:(UIImage *)image origin_Y:(CGFloat)origin_Y{
    self = [super initWithFrame:CGRectMake(0, origin_Y, SCREEN_WIDTH, CellHeight44)];
    if (self) {
        self.linetype = LineTypeBotton;
        
        [self layoutTitleLabel:title];
        [self layoutImagePicker:NO];
        _rightImage.frame = CGRectMake(self.width - 45.0, (CellHeight44 - image.size.height)/2, image.size.width, image.size.height);
        _rightImage.image = image;
        [self layoutButton];
        
        _title = title;
        _selectedIndex = -1;
        
        _showPicker = NO;
    }
    return self;
}

-(UIView *)itemsView{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 42.0 + 36.0 * _itemsArray.count)];
    bgView.backgroundColor = UIColorFromRGB(0xffffff);
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    titleLabel.center = CGPointMake(bgView.width/2, 20.0);
    titleLabel.font = [UIFont systemFontOfSize:17.0];
    titleLabel.textColor = [ResourceManager color_7];
    titleLabel.text = _title;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:titleLabel];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 42.0, bgView.width, 1)];
    line.backgroundColor = [ResourceManager color_5];
    [bgView addSubview:line];
    
    for (int i = 0; i < _itemsArray.count; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 300, 36)];
        button.center = CGPointMake(bgView.width/2, 60.0 + 36.0 * i);
        button.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [button setTitle:_itemsArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[ResourceManager color_6] forState:UIControlStateNormal];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        button.tag = i + 100;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:button];
        
        if (i < _itemsArray.count-1) {
            UIView *subLine = [[UIView alloc] initWithFrame:CGRectMake(30.0, 78.0 + 36.0 * i, bgView.width - 30.0 * 2, 0.6)];
            subLine.backgroundColor = [ResourceManager color_5];
            [bgView addSubview:subLine];
        }
        
        if (i == _selectedIndex) {
            [button setTitleColor:[ResourceManager mainColor] forState:UIControlStateNormal];
        }
        
    }
    
    return bgView;
}

-(void)buttonClick:(UIButton *)button{
    _selectedIndex = (int)(button.tag - 100);
    [button setTitleColor:[ResourceManager mainColor] forState:UIControlStateNormal];
    
    _holderLabel.textColor = [ResourceManager color_7];
    _holderLabel.text = _itemsArray[_selectedIndex];
    
    //重新设置字体颜色
    if (_colorStyle) {
        //            _colorStyle = NO;
//        _holderLabel.textColor = UIColorFromRGB(0xF3754D);
    }

    if (_finishedBlock) {
        _finishedBlock(_selectedIndex);
    }
    [self remove];
}


-(void)showPickView{
    if (_beginBlock) {
        _beginBlock();
    }
    
    if (!_showPicker) return;
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    _backGroundView = [[UIView alloc] initWithFrame:window.bounds];
//    _backGroundView.backgroundColor = [UIColor grayColor];
    [window addSubview:_backGroundView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(remove)];
    [_backGroundView addGestureRecognizer:tap];
    
    _itemView = [self itemsView];
    [_backGroundView addSubview:_itemView];
    
    [UIView animateWithDuration:0.2f animations:^{
//        _backGroundView.alpha = 0.4f;
        float viewHeight = _itemView.height;
        _itemView.frame = CGRectMake(0, window.frame.size.height - viewHeight, window.frame.size.width, viewHeight);
    } completion:^(BOOL finished) {}];
}

-(void)remove{
    [UIView animateWithDuration:0.4f animations:^{
        _itemView.transform = CGAffineTransformMakeTranslation(0, SCREEN_HEIGHT);
//        _backGroundView.alpha = 0.f;
    } completion:^(BOOL finished) {
        [_backGroundView removeFromSuperview];
    }];
}






// 弹出框选择
-(PickerView *)initWithTypeTitle:(NSString *)title placeHolder:(NSString *)placeHolder itemArray:(NSArray *)items layoutImagePicker:(BOOL)imgPicker origin_Y:(CGFloat)origin_Y origin_X:(CGFloat)origin_X{
    self = [super initWithFrame:CGRectMake(origin_X, origin_Y, SCREEN_WIDTH - origin_X, CellHeight44)];
    if (self) {
        self.linetype = LineTypeBotton;
//        _colorStyle = YES;
        UIFont *font = [UIFont systemFontOfSize:14.0];
        _titleWidth = [title sizeWithAttributes:@{NSFontAttributeName:font}].width;
        
        [self layoutTitleLabel:title];
        [self layoutHolderLabel:placeHolder];
        [self layoutImagePicker:imgPicker];  // YES右侧按钮向下 NO右侧按钮向右
        [self layoutButton];
        _itemsArray = items;
        _title = title;
        _selectedIndex = -1;
        _showPicker = YES;
    }
    return self;
}

// 跳页面选择
-(PickerView *)initWithTypeTitle:(NSString *)title placeHolder:(NSString *)placeHolder origin_Y:(CGFloat)origin_Y origin_X:(CGFloat)origin_X{
    self = [super initWithFrame:CGRectMake(origin_X, origin_Y, SCREEN_WIDTH - origin_X, CellHeight44)];
    if (self) {
        self.linetype = LineTypeBotton;
        _colorStyle = YES;
        [self layoutTitleLabel:title];
        [self layoutHolderLabel:placeHolder];
        [self layoutImagePicker:YES];  // 右侧按钮向下
//        [self layoutImagePicker:NO];   // 右侧按钮向右
        [self layoutButton];
        
        _title = title;
        _selectedIndex = -1;
        
        _showPicker = NO;
    }
    return self;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
