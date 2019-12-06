//
//  YJTableViewCell.h
//  YJTableView
//
//  Created by yejian on 2019/1/8.
//  Copyright © 2019年 yejian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YJButton : UIButton

@property (nonatomic,strong)NSIndexPath *indexPath;

@end


@interface YJTableViewCell : UIView

@property (nonatomic,strong)UILabel *textLabel;

@property (nonatomic,strong)NSIndexPath *indexPath;

@property (nonatomic,strong)NSString *indetify;

@property (nonatomic,strong)YJButton *btn;

- (id)initWithStyle:(NSInteger)style reuseIdentifier:(NSString *)indetify;

@end


NS_ASSUME_NONNULL_END
