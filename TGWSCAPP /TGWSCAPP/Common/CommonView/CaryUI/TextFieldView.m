//
//  TextFieldView.m
//  JYApp
//
//  Created by xxjr02 on 16/6/2.
//  Copyright © 2016年 xxjr02. All rights reserved.
//

#import "TextFieldView.h"

@implementation TextFieldView

-(UITextField *)textField{
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        
        _textField.textColor = [ResourceManager color_7];
        _textField.font = [ResourceManager font_6];
    }
    return _textField;
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

#pragma mark === Init

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

-(TextFieldView *)initWithTitle:(NSString *)title placeHolder:(NSString *)placeHolder originY:(CGFloat)originY fieldViewType:(TextFieldViewType)type{
    self = [super initWithFrame:CGRectMake(0, originY, SCREEN_WIDTH, CellHeight44)];
    if (self) {
        self.linetype = LineTypeBotton;
        
        UIFont *font = [UIFont systemFontOfSize:14.0];
        _titleWidth = [title sizeWithAttributes:@{NSFontAttributeName:font}].width;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CellSpaceReserved, (CellHeight44 - CellTitleFontSize)/2, 160.0, CellTitleFontSize)];
        label.font = font;
        label.text = title;
        label.textColor = [ResourceManager color_1];
        label.textAlignment = NSTextAlignmentLeft;
        [self addSubview:label];
        
        float textFieldHeight = 24.0;
//        float textFieldWidth = type == TextFieldViewCode ? 80 : 150;
        float textFieldWidth = 170;
        self.textField.frame = CGRectMake(SCREEN_WIDTH - textFieldWidth - 14.0, (CellHeight44 - textFieldHeight)/2, textFieldWidth, textFieldHeight);
        self.textField.placeholder = placeHolder;
        self.textField.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.textField];
        if (type == TextFieldViewCode || type == TextFieldViewNumber) {
            _textField.keyboardType = UIKeyboardTypeDecimalPad;
        }else if (type == TextFieldViewEmail){
            _textField.keyboardType = UIKeyboardTypeEmailAddress;
        }
    }
    return self;
}

////文字 (风格2, placeHolder可选择方向， 宽度可以自定义)
-(TextFieldView *)initWithTitle:(NSString *)title placeHolder:(NSString *)placeHolder  textAlignment:(NSTextAlignment)textAlignment  width:(int)width  originY:(CGFloat)originY fieldViewType:(TextFieldViewType)type
{
    self = [super initWithFrame:CGRectMake(0, originY, SCREEN_WIDTH, CellHeight44)];
    if (self) {
        self.linetype = LineTypeBotton;
        
        UIFont *font = [UIFont systemFontOfSize:14.0];
        _titleWidth = [title sizeWithAttributes:@{NSFontAttributeName:font}].width;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CellSpaceReserved, (CellHeight44 - CellTitleFontSize)/2, 140.0, CellTitleFontSize)];
        label.font = font;
        label.text = title;
        label.textColor = [ResourceManager color_1];
        label.textAlignment = NSTextAlignmentLeft;
        [self addSubview:label];
        
        float textFieldHeight = 24.0;
        //        float textFieldWidth = type == TextFieldViewCode ? 80 : 150;
        float textFieldWidth = width;
        self.textField.frame = CGRectMake(SCREEN_WIDTH - textFieldWidth - 14.0, (CellHeight44 - textFieldHeight)/2, textFieldWidth, textFieldHeight);
        self.textField.placeholder = placeHolder;
        self.textField.textAlignment = textAlignment;
        [self addSubview:self.textField];
        if (type == TextFieldViewCode || type == TextFieldViewNumber) {
            _textField.keyboardType = UIKeyboardTypeDecimalPad;
        }else if (type == TextFieldViewEmail){
            _textField.keyboardType = UIKeyboardTypeEmailAddress;
        }
    }
    return self;
}

-(TextFieldView *)initWithTitle:(NSString *)title unitStr:(NSString *)unitStr textColor:(UIColor *)color placeHolder:(NSString *)placeHolder originY:(CGFloat)originY originX:(CGFloat)originX  fieldViewType:(TextFieldViewType)type
{
    self = [super initWithFrame:CGRectMake(originX, originY, SCREEN_WIDTH - originX, CellHeight44)];
    if (self) {
        UIFont *font = [UIFont systemFontOfSize:14.0];
        self.linetype = LineTypeBotton;
        _titleWidth = [title sizeWithAttributes:@{NSFontAttributeName:font}].width;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, (CellHeight44 - CellTitleFontSize)/2, 160, CellTitleFontSize)];
        label.font = font;
        label.text = title;
        label.textColor = [ResourceManager color_1];
        label.textAlignment = NSTextAlignmentLeft;
        [self addSubview:label];
        if (unitStr.length > 0) {
            UILabel *label_2 = [[UILabel alloc] initWithFrame:CGRectMake(self.width - 15 * unitStr.length - 10, 0, 15 * unitStr.length, CellHeight44)];
            label_2.font = font;
            label_2.text = unitStr;
            label_2.textColor = color;
            label_2.textAlignment = NSTextAlignmentRight;
            [self addSubview:label_2];
        }
        
        //float textFieldHeight = 24.0;
