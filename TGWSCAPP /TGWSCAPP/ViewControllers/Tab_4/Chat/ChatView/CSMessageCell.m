//
//  CSMessageCell.m
//  XMPPChat
//
//  Created by 123 on 2017/12/14.
//  Copyright © 2017年 123. All rights reserved.
//

#import "CSMessageCell.h"
#import "CSMessageModel.h"
#import "ConstantPart.h"
#import "UILabel+Han.h"
#import "UIImage+Han.h"


@interface CSMessageCell()

@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UIImageView *bubbleImageView;
@property (nonatomic, strong) UIImageView *voiceImageView;

@property (nonatomic, strong) UILabel     *messageLabel;
@property (nonatomic, strong) UILabel     *timeLabel;
@property (nonatomic, strong) UIFont      *textFont;


@property (nonatomic, strong) UILabel     *questionTilteLabel;
@property (nonatomic, strong) UILabel     *questionContextLabel;
@property (nonatomic, strong) UIView     *questionViewFG;


@end
@implementation CSMessageCell

+(instancetype)cellWithTableView:(UITableView *)tableView messageModel:(CSMessageModel *)model{
    
    static NSString *identifier = @"WeChatCell";
    CSMessageCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell ==nil)
    {
        cell = [[CSMessageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.messageModel = model;
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        //初始化subViews
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        [self creatSubViewTime];
        [self creatSubViewBubble];
        [self creatSubViewLogo];
        [self creatSubViewMessage];
        [self creatSubViewVoice];
        [self creatSubViewAnimationVoice];
        [self creatSubViewImage];
        [self creatSubViewQuestion];
        
    }
    return self;
}
#pragma mark - 创建子视图

- (void)creatSubViewMessage
{
    _messageLabel      = [[UILabel alloc] init];
    _messageLabel.hidden      = YES;
    [self.contentView addSubview:_messageLabel];
    _textFont=[UIFont fontWithName:FONT_REGULAR size:MessageFontSize];
    _messageLabel.numberOfLines=0;
    _messageLabel.lineBreakMode=NSLineBreakByWordWrapping;
    _messageLabel.font = _textFont;
    _messageLabel.textColor=COLOR_444444;
}

- (void)creatSubViewTime
{
    _timeLabel        = [[UILabel alloc] init];
    _timeLabel.hidden        = YES;
    [self.contentView addSubview:_timeLabel];
    _timeLabel.font=[UIFont fontWithName:FONT_REGULAR size:10];
    //_timeLabel.backgroundColor=COLOR_cecece;
    _timeLabel.textColor= UIColorFromRGB(0x808080);
    _timeLabel.textAlignment=NSTextAlignmentCenter;
    _timeLabel.layer.masksToBounds=YES;
    _timeLabel.layer.cornerRadius=4;
    //_timeLabel.layer.borderColor=[COLOR_cecece CGColor];
    //_timeLabel.layer.borderWidth=1;
}

- (void)creatSubViewLogo
{
    _logoImageView    = [[UIImageView alloc] init];
    _logoImageView.hidden    = YES;
    [self.contentView addSubview:_logoImageView];
}

- (void)creatSubViewBubble
{
    _bubbleImageView  = [[UIImageView alloc] init];
    _bubbleImageView.hidden  = YES;
    _bubbleImageView.userInteractionEnabled = YES;
    [self.contentView addSubview:_bubbleImageView];
    
    UILongPressGestureRecognizer *longPressGesture=[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressBubbleView:)];
    [_bubbleImageView  addGestureRecognizer:longPressGesture];
    
    
    UITapGestureRecognizer * singleTap2    = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap2:)];
    [_bubbleImageView addGestureRecognizer:singleTap2];
}

