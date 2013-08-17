//
//  BabyCommentCell.m
//  BabyinFamily
//
//  Created by 范艳春 on 13-7-11.
//
//

#import <QuartzCore/QuartzCore.h>
#import "BabyCommentCell.h"

@implementation BabyCommentCell

@synthesize headImageView = _headImageView;
@synthesize commentPersonNameLabel= _commentPersonNameLabel;
@synthesize timeLabel = _timeLabel;
@synthesize commentContent = _commentContent;
@synthesize cellHeight = _cellHeight;
@synthesize user =_user;
@synthesize weiboDetailCommentInfo = _weiboDetailCommentInfo;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UIView * view = [self createCellView];
        [self.contentView addSubview:view];
    }
    return self;
}

-(UIView *)createCellView
{
    UIView * bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
    _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 42, 42)];
    [_headImageView.layer  setMasksToBounds:YES];
    [_headImageView.layer  setMasksToBounds:YES];
    [_headImageView.layer setCornerRadius:5];
    
    _commentPersonNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_headImageView.frame.origin.x + _headImageView.frame.size.width + 6, _headImageView.frame.origin.y, 160, 21)];
    _commentPersonNameLabel.text = @"user";
    _commentPersonNameLabel.textAlignment = UITextAlignmentLeft;
    _commentPersonNameLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    _commentPersonNameLabel.lineBreakMode = UILineBreakModeHeadTruncation;
    
    _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(_commentPersonNameLabel.frame.origin.x + _commentPersonNameLabel.frame.size.width , _commentPersonNameLabel.frame.origin.y , 90, 16)];
    _timeLabel.text = @"10分钟";
    _timeLabel.textAlignment = UITextAlignmentRight;
    _timeLabel.font = [UIFont systemFontOfSize:10.0f];
    _timeLabel.lineBreakMode = UILineBreakModeHeadTruncation;
    
    _commentContent  = [[UILabel alloc]initWithFrame:CGRectMake(_headImageView.frame.origin.x + _headImageView.frame.size.width + 6, _commentPersonNameLabel.frame.origin.y + _commentPersonNameLabel.frame.size.height + 4, 226, 0)];
    _commentContent.textAlignment = UITextAlignmentLeft;
    _commentContent.font = [UIFont systemFontOfSize:14.0f];
    _commentContent.lineBreakMode = UILineBreakModeCharacterWrap;
    _commentContent.numberOfLines = 0;
    
    [bgView addSubview:_headImageView];
    [bgView addSubview:_commentPersonNameLabel];
    [bgView addSubview:_timeLabel];
    [bgView addSubview:_commentContent];
    
    return bgView;

}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)setWeiboDetailCommentInfo:(Comment *)comment
{
    if (_weiboDetailCommentInfo!=comment) {
        [_weiboDetailCommentInfo release];
        _weiboDetailCommentInfo = [comment retain];
    
        [_headImageView setImageWithURL:[NSURL URLWithString:comment.user.profileLargeImageUrl] placeholderImage:[UIImage imageNamed:@"weibo.bundle/WeiboImages/touxiang_40x40.png"]];
        
        _commentPersonNameLabel.text = comment.user.name;
        _commentContent.text = comment.text;
        
        _timeLabel.text = comment.timestamp;
    }
}

-(void)dealloc
{
    [_headImageView release];
    [_commentPersonNameLabel release];
    [_timeLabel release];
    [super dealloc];
}
@end

