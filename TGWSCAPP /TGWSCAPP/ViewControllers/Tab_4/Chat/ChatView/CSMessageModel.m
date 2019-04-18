//
//  CSMessageModel.m
//  XMPPChat
//
//  Created by 123 on 2017/12/14.
//  Copyright © 2017年 123. All rights reserved.
//

#import "CSMessageModel.h"
//#import "MessageHeader.h"
#import "ConstantPart.h"
#import "UIImage+Han.h"

#define ScreenWidth  [UIScreen mainScreen].bounds.size.width
#define ScreenHight [UIScreen mainScreen].bounds.size.height

NSString  *bg_chat_tablename =  @"chatmessage";
int  MessageFontSize = 14;


@implementation CSMessageModel



/**
 如果需要指定“唯一约束”字段,就实现该函数,这里指定 name 为“唯一约束”.
 */
//+(NSArray *)bg_uniqueKeys{
//    return @[@"name"];
//}

/**
 设置不需要存储的属性.
 */
//+(NSArray *)bg_ignoreKeys{
//   return @[@"eye",@"sex",@"num"];
//}

/**
 自定义“联合主键” ,这里指定 name和age 为“联合主键”.
 */
//+(NSArray *)bg_unionPrimaryKeys{
//    return @[@"name",@"age"];



- (instancetype)init {
    if (self = [super init]) {

        self.bg_tableName = bg_chat_tablename;//自定义数据库表名称(库自带的字段).
    }
    return self;
}


- (CGRect)timeFrame
{
    CGRect rect  = CGRectZero;
    if (self.showMessageTime)
    {
        //CGSize size = [self labelAutoCalculateRectWith:self.messageTime Font:[UIFont fontWithName:FONT_REGULAR size:10] MaxSize:CGSizeMake(MAXFLOAT, 17)];
        //rect = CGRectMake((ScreenWidth - size.width)/2, 0, size.width + 10, 17);
        rect = CGRectMake(0, 0, ScreenWidth, 17);
    }

    return rect;
}

- (CGRect)logoFrame
{
    
    CGRect timeRect = [self timeFrame];
   
    CGRect rect = CGRectZero;
    if (self.messageSenderType == MessageSenderTypeMe)
    {
        rect = CGRectMake(ScreenWidth - 50,timeRect.size.height + 10, 40, 40);
    }
    else
    {
        rect = CGRectMake(10, timeRect.size.height + 10, 40, 40);
    }
    return rect;
}


- (CGRect)messageFrame
{
    CGRect timeRect = [self timeFrame];
    CGRect rect = CGRectZero;
    //CGFloat maxWith = ScreenWidth * 0.7 - 60;
    CGFloat maxWith = ScreenWidth * 0.80 - 60;
     CGSize size = [self labelAutoCalculateRectWith:self.messageText Font:[UIFont fontWithName:FONT_REGULAR size:MessageFontSize] MaxSize:CGSizeMake(maxWith, MAXFLOAT)];
    if (self.messageText == nil)
    {
        return rect;
    }
    if (self.messageSenderType == MessageSenderTypeMe)
    {
        rect = CGRectMake(ScreenWidth * 0.20, timeRect.size.height + 10, maxWith - 5, size.height > 44 ? size.height : 44);
    }
    else
    {
        rect = CGRectMake(65 , timeRect.size.height + 10 , maxWith, size.height > 44 ? size.height : 44);
    }
    
    if(self.onlyShowTime)
     {
        return CGRectZero;
     }
    
    return rect;
}