- (void)creatSubViewVoice
{
    _voiceImageView   = [[UIImageView alloc] init];
    _voiceImageView.hidden   = YES;
    [self.contentView addSubview:_voiceImageView];
}
- (void)creatSubViewAnimationVoice
{
    _voiceAnimationImageView   = [[UIImageView alloc] init];
    _voiceAnimationImageView.hidden   = YES;
    [_voiceImageView addSubview:_voiceAnimationImageView];
}
- (void)creatSubViewImage
{
    _imageImageView   = [[UIImageView alloc] init];
    _imageImageView.hidden   = YES;
    [self.contentView addSubview:_imageImageView];
}

- (void)creatSubViewQuestion
{
    _questionTilteLabel      = [[UILabel alloc] init];
    _questionTilteLabel.hidden      = YES;
    [self.contentView addSubview:_questionTilteLabel];
    _textFont =[UIFont fontWithName:FONT_REGULAR size:MessageFontSize];
    _questionTilteLabel.numberOfLines=0;
    _questionTilteLabel.lineBreakMode=NSLineBreakByWordWrapping;
    _questionTilteLabel.font = _textFont;
    _questionTilteLabel.textColor = COLOR_444444;
    
    
    //_questionViewFG = [[UIView alloc] initWithFrame:CGRectMake(0, 20, 0.8*SCREEN_WIDTH, 1)];
    _questionViewFG = [[UIView alloc] init];
    _questionViewFG.hidden      = YES;
    [self.contentView addSubview:_questionViewFG];
    _questionViewFG.backgroundColor = [ResourceManager color_5];
    
    
    
    _questionContextLabel      = [[UILabel alloc] init];
    _questionContextLabel.hidden      = YES;
    [self.contentView addSubview:_questionContextLabel];
    _textFont =[UIFont fontWithName:FONT_REGULAR size:MessageFontSize];
    _questionContextLabel.numberOfLines=0;
    _questionContextLabel.lineBreakMode=NSLineBreakByWordWrapping;
    _questionContextLabel.font = _textFont;
    _questionContextLabel.textColor = COLOR_444444;
}


