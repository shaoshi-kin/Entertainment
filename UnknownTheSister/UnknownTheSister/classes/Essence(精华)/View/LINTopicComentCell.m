//
//  LINTopicComentCell.m
//  UnknownTheSister
//
//  Created by king少诗 on 2016/11/7.
//  Copyright © 2016年 kingshaoshi. All rights reserved.
//

#import "LINTopicComentCell.h"
#import "LINTopicComment.h"
#import "LINTopicUser.h"

@interface LINTopicComentCell ()

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *voiceButton;
@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;



@end

@implementation LINTopicComentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mainCellBackground"]];
}

- (void)setTopicComment:(LINTopicComment *)topicComment {
    _topicComment = topicComment;
    
    // 如果有语音评论就显示voiceButton
    if (topicComment.voiceuri.length) {
        self.voiceButton.hidden = NO;
        [self.voiceButton setTitle:[NSString stringWithFormat:@"%zd''", topicComment.voicetime] forState:UIControlStateNormal];
    } else {
        self.voiceButton.hidden = YES;
    }
    
    [self.profileImageView setHeader:topicComment.user.profile_image];
    self.contentLabel.text = topicComment.content;
    self.userNameLabel.text = topicComment.user.username;
    self.likeCountLabel.text = [NSString stringWithFormat:@"%zd", topicComment.like_count];
    
    if ([topicComment.user.sex isEqualToString:LINUserSexMale]) {
        self.sexImageView.image = [UIImage imageNamed:@"Profile_manIcon"];
    } else {
        self.sexImageView.image = [UIImage imageNamed:@"Profile_womanIcon"];
    }
}

@end
