//
//  YJTableView.m
//  YJTableView
//
//  Created by yejian on 2019/1/8.
//  Copyright © 2019年 yejian. All rights reserved.
//

#import "YJTableView.h"

#import "YJTableViewCell.h"

@interface YJTableView()<UIScrollViewDelegate>
{
    CGFloat _kViewH;
    CGFloat _kViewW;
    CGFloat _kCellH;        //cell默认高度
    CGFloat _kSectionH;     //默认section高度
    NSInteger _showNum;     //一页能展示的cell数量
    
    NSInteger _totSection;
    CGFloat _off_y;
    NSInteger _flag;
    
    NSMutableArray *_cellCacheAry;          //cell缓存池
    NSMutableArray *_cellShowAry;           //cell展示数组

}
@end

@implementation YJTableView

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initData];
        [self initUI];
    }
    
    return self;
}

- (void)initData
{
    _kViewH = self.frame.size.height;
    _kViewW = self.frame.size.width;
    _kCellH = 44;
    _kSectionH = 40;
    _showNum = (int)(_kSectionH/_kCellH) + 1;
    
    _off_y = 0;
    _totSection = 1;        //默认为1
    
    self.delegate = self;
    self.scrollEnabled = YES;
    self.userInteractionEnabled = YES;
    self.contentSize = CGSizeMake(0, _kViewH + 1);
    self.showsVerticalScrollIndicator = YES;
    
    _cellCacheAry = [[NSMutableArray alloc]init];
    _cellShowAry = [[NSMutableArray alloc]init];
}

- (void)initUI
{
    if (_YJDataSource && [_YJDataSource respondsToSelector:@selector(YJ_numberOfSectionsInTableView:)]) {
        _totSection = [_YJDataSource YJ_numberOfSectionsInTableView:self];
    }
    
    NSInteger count = 0;
    //组
    for (int s = 0; s < _totSection; s++) {
        NSInteger cellRow = 0;
        if (_YJDataSource && [_YJDataSource respondsToSelector:@selector(YJ_tableView:numberOfRowsInSection:)]) {
            cellRow = [_YJDataSource YJ_tableView:self numberOfRowsInSection:s];
        }
        
        //排
        for (int r = 0; r < cellRow; r ++) {
            YJTableViewCell *cell = nil;
            if (_YJDataSource && [_YJDataSource respondsToSelector:@selector(YJ_tableView:cellForRowAtIndexPath:)]) {
                cell = [_YJDataSource YJ_tableView:self cellForRowAtIndexPath:[NSIndexPath indexPathForRow:r inSection:s]];
                cell.frame = CGRectMake(0, count * _kCellH, _kViewW, _kCellH);
                cell.indexPath = [NSIndexPath indexPathForRow:r inSection:s];
                
                cell.btn.indexPath = cell.indexPath;
                [cell.btn addTarget:self action:@selector(didClickBtn:) forControlEvents:UIControlEventTouchUpInside];
                
                self.contentSize = CGSizeMake(0, CGRectGetMaxY(cell.frame));
                [self addSubview:cell];
                [self sendSubviewToBack:cell];
                [_cellShowAry addObject:cell];
                
                count ++;
                if (CGRectGetMinY(cell.frame) > _kViewH) {
                    return;
                }
            }
        }
    }
    
}

- (void)reloadData
{
    [self initUI];
}

- (YJTableViewCell *)dequeueReusableCellWithIdentifier:(NSString *)indetify
{
    for (YJTableViewCell *cell in _cellCacheAry) {
        if ([cell.indetify isEqual:indetify]) {
            [_cellCacheAry removeObject:cell];
            return cell;
        }
    }
    return nil;
}

- (void)didClickBtn:(YJButton *)btn
{
    if (_YJDelegate && [_YJDelegate respondsToSelector:@selector(YJ_tableView:didSelectRowAtIndexPath:)]) {
        [_YJDelegate YJ_tableView:self didSelectRowAtIndexPath:btn.indexPath];
    }
}