#pragma mark  ---   根据model 设置UI
- (void)setMessageModel:(CSMessageModel *)messageModel {
    _messageModel = messageModel;

    
    _timeLabel.hidden = !messageModel.showMessageTime;
    _timeLabel.frame = [messageModel timeFrame];
    _timeLabel.text = messageModel.messageTime;
    
    
    
    _logoImageView.hidden = NO;
    _logoImageView.frame = [messageModel logoFrame];
    _logoImageView.layer.masksToBounds = YES;
    _logoImageView.layer.cornerRadius = _logoImageView.frame.size.width/2;
    
    
    if (messageModel.onlyShowTime)
     {
        // 如果仅仅显示 时间字符串
        _logoImageView.hidden = YES;
     }
   
    _bubbleImageView.hidden = NO;
    _bubbleImageView.frame = [messageModel bubbleFrame];
    
    if (messageModel.messageSenderType == MessageSenderTypeMe)
    {
        //_logoImageView.image = [UIImage imageNamed:@"Tab_4-2"];
       NSString *strHead = @"";
       NSDictionary *dicUser = [CommonInfo userInfo];
       if (dicUser)
        {
           strHead = dicUser[@"headImgUrl"];
        }
        [_logoImageView sd_setImageWithURL:[NSURL URLWithString:strHead] placeholderImage:[UIImage imageNamed:@"Tab_4-2"]];
        _bubbleImageView.image = [[UIImage imageNamed:@"me"] stretchableImageWithLeftCapWidth:20 topCapHeight:40];
    }
    else
    {
        _logoImageView.image = [UIImage imageNamed:@"com_tgw"];
        _bubbleImageView.image = [[UIImage imageNamed:@"other"] stretchableImageWithLeftCapWidth:20 topCapHeight:40];
    }
    
    
    switch (messageModel.messageType)
    {
        case MessageTypeText:
            _messageLabel.hidden = NO;
            _messageLabel.frame = [messageModel messageFrame];
            _messageLabel.text = messageModel.messageText;
             _messageLabel.textAlignment = NSTextAlignmentLeft;
            break;
        case MessageTypeQuestion:
//           _messageLabel.hidden = NO;
//           _messageLabel.frame = [messageModel messageFrame];
//           _messageLabel.text = messageModel.messageText;
//           _messageLabel.textAlignment = NSTextAlignmentLeft;
           
            {
               CGRect timeRect = [messageModel timeFrame];
               CGRect bubbleRect = [messageModel bubbleFrame];
               
                CGRect questionTilteRect =  CGRectMake(65+10, timeRect.size.height + 10, bubbleRect.size.width - 35, 30);
               _questionTilteLabel.frame = questionTilteRect;
               _questionTilteLabel.hidden = NO;
               _questionTilteLabel.text = messageModel.tiltleQuestion;
               //_questionTilteLabel.backgroundColor = [UIColor yellowColor];
               
               CGRect viewFGRect =  CGRectMake(65, timeRect.size.height + 10 + 30 , bubbleRect.size.width-15, 1);
               _questionViewFG.hidden = NO;
               _questionViewFG.frame = viewFGRect;
               
               [self setQuestionContext];
               
               break;
            }
        case MessageTypeVoice:
            _voiceImageView.hidden = NO;
            _voiceImageView.frame = [messageModel voiceFrame];
            _messageLabel.hidden = NO;
            _messageLabel.frame = [messageModel voiceFrame];
            _messageLabel.textAlignment = messageModel.messageSenderType == MessageSenderTypeMe ? NSTextAlignmentLeft:NSTextAlignmentRight;
            _messageLabel.text = [NSString stringWithFormat:@"%ld''",(long)messageModel.duringTime];
            _voiceAnimationImageView.hidden = NO;
            _voiceAnimationImageView.frame = [messageModel voiceAnimationFrame];
            _voiceAnimationImageView.image=[UIImage imageNamed:@"wechatvoice3"];
            _voiceAnimationImageView.animationImages = [NSArray arrayWithObjects:[UIImage imageNamed:@"wechatvoice3"],[UIImage imageNamed:@"wechatvoice3_1"],[UIImage imageNamed:@"wechatvoice3_0"],[UIImage imageNamed:@"wechatvoice3_1"],[UIImage imageNamed:@"wechatvoice3"],nil];
            
            _voiceAnimationImageView.animationDuration = 1;
            _voiceAnimationImageView.transform =messageModel.messageSenderType == MessageSenderTypeMe ?  CGAffineTransformMakeRotation(M_PI) : CGAffineTransformMakeRotation(0);
            _voiceAnimationImageView.animationRepeatCount = -1;
            break;
        case MessageTypeImage:
            _imageImageView.hidden = NO;
            _imageImageView.frame = [messageModel imageFrame];
            _imageImageView.image = messageModel.imageSmall;
            CGSize imageSize = [messageModel.imageSmall imageShowSize];
            UIImageView *imageViewMask = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:_messageModel.messageSenderType == MessageSenderTypeMe ? @"me" :@"other"] stretchableImageWithLeftCapWidth:20 topCapHeight:40]];
            imageViewMask.frame = CGRectMake(0, 0, imageSize.width, imageSize.height);
            _imageImageView.layer.mask = imageViewMask.layer;
            
            break;
//        default:
//            break;
    }
    


}

