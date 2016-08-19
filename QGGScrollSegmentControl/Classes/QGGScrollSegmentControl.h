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

@property (nonatomic, assign) NSUInteger selectedIndex; //setter操作会触发 QGGScrollSegmentControlDelegate qgg_scrollSegmentControl:didSelectedAtIndex:preSelectIndex:

- (instancetype)initWithFrame:(CGRect)frame
                   dataSrouce:(id<QGGScrollSegmentControlDataSource>)dataSource
                     delegate:(id<QGGScrollSegmentControlDelegate>)delegate;


@end





//=============Protocol========================

@protocol QGGScrollSegmentControlDataSource <NSObject>

@required
/**
 *  返回item数
 *
 */
- (NSUInteger)qgg_numberOfItemsInScrollSegmentControl:(QGGScrollSegmentControl*)scrollSegmentControl;

/**
 * 返回index下item view
 *
 */
- (UIView*)qgg_scrollSegmentControl:(QGGScrollSegmentControl*)scrollSegmentControl
                                      itemViewAtIndex:(NSUInteger)index;


@optional
- (UIView*)qgg_selectUnderLineInScrollSegmentControl:(QGGScrollSegmentControl*)scrollSegmentControl;

@end


@protocol QGGScrollSegmentControlDelegate <NSObject>

/**
 *  <#Description#>
 *
 *  @param scrollSegmentControl <#scrollSegmentControl description#>
 *  @param index                <#index description#>
 *  @param preSelectIndex       <#preSelectIndex description#>
 */
- (void)qgg_scrollSegmentControl:(QGGScrollSegmentControl*)scrollSegmentControl
              didSelectedAtIndex:(NSUInteger)index
                  preSelectIndex:(NSUInteger)preSelectIndex;

/**
 *  <#Description#>
 *
 *  @param scrollSegmentControl <#scrollSegmentControl description#>
 *  @param index                <#index description#>
 *
 *  @return <#return value description#>
 */
- (CGSize)qgg_scrollSegmentControl:(QGGScrollSegmentControl*)scrollSegmentControl
                   itemSizeAtIndex:(NSUInteger)index;

- (CGRect)qgg_selectUnderLineFrameWithItemFrame:(CGRect)itemFrame atIndex:(NSUInteger)index;

@end