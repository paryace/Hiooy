//
//  SettingSwitchCell.m
//  KKMYForU
//
//  Created by 黄磊 on 13-11-20.
//  Copyright (c) 2013年 黄磊. All rights reserved.
//

#import "SettingSwitchCell.h"

@implementation SettingSwitchCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = (SettingSwitchCell *)[[[NSBundle mainBundle] loadNibNamed:@"SettingSwitchCell"
                                                            owner:self
                                                          options:nil] objectAtIndex:0];
    if (self)
    {
        // Initialization code
        //        [self setBackgroundColor:[UIColor blackColor]];
        [self SettingSwitchCell];
    }
    return self;
}

- (void)SettingSwitchCell
{
    [self.lblTitle setTextColor:[UIColor colorFromHexRGB:@"3b3b3b"]];
    if (__CUR_IOS_VERSION < __IPHONE_7_0)
    {
        [self resizeSubView];
    }
}

// 低于iOS7的系统需调此方法调整视图大小
- (void)resizeSubView
{
    CGRect titleRect = _lblTitle.frame;
    titleRect.origin.x = titleRect.origin.x - 5;
    [_lblTitle setFrame:titleRect];
    
    CGRect switchRect = _switchNotice.frame;
    switchRect.origin.x = switchRect.origin.x - 40;
    [_switchNotice setFrame:switchRect];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    //    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)configWithData:(id)data
{
    NSDictionary *aDic = (NSDictionary *)data;
    [_lblTitle setText:[aDic objectForKey:@"cellTitle"]];
    NSString *subTitle = [aDic objectForKey:@"subTitleUpdate"];
    if (subTitle == nil)
    {
        subTitle = [aDic objectForKey:@"subTitle"];
    }
    
    
    
//    // 设置是否是new
//    if ([aDic objectForKey:@"isNew"] && [[aDic objectForKey:@"isNew"] boolValue] == YES)
//    {
//        CGRect imgRect = _imgviewNew.frame;
//        CGRect titleRect = _lblTitle.frame;
//        CGSize size = textSizeWithFont(_lblTitle.text, _lblTitle.font);
//        imgRect.origin.x = titleRect.origin.x + size.width + 10;
//        [_imgviewNew setFrame:imgRect];
//        [_imgviewNew setHidden:NO];
//    }
//    else
//    {
//        [_imgviewNew setHidden:YES];
//    }
    
    
}

@end