- (CGRect)questionFrame
{
    CGRect timeRect = [self timeFrame];
    CGRect rect = CGRectZero;
    //CGFloat maxWith = ScreenWidth * 0.7 - 60;
    CGFloat maxWith = ScreenWidth * 0.80 - 60;
    
    if (self.messageType != MessageTypeQuestion)
     {
        return  CGRectZero;
     }
    
    NSString *strQuestion = @"";
    for (int i = 0; i < _arrQuestion.count; i++)
     {
        NSString *strTemp = [NSString stringWithFormat:@"\n%d. %@", i+1, _arrQuestion[i]];
        strQuestion = [strQuestion stringByAppendingString:strTemp];
     }
    
    if (strQuestion.length > 0)
     {
        strQuestion = [strQuestion stringByAppendingString:@"\n请输入对应数字，查询相关问题。"];
     }
    
    CGSize size = [self labelAutoCalculateRectWith:strQuestion Font:[UIFont fontWithName:FONT_REGULAR size:MessageFontSize] MaxSize:CGSizeMake(maxWith, MAXFLOAT)];

    //rect = CGRectMake(65 , timeRect.size.height + 10 , maxWith, size.height + 31 +5);
    rect = CGRectMake(65 , timeRect.size.height + 10 , maxWith, size.height + 31);
    

    return rect;
}

- (CGRect)voiceFrame
{
    
    
    CGRect timeRect = [self timeFrame];
    CGFloat timeLabelHeight = timeRect.size.height ;
    CGRect rect = CGRectZero;
    CGFloat maxWith = ScreenWidth * 0.7 - 60;
    if (self.duringTime <= 0)
    {
        return rect;
    }
    if (self.messageSenderType == MessageSenderTypeMe)
    {
        rect = CGRectMake(AppFrameWidth * 0.3 + 10 + maxWith - maxWith *(self.duringTime/20.0 > 1? 1 :self.duringTime/20.0), timeLabelHeight + 10, maxWith *(self.duringTime/20.0 > 1? 1 :self.duringTime/20.0), 44);
    }
    else
    {
        rect = CGRectMake(50, timeLabelHeight + 10 , maxWith *(self.duringTime/20.0 > 1? 1 :self.duringTime/20.0), 44);
    }
    return rect;
}
- (CGRect)voiceAnimationFrame
{
    //12, 16
    CGRect voiceRect = [self voiceFrame];
    CGRect rect = CGRectZero;
    if (self.messageSenderType == MessageSenderTypeMe)
    {
        rect.origin.x = voiceRect.size.width - 24;
        rect.origin.y = 14;
        rect.size.width = 12;
        rect.size.height = 16;
        
    }
    else
    {
        rect.origin.x = 12;
        rect.origin.y = 14;
        rect.size.width = 12;
        rect.size.height = 16;
    }
    return rect;
}
- (CGRect)imageFrame
{
    CGRect timeRect = [self timeFrame];
    CGFloat timeLabelHeight = timeRect.size.height;
    CGRect rect = CGRectZero;
    
    CGSize imageSize = [self.imageSmall imageShowSize];
    
    if (self.imageSmall == nil)
    {
        return rect;
    }
    
    if (self.messageSenderType == MessageSenderTypeMe)
    {
        rect = CGRectMake(ScreenWidth - imageSize.width - 50, timeLabelHeight + 10, imageSize.width, imageSize.height);
    }
    else
    {
        rect = CGRectMake(50, timeLabelHeight + 10, imageSize.width, imageSize.height);
    }
    return rect;
}
- (CGRect)bubbleFrame
{
    CGRect rect = CGRectZero;
    switch (self.messageType)
    {
        case MessageTypeText:
            rect = [self messageFrame];
            rect.origin.x =  rect.origin.x + (self.messageSenderType == MessageSenderTypeMe? -10 : -15);
            rect.size.width =  rect.size.width + 25;
            break;
        case MessageTypeVoice:
            rect = [self voiceFrame];
            break;
        case MessageTypeImage:
            rect = [self imageFrame];
            break;
        case MessageTypeQuestion:
            rect = [self questionFrame];
            rect.origin.x =  rect.origin.x + (self.messageSenderType == MessageSenderTypeMe? -10 : -15);
            rect.size.width =  rect.size.width + 25;
            break;
        default:
            break;
    }
    
    return rect;
}
- (CGFloat)cellHeight
{
    if (self.onlyShowTime)
     {
        return [self timeFrame].size.height;
     }
    CGFloat fH = [self timeFrame].size.height + [self messageFrame].size.height + [self voiceFrame].size.height + [self imageFrame].size.height +   [self questionFrame].size.height + 15;
    return fH;
}

