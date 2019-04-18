//
//  ViewController.h
//  XMPPChat
//
//  Created by 123 on 2017/12/14.
//  Copyright © 2017年 123. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSBigView.h"
#import "EmojiView.h"


@interface ChatViewController : CommonViewController


@property (nonatomic, strong)  UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) CGFloat nowHeight;
@property (nonatomic, strong) UIImageView *photoImageView;
@property (nonatomic, strong) CSBigView *bigImageView;
@property (nonatomic, strong) EmojiView *ev;
@property (nonatomic, strong) UIImage *photoImage;
@property (nonatomic, strong) NSIndexPath *selectIndex;


@end

