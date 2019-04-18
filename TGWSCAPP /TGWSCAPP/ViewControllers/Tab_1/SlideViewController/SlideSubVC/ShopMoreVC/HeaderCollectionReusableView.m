//
//  HeaderCollectionReusableView.m
//  TGWSCAPP
//
//  Created by xxjr02 on 2018/12/27.
//  Copyright © 2018 xxjr03. All rights reserved.
//

#import "HeaderCollectionReusableView.h"

@implementation HeaderCollectionReusableView




-(id)initWithFrame:(CGRect)frame{
    
        self=[super initWithFrame:frame];
    
        if (self) {
        
                [self createBasicView];
        
            }
    
        return self;
    
}



/**
  *   进行基本布局操作,根据需求进行.
  */

-(void)createBasicView{
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0,self.frame.size.width-50, self.frame.size.height)];
    _titleLabel.textColor = [ResourceManager color_1];
    _titleLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:_titleLabel];
    
    //UIView *viewFG = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    //[self addSubview:viewFG];
    //viewFG.backgroundColor = [ResourceManager color_5];
    
}

/**
*
*   @param title
*/

-(void)setSHCollectionReusableViewHearderTitle:(NSString *)title{
    
    _titleLabel.text= title;
    
}


@end
