//
//  QGGViewController.m
//  QGGScrollSegmentControl
//
//  Created by taizi on 08/11/2016.
//  Copyright (c) 2016 taizi. All rights reserved.
//

#import "QGGViewController.h"
#import <QGGScrollSegmentControl/QGGScrollSegmentControl.h>
#import <Masonry/Masonry.h>

@interface QGGViewController ()<QGGScrollSegmentControlDataSource,QGGScrollSegmentControlDelegate>
@property (nonatomic, strong) NSArray<UIButton*> *itemsArr;
@end

@implementation QGGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    QGGScrollSegmentControl *seg = [[QGGScrollSegmentControl alloc] initWithFrame:CGRectZero dataSrouce:self delegate:self];
    seg.backgroundColor = [UIColor lightGrayColor];
    
    [self.view addSubview:seg];
    [seg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.height.mas_equalTo(44);
    }];
}

- (NSUInteger)qgg_numberOfItemsInScrollSegmentControl:(QGGScrollSegmentControl*)scrollSegmentControl{
    return self.itemsArr.count;
}
- (UIView*)qgg_scrollSegmentControl:(QGGScrollSegmentControl*)scrollSegmentControl
                                      itemViewAtIndex:(NSUInteger)index{
    UIButton *btn = self.itemsArr[index];
    btn.selected = (index == scrollSegmentControl.selectedIndex);
    return btn;
}

- (UIView*)qgg_selectUnderLineInScrollSegmentControl:(QGGScrollSegmentControl*)scrollSegmentControl {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor greenColor];
    return view;
}

- (CGSize)qgg_scrollSegmentControl:(QGGScrollSegmentControl *)scrollSegmentControl
                   itemSizeAtIndex:(NSUInteger)index {
    return CGSizeMake(80, 40);
}

- (CGRect)qgg_selectUnderLineFrameWithItemFrame:(CGRect)itemFrame atIndex:(NSUInteger)index {
    UIButton *btn = self.itemsArr[index];
    [btn.titleLabel sizeToFit];
    CGRect rect = CGRectMake(0, CGRectGetMaxY(itemFrame)-4, CGRectGetWidth(btn.titleLabel.bounds), 2);
    return rect;
}

-(void)qgg_scrollSegmentControl:(QGGScrollSegmentControl *)scrollSegmentControl
             didSelectedAtIndex:(NSUInteger)index
                 preSelectIndex:(NSUInteger)preSelectIndex{
    UIButton *preBtn = self.itemsArr[preSelectIndex];
    preBtn.selected = NO;
    UIButton *selectedBtn = self.itemsArr[index];
    selectedBtn.selected = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray<UIButton *> *)itemsArr {
    if (!_itemsArr) {
        _itemsArr = @[[self buttonWithTitle:@"111"],
                      [self buttonWithTitle:@"222"],
                      [self buttonWithTitle:@"333"],
                      [self buttonWithTitle:@"444"],
                      [self buttonWithTitle:@"555"],
                      [self buttonWithTitle:@"666"]];
    }
    return _itemsArr;
}

- (UIButton*)buttonWithTitle:(NSString*)title {
    UIButton *btn1 = [UIButton new];
    btn1.userInteractionEnabled = NO;
    [btn1 setTitle:title forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [btn1 setTitleColor:[UIColor greenColor] forState:UIControlStateSelected];
//    [btn1 sizeToFit];
    return btn1;
}

@end
