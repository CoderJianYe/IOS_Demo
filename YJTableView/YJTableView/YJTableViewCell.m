//
//  YJTableViewCell.m
//  YJTableView
//
//  Created by yejian on 2019/1/8.
//  Copyright © 2019年 yejian. All rights reserved.
//

#import "YJTableViewCell.h"


@implementation YJButton


@end


@interface YJTableViewCell()<NSCopying>
{
    UILabel *_bottomLine;
}
@end

@implementation YJTableViewCell

- (id)initWithStyle:(NSInteger)style reuseIdentifier:(NSString *)indetify
{
    self = [super init];
    if (self) {
        _indetify = indetify;
        
        [self initUI];
    }
    
    return self;
}

- (void)initUI
{
    _btn = [[YJButton alloc]init];
    [self addSubview:_btn];
    
    _textLabel = [[UILabel alloc]init];
    _textLabel.font = [UIFont systemFontOfSize:14];
    _textLabel.textColor = [UIColor blackColor];
    [self addSubview:_textLabel];
    
    _bottomLine = [[UILabel alloc]init];
    _bottomLine.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:_bottomLine];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    _btn.frame = self.bounds;
    _textLabel.frame = CGRectMake(15, 0, frame.size.width - 15, frame.size.height);
    _bottomLine.frame = CGRectMake(15, frame.size.height - 0.7, frame.size.width - 15, 0.7);
}

- (id)copyWithZone:(NSZone *)zone {
    YJTableViewCell *cell = [[[self class] allocWithZone:zone] init];
    cell.textLabel = self.textLabel;
    cell.indetify  = self.indetify;
    cell.indexPath = self.indexPath;
    cell.btn = self.btn;
    
    return cell;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