-(void) setQuestionContext
{
    NSString *strQuestion = @"";
    for (int i = 0; i <  _messageModel.arrQuestion.count; i++)
     {
        NSString *strTemp = [NSString stringWithFormat:@"%d. %@\n", i+1, _messageModel.arrQuestion[i]];
        strQuestion = [strQuestion stringByAppendingString:strTemp];
     }
    
    strQuestion = [strQuestion stringByAppendingString:@"请输入对应数字，查询相关问题。"];
    
    CGSize size = [self labelAutoCalculateRectWith:strQuestion Font:[UIFont fontWithName:FONT_REGULAR size:MessageFontSize] MaxSize:CGSizeMake(0.8*SCREEN_WIDTH- 60, MAXFLOAT)];
    
    // 问题设置为主色调
    NSMutableAttributedString *LZString = [[NSMutableAttributedString alloc]initWithString:strQuestion];
    for (int i = 0; i <  _messageModel.arrQuestion.count; i++)
     {
        NSRange rang = [strQuestion rangeOfString:_messageModel.arrQuestion[i]];
        [LZString addAttribute:NSForegroundColorAttributeName value:[ResourceManager mainColor] range:rang];
        //[LZString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:rang];
     }
    
    
    
    
    CGRect timeRect = [_messageModel timeFrame];
    CGRect bubbleRect = [_messageModel bubbleFrame];
    
    CGRect questionTilteRect =  CGRectMake(65+10, timeRect.size.height + 10 +31 +5, bubbleRect.size.width - 35, size.height);
    _questionContextLabel.frame = questionTilteRect;
    _questionContextLabel.hidden = NO;
    _questionContextLabel.numberOfLines = 0;
    _questionContextLabel.attributedText = LZString;
    
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

- (void)prepareForReuse {
    [super prepareForReuse];
    
    //text voice image
    self.frame = CGRectMake(0, 0, AppFrameWidth, 44);
    _logoImageView.hidden = YES;
    _bubbleImageView.hidden = YES;
    _voiceImageView.hidden = YES;
    _messageLabel.hidden = YES;
    _timeLabel.hidden = YES;
    _imageImageView.hidden = YES;
    // 自己添加的UI控件，一定要预先隐藏
    _questionContextLabel.hidden = YES;
    _questionTilteLabel.hidden = YES;
    _questionViewFG.hidden = YES;
    
    
}

#pragma 长按事件
- (void)longPressBubbleView:(UILongPressGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        [self showMenuControllerInView:self bgView:sender.view];
    }
    
}
- (void)showMenuControllerInView:(CSMessageCell *)inView
                          bgView:(UIView *)supView
{
    [self becomeFirstResponder];
    
    CSMessageModel *messageModel=self.messageModel;
    
    UIMenuItem *copyTextItem1 = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(copyTextSender1:)];
    UIMenuItem *copyTextItem2 = [[UIMenuItem alloc] initWithTitle:@"保存到相册" action:@selector(copyTextSender2:)];
    UIMenuController *menu = [UIMenuController sharedMenuController];
    [menu setTargetRect:supView.frame inView:inView];
    [menu setArrowDirection:UIMenuControllerArrowDefault];
    if (messageModel.messageType==MessageTypeText)
    {
        [menu setMenuItems:@[copyTextItem1]];
    }
    else if (messageModel.messageType==MessageTypeImage)
    {
         [menu setMenuItems:@[copyTextItem2]];
    }
    else if(messageModel.messageType==MessageTypeVoice)
    {
    }
    
    
    
    
    [menu setMenuVisible:YES animated:YES];
    
}
#pragma mark 剪切板代理方法
-(BOOL)canBecomeFirstResponder {
    NSLog(@"%s",__FUNCTION__);
    return YES;
}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (action == @selector(copyTextSender1:)) {
        return true;
    } else  if (action == @selector(copyTextSender2:)) {
        return true;
    } else {
        return false;
    }
}
-(void)copyTextSender1:(id)sender {
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    if (self.messageModel.messageText.length > 0)
    {
        pasteboard.string = self.messageModel.messageText;
    }
}
-(void)copyTextSender2:(id)sender {
     UIImageWriteToSavedPhotosAlbum(self.imageImageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}



-(void)handleSingleTap2:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(messageCellSingleClickedWith:)])
    {
        [self.delegate messageCellSingleClickedWith:self];
    }
}
//开始录音动画
- (void)startVoiceAnimation
{
    [self.voiceAnimationImageView startAnimating];
}
//结束录音动画
- (void)stopVoiceAnimation
{
    [self.voiceAnimationImageView stopAnimating];
}

//保存到相册回调
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
