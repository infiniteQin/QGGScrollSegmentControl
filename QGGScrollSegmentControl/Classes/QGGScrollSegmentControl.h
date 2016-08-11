//
//  QGGScrollSegmentControl.h
//  Pods
//
//  Created by taizi on 16/8/11.
//
//

#import <UIKit/UIKit.h>

@protocol QGGScrollSegmentControlDataSource;
@protocol QGGScrollSegmentControlDelegate;


@interface QGGScrollSegmentControl : UICollectionView

//@property (nonatomic,assign,readonly) id<QGGScrollSegmentControlDataSource> dataSource;

@property (nonatomic, assign) NSUInteger selectedIndex;

- (instancetype)initWithFrame:(CGRect)frame
                   dataSrouce:(id<QGGScrollSegmentControlDataSource>)dataSource
                     delegate:(id<QGGScrollSegmentControlDelegate>)delegate;

- (CGRect)titleLabelFrameAtIndex:(NSUInteger)index;

@end

@protocol QGGScrollSegmentControlDataSource <NSObject>

@required
- (NSUInteger)qgg_numberOfItemsInScrollSegmentControl:(QGGScrollSegmentControl*)scrollSegmentControl;
- (UIView*)qgg_scrollSegmentControl:(QGGScrollSegmentControl*)scrollSegmentControl
                                      itemViewAtIndex:(NSUInteger)index;


@optional
- (UIView*)qgg_selectUnderLineInScrollSegmentControl:(QGGScrollSegmentControl*)scrollSegmentControl;

@end


@protocol QGGScrollSegmentControlDelegate <NSObject>

- (void)qgg_scrollSegmentControl:(QGGScrollSegmentControl*)scrollSegmentControl
              didSelectedAtIndex:(NSUInteger)index
                  preSelectIndex:(NSUInteger)preSelectIndex;

- (CGSize)qgg_scrollSegmentControl:(QGGScrollSegmentControl*)scrollSegmentControl
                   itemSizeAtIndex:(NSUInteger)index;

- (CGRect)qgg_selectUnderLineFrameWithItemFrame:(CGRect)itemFrame atIndex:(NSUInteger)index;

@end