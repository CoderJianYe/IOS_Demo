//
//  ViewController.m
//  YJTableView
//
//  Created by yejian on 2019/1/8.
//  Copyright © 2019年 yejian. All rights reserved.
//

#import "ViewController.h"

#import "YJTableView.h"

@interface ViewController ()<YJTableViewDelegate,YJTableViewDataSource>
{
    YJTableView *_tableView;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _tableView = [[YJTableView alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 64) style:UITableViewStylePlain];
    _tableView.YJDelegate = self;
    _tableView.YJDataSource = self;
    [_tableView reloadData];
    [self.view addSubview:_tableView];

}

#pragma mark - YJTableView 代理
- (NSInteger)YJ_numberOfSectionsInTableView:(YJTableView *)tableView
{
    return 3;
}

- (NSInteger)YJ_tableView:(YJTableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 30;
}

- (YJTableViewCell *)YJ_tableView:(YJTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indetify = @"cell";
    YJTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indetify];
    if (cell == nil) {
        cell = [[YJTableViewCell alloc] initWithStyle:0 reuseIdentifier:indetify];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"section:%ld,row:%ld",indexPath.section,indexPath.row];
    return cell;
}

- (void)YJ_tableView:(YJTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"section:%ld,row:%ld",indexPath.section,indexPath.row);
}


@end