//        float textFieldWidth = type == TextFieldViewCode ? 80 : 150;
        self.textField.frame = CGRectMake(self.width - 160 - 15 * unitStr.length - 12, 1, 160, CellHeight44);
        //文本颜色改变
        if (color) {
            self.textField.textColor = color;
        }
        
        self.textField.placeholder = placeHolder;
        self.textField.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.textField];
        
        if (type == TextFieldViewCode || type == TextFieldViewNumber) {
            _textField.keyboardType = UIKeyboardTypeDecimalPad;
        }else if (type == TextFieldViewEmail){
            _textField.keyboardType = UIKeyboardTypeEmailAddress;
        }
        
    }
    return self;

}




-(TextFieldView *)initWithImageName:(NSString *)imageName placeHolder:(NSString *)placeHolder atIndex:(int)index fieldViewType:(TextFieldViewType)type{
    self = [super initWithFrame:CGRectMake(0, CellHeight44*index, SCREEN_WIDTH, CellHeight44)];
    if (self) {
        self.linetype = LineTypeBotton;
        
        UIImage *image = [UIImage imageNamed:imageName];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CellSpaceReserved, (CellHeight44 - image.size.height)/2, image.size.width, image.size.height)];
        imageView.image = image;
        imageView.contentMode = UIViewContentModeCenter;
        [self addSubview:imageView];
        
        float textFieldHeight = 24.0;
        float textFieldWidth = type == TextFieldViewCode ? 100 : 250;
        self.textField.frame = CGRectMake(42.0, (CellHeight44 - textFieldHeight)/2, textFieldWidth, textFieldHeight);
        self.textField.placeholder = placeHolder;
        [self addSubview:self.textField];
        if (type == TextFieldViewCode || type == TextFieldViewNumber) {
            _textField.keyboardType = UIKeyboardTypeNumberPad;
        }
    }
    return self;
}


//标题带图片的样式
-(TextFieldView *)initWithImageName:(NSString *)imageName  withTitle:(NSString *)title placeHolder:(NSString *)placeHolder originY:(CGFloat)originY  fieldViewType:(TextFieldViewType)type 
{
    self = [super initWithFrame:CGRectMake(0, originY, SCREEN_WIDTH, CellHeight44)];
    if (self) {
        self.linetype = LineTypeBotton;
        
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
        
        float textFieldHeight = 24.0;
        //        float textFieldWidth = type == TextFieldViewCode ? 80 : 150;
        float textFieldWidth = 150;
        self.textField.frame = CGRectMake(SCREEN_WIDTH - textFieldWidth - 14.0, (CellHeight44 - textFieldHeight)/2, textFieldWidth, textFieldHeight);
        self.textField.placeholder = placeHolder;
        self.textField.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.textField];
        if (type == TextFieldViewCode || type == TextFieldViewNumber) {
            _textField.keyboardType = UIKeyboardTypeDecimalPad;
        }else if (type == TextFieldViewEmail){
            _textField.keyboardType = UIKeyboardTypeEmailAddress;
        }
    }
    return self;
}

//标题带图片的样式， 并且带单位
-(TextFieldView *)initWithImageName:(NSString *)imageName  withTitle:(NSString *)title  unitStr:(NSString *)unitStr placeHolder:(NSString *)placeHolder originY:(CGFloat)originY  fieldViewType:(TextFieldViewType)type
{
    self = [super initWithFrame:CGRectMake(0, originY, SCREEN_WIDTH, CellHeight44)];
    if (self) {
        self.linetype = LineTypeBotton;
        
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
        
        UILabel *label_2 = [[UILabel alloc] initWithFrame:CGRectMake(self.width - 15 * unitStr.length - 10, 0, 15 * unitStr.length, CellHeight44)];
        label_2.font = font;
        label_2.text = unitStr;
        label_2.textColor = [ResourceManager color_1];
        label_2.textAlignment = NSTextAlignmentRight;
        [self addSubview:label_2];
        
        self.textField.frame = CGRectMake(self.width - 150 - 15 * unitStr.length - 12, 1, 150, CellHeight44);
        self.textField.placeholder = placeHolder;
        self.textField.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.textField];
        if (type == TextFieldViewCode || type == TextFieldViewNumber) {
            _textField.keyboardType = UIKeyboardTypeDecimalPad;
        }else if (type == TextFieldViewEmail){
            _textField.keyboardType = UIKeyboardTypeEmailAddress;
        }
    }
    return self;
    
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    [super drawRect:rect];
    
    CGRect rrcet = self.textField.frame;
    // 非图片输入框x坐标重新做一下布局
    if (rrcet.origin.x > 45.0 && rrcet.origin.x == SCREEN_WIDTH - 150 - 14.0) {
        rrcet.origin.x = rect.size.width - rrcet.size.width - 14.0;
        self.textField.frame = rrcet;
    }
}


@end