- (void)reduceTableViewCell
{
//    NSLog(@"%s",__FUNCTION__);
    
    YJTableViewCell *firstCell = [_cellShowAry firstObject];
    NSInteger firstSection = firstCell.indexPath.section;
    NSInteger firstRow = firstCell.indexPath.row;
    
    NSIndexPath *indexPath = nil;
    if (firstRow == 0) {
        if (firstSection != 0) {
            for (NSInteger s = firstSection - 1; s >= 0; s --) {
                if (_YJDataSource && [_YJDataSource respondsToSelector:@selector(YJ_tableView:numberOfRowsInSection:)]) {
                    NSInteger totRow = [_YJDataSource YJ_tableView:self numberOfRowsInSection:s];
                    if (totRow > 0) {
                        indexPath = [NSIndexPath indexPathForRow:totRow - 1 inSection:s];
                        break;
                    }
                }
            }
        }else
        {
            return;
        }
    }else
    {
        indexPath = [NSIndexPath indexPathForRow:firstRow - 1 inSection:firstSection];
    }
    
    YJTableViewCell *beforCell = nil;
    if (_YJDataSource && [_YJDataSource respondsToSelector:@selector(YJ_tableView:cellForRowAtIndexPath:)]) {
        beforCell = [_YJDataSource YJ_tableView:self cellForRowAtIndexPath:indexPath];
        beforCell.frame = CGRectMake(0, CGRectGetMinY(firstCell.frame) - _kCellH, _kViewW, _kCellH);
        beforCell.indexPath = indexPath;
        beforCell.btn.indexPath = indexPath;
        beforCell.backgroundColor = [UIColor greenColor];
        
        YJTableViewCell *lastCell = [_cellShowAry lastObject];
        [_cellCacheAry addObject:lastCell];
        [_cellShowAry removeObject:lastCell];
        [_cellShowAry insertObject:beforCell atIndex:0];
        
        [self addSubview:beforCell];
    }

}

- (void)addTableViewCell
{
//    NSLog(@"%s",__FUNCTION__);
    
    YJTableViewCell *lastCell = [_cellShowAry lastObject];
    NSInteger lastSection = lastCell.indexPath.section;
    NSInteger lastRow = lastCell.indexPath.row;
    
    NSInteger totRow = 0;
    if (_YJDataSource && [_YJDataSource respondsToSelector:@selector(YJ_tableView:numberOfRowsInSection:)])
    {
        totRow = [_YJDataSource YJ_tableView:self numberOfRowsInSection:lastSection];
    }else
    {
        return; //此代理必须实现,不实现我就崩溃
    }
    NSIndexPath *indexPath = nil;
    if (lastRow < totRow - 1) {
        indexPath = [NSIndexPath indexPathForRow:lastRow + 1 inSection:lastSection];
    }else if (lastSection < _totSection)   //下一组
    {
        for (NSInteger i = lastSection + 1; i < _totSection; i++) {
            NSInteger nextRow = [_YJDataSource YJ_tableView:self numberOfRowsInSection:lastSection];
            if (nextRow > 0) {
                indexPath = [NSIndexPath indexPathForRow:0 inSection:i];
                break;
            }
        }
    }
    if (indexPath == nil) {//为nil表示已到底
        return ;
    }
    
    YJTableViewCell *nextCell = nil;
    if (_YJDataSource && [_YJDataSource respondsToSelector:@selector(YJ_tableView:cellForRowAtIndexPath:)])
    {
        nextCell = [_YJDataSource YJ_tableView:self cellForRowAtIndexPath:indexPath];
        nextCell.frame = CGRectMake(0, CGRectGetMaxY(lastCell.frame), _kViewW, _kCellH);
        nextCell.indexPath = indexPath;
        nextCell.btn.indexPath = indexPath;
        nextCell.backgroundColor = [UIColor orangeColor];
        self.contentSize = CGSizeMake(0, CGRectGetMaxY(nextCell.frame));
        
        YJTableViewCell *firstCell = [_cellShowAry firstObject];
        [_cellCacheAry addObject:firstCell];
        [_cellShowAry removeObject:firstCell];
        [_cellShowAry addObject:nextCell];
        
        [self addSubview:nextCell];
        [self sendSubviewToBack:nextCell];
    }
}

#pragma mark - scrollView 代理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _flag = 0;
    if (_off_y < scrollView.contentOffset.y) {
        _flag = 1;  //上
        NSLog(@"上");
    }else if(_off_y > scrollView.contentOffset.y)
    {
        _flag = 2;  //下
        NSLog(@"下");
    }else
    {
        NSLog(@"其他");
    }
    
    _off_y = scrollView.contentOffset.y;
    YJTableViewCell *firstCell = [_cellShowAry firstObject];
    YJTableViewCell *lastCell = [_cellShowAry lastObject];
    
    CGFloat lastHigh = lastCell.frame.origin.y - _off_y;
    CGFloat firstHigh = firstCell.frame.origin.y - _off_y;
    
    switch (_flag) {
        case 1:
        {
            if (lastHigh < _kViewH) {
                [self addTableViewCell];
            }
        }
            break;
        case 2:
        {
            if(firstHigh > 0)
            {
                [self reduceTableViewCell];
            }

        }
        default:
            break;
    }
    NSLog(@"%f",firstHigh);
}

@end