- (CGSize)labelAutoCalculateRectWith:(NSString *)text Font:(UIFont *)textFont MaxSize:(CGSize)maxSize
{
    NSDictionary *attributes = @{NSFontAttributeName: textFont};
    CGRect rect = [text boundingRectWithSize:maxSize
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:attributes
                                     context:nil];
    return rect.size;
}


#pragma mark   ---  操作数据库的方法
-(void) dbMethod
{
    /**
     想测试更多功能,打开注释掉的代码即可.
     */
//    bg_setDebug(YES);//打开调试模式,打印输出调试信息.
    
    /**
     如果频繁操作数据库时,建议进行此设置(即在操作过程不关闭数据库).
     */
    //bg_setDisableCloseDB(YES);
    
    /**
     手动关闭数据库(如果设置了bg_setDisableCloseDB(YES)，则在切换bg_setSqliteName前，需要手动关闭数据库一下).
     */
    //bg_closeDB();
    
    /**
     自定义数据库名称，否则默认为BGFMDB
     */
    //bg_setSqliteName(@"Tencent");
    
    //删除自定义数据库.
    //bg_deleteSqlite(@"Tencent");
    
    /**
     直接存储数组.
     */
    //[self testSaveArray];
    
    /**
     直接存储字典.
     */
    //[self testSaveDictionary];
    /**
     直接存储自定义对象.
     */
//    People* p = [self people];
//    p.bg_tableName = bg_tablename;//自定义数据库表名称(库自带的字段).
//    /**
//     存储.
//     */
//    [p bg_save];
    
    /**
     同步存储或更新.
     当"唯一约束"或"主键"存在时，此接口会更新旧数据,没有则存储新数据.
     */
    //[p bg_saveOrUpdate];
    
    /**
     事务操作
     */
    //    bg_inTransaction(^BOOL{
    //        //此处进行--> 增删改 操作
    //        return true;//返回true是提交事务，返回false是回滚事务.
    //    });
    
    /**
     同步 存储或更新 数组元素.
     当"唯一约束"或"主键"存在时，此接口会更新旧数据,没有则存储新数据.
     提示：“唯一约束”优先级高于"主键".
     */
    //    p.bg_id = @(1);
    //    People* p1 = [self people];
    //    p1.bg_tableName = bg_tablename;//自定义数据库表名称(库自带的字段).
    //    p1.bg_id = @(2);
    //    p1.age = 66611;
    //    p1.name = @"琪瑶11";
    //    People* p2 = [self people];
    //    p2.bg_tableName = bg_tablename;//自定义数据库表名称(库自带的字段).
    //    p2.bg_id = @(3);
    //    p2.age = 88822;
    //    p2.name = @"标哥22";
    //    [People bg_saveOrUpdateArray:@[p,p1,p2]];
    
    /**
     单个对象更新,支持keyPath.
     根据user下的student下的human下的body是否等于小芳 或 age是否等于31 来更新当前对象的数据进入数据库.
     */
    //NSString* where = [NSString stringWithFormat:@"where %@ and %@=%@",bg_keyPathValues(@[@"user.student.num",bg_equal,@"标哥"]),bg_sqlKey(@"age"),bg_sqlValue(@(99))];
    //p.name = @"天朝1";
    //[p bg_updateWhere:where];
    
    /**
     使用SQL语句设置更新.
     根据某个属性值去更改某个属性值，此处是当name等于@"天朝"时,设置age=100.
     */
    //    NSString* where = [NSString stringWithFormat:@"set %@=%@ where %@=%@",bg_sqlKey(@"age"),bg_sqlValue(@(100)),bg_sqlKey(@"name"),bg_sqlValue(@"斯巴达")];
    //    [People bg_update:bg_tablename where:where];
    
    //    NSMutableArray* arrayM = [NSMutableArray array];
    //    Human* human = [Human new];
    //    human.sex = @"女";
    //    human.body = @"小芳";
    //    human.humanAge = 26;
    //    human.age = 15;
    //    human.num = 999;
    //    human.counts = 10001;
    //    human.food = @"大米";
    //    [arrayM addObject:@"111"];
    //    [arrayM addObject:@"222"];
    //    [arrayM addObject:human];
    //    NSString * update = [NSString stringWithFormat:@"set %@=%@ where %@=%@",bg_sqlKey(@"datasM"),bg_sqlValue(arrayM),bg_sqlKey(bg_primaryKey),bg_sqlValue(@(1))];
    //    [People bg_update:bg_tablename where:update];
    
    /**
     获取第一个元素.
     */
    //    People* firstObj = [People bg_firstObjet:bg_tablename];
    
    /**
     获取最后一个元素.
     */
    //    People* lastObj = [People bg_lastObject:bg_tablename];
    
    /**
     获取某一行的元素.
     */
    //    People* someObj = [People bg_object:bg_tablename row:3];
    
    /**
     覆盖存储,即清除之前的数据，只存储当前的数据.
     */
    //    [p bg_cover];
    
    /**
     按条件查询.
     */
    //    NSString* where = [NSString stringWithFormat:@"where %@=%@",bg_sqlKey(@"name"),bg_sqlValue(@"斯巴达")];
    //    NSArray* arr = [People bg_find:bg_tablename where:where];
    
    /**
     按时间段查找数据.
     */
    //    NSArray* arr = [People bg_find:bg_tablename type:bg_createTime dateTime:@"2017-11-30"];
    
    /**
     按条件删除.
     */
    //    NSString* where = [NSString stringWithFormat:@"where %@=%@",bg_sqlKey(@"name"),bg_sqlValue(@"斯巴达")];
    //    [People bg_delete:bg_tablename where:where];
    
    /**
     直接写SQL语句操作
     */
    //NSArray* arr = bg_executeSql(@"select * from yy", bg_tablename, [People class]);//查询时,后面两个参数必须要传入.
    //    bg_executeSql(@"update yy set BG_name='标哥'", nil, nil);//更新或删除等操作时,后两个参数不必传入.
    
    /**
     获取数据表当前版本号.
     */
    //    NSInteger version = [People bg_version:bg_tablename];
    /**
     刷新,当类"唯一约束"改变时,调用此接口刷新一下.
     version 版本号,从1开始,依次往后递增.
     说明: 本次更新版本号必须 大于 上次的版本号,否则不会更新.
     */
    //    [People bg_update:bg_tablename version:1];
    
    /**
     使用keyPath查询嵌套类信息.
     */
    //    NSString* where = [NSString stringWithFormat:@"where %@",bg_keyPathValues(@[@"user.name",bg_equal,@"陈浩"])];
    //    NSArray* arrFind = [People bg_find:bg_tablename where:where];
    
    /**
     当数据量巨大时采用分页范围查询.
     */
//    NSInteger count = [People bg_count:bg_tablename where:nil];
//    for(int i=1;i<=count;i+=50){
//        NSArray* arr = [People bg_find:bg_tablename range:NSMakeRange(i,50) orderBy:nil desc:NO];
//        for(People* pp in arr){
//            //具体数据请断点查看
//            //库新增两个自带字段createTime和updateTime方便开发者使用和做参考对比.
//            NSLog(@"主键 = %@, 表名 = %@, 创建时间 = %@, 更新时间 = %@",pp.bg_id,pp.bg_tableName,pp.bg_createTime,pp.bg_updateTime);
//        }
//
//        //顺便取第一个对象数据测试
//        if(i==1){
//            People* lastP = arr.lastObject;
//            _showImage.image = lastP.image;
//            _showLab.attributedText = lastP.attriStr;
//        }
//    }
}

@end
