//
//  YJTableView.h
//  YJTableView
//
//  Created by yejian on 2019/1/8.
//  Copyright © 2019年 yejian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YJTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN
@class YJTableView;

@protocol YJTableViewDelegate <NSObject>

- (void)YJ_tableView:(YJTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

- (CGFloat)YJ_tableView:(YJTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@protocol YJTableViewDataSource <NSObject>

@required
- (NSInteger)YJ_tableView:(YJTableView *)tableView numberOfRowsInSection:(NSInteger)section;

- (YJTableViewCell *)YJ_tableView:(YJTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@optional
- (NSInteger)YJ_numberOfSectionsInTableView:(YJTableView *)tableView;

@end

@interface YJTableView : UIScrollView

@property (nonatomic,assign)id<YJTableViewDelegate>YJDelegate;

@property (nonatomic,assign)id<YJTableViewDataSource>YJDataSource;

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style;

- (YJTableViewCell *)dequeueReusableCellWithIdentifier:(NSString *)indetify;

- (void)reloadData;

@end

NS_ASSUME_NONNULL_END
