//
//  QGGScrollSegmentControl.m
//  Pods
//
//  Created by taizi on 16/8/11.
//
//

#import "QGGScrollSegmentControl.h"
#import "QGGScrollSegmentControlItemCell.h"
#import <Masonry/Masonry.h>

#define kDefaultItemSize (CGSizeMake(50, CGRectGetHeight(self.bounds)))

static NSString * const kQGGScrollSegmentControlItemCellIdentify = @"QGGScrollSegControlItemCell";

@interface QGGScrollSegmentControl ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, assign) id<QGGScrollSegmentControlDataSource> segDataSource;
@property (nonatomic, assign) id<QGGScrollSegmentControlDelegate>   segDelegate;
@property (nonatomic, strong) UIView                                *selectedUnderLine;
@end

@implementation QGGScrollSegmentControl

- (instancetype)initWithFrame:(CGRect)frame
                   dataSrouce:(id<QGGScrollSegmentControlDataSource>)dataSource
                     delegate:(id<QGGScrollSegmentControlDelegate>)delegate {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.sectionInset = UIEdgeInsetsZero;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self = [super initWithFrame:frame collectionViewLayout:flowLayout];
    if (self) {
        self.contentInset = UIEdgeInsetsZero;
        self.dataSource = self;
        self.delegate   = self;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        _segDataSource = dataSource;
        _segDelegate   = delegate;
        [self registerCells];
    }
    return self;
}

- (void)registerCells {
    [self registerClass:[QGGScrollSegmentControlItemCell class] forCellWithReuseIdentifier:kQGGScrollSegmentControlItemCellIdentify];
}


#pragma mark - UICollectionViewDatasource
- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    if ([self.segDataSource respondsToSelector:@selector(qgg_numberOfItemsInScrollSegmentControl:)]) {
        return [self.segDataSource qgg_numberOfItemsInScrollSegmentControl:self];
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    QGGScrollSegmentControlItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kQGGScrollSegmentControlItemCellIdentify forIndexPath:indexPath];
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if ([self.segDataSource respondsToSelector:@selector(qgg_scrollSegmentControl:itemViewAtIndex:)]) {
        UIView *itemView = [self.segDataSource qgg_scrollSegmentControl:self itemViewAtIndex:indexPath.row];
        cell.contentView.backgroundColor = [UIColor clearColor];
        if (itemView) {
            [cell.contentView addSubview:itemView];
            [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(UIEdgeInsetsZero);
            }];
        }
    }
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayour
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout*)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.segDelegate respondsToSelector:@selector(qgg_scrollSegmentControl:itemSizeAtIndex:)]) {
        return [self.segDelegate qgg_scrollSegmentControl:self itemSizeAtIndex:indexPath.row];
    }
    return kDefaultItemSize;
}

#pragma mark - UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self setSelectedIndex:indexPath.row];
}

-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.selectedIndex) {
        [self updateSelectedUnderLine:NO animated:NO];
    }
}


- (void)updateSelectedUnderLine:(BOOL)scrollToCenter animated:(BOOL)animated {
    if (!_selectedUnderLine && [self.segDataSource respondsToSelector:@selector(qgg_selectUnderLineInScrollSegmentControl:)]) {
        _selectedUnderLine = [self.segDataSource qgg_selectUnderLineInScrollSegmentControl:self];
    }
    
    if (!_selectedUnderLine) {
        return;
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.selectedIndex inSection:0];
    
    UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
    CGRect itemCellFrame = attributes.frame;
    
    CGRect targetFrame = CGRectZero;
    if ([self.segDelegate respondsToSelector:@selector(qgg_selectUnderLineFrameWithItemFrame:atIndex:)]) {
        targetFrame = [self.segDelegate qgg_selectUnderLineFrameWithItemFrame:itemCellFrame atIndex:self.selectedIndex];
    }
    if (targetFrame.size.width == 0 || targetFrame.size.height == 0) {
        _selectedUnderLine.hidden = YES;
    }else {
        _selectedUnderLine.hidden = NO;
    }
    
    if (_selectedUnderLine.superview != self) {
        [_selectedUnderLine willMoveToSuperview:self];
        [self addSubview:_selectedUnderLine];
        [_selectedUnderLine didMoveToSuperview];
    }
    targetFrame.origin.x = attributes.center.x - targetFrame.size.width/2;
    __weak typeof(self) wSelf = self;
    if (animated) {
        [UIView animateWithDuration:0.25 animations:^{
            wSelf.selectedUnderLine.frame = targetFrame;
        } completion:^(BOOL finished) {
            if (scrollToCenter) {
                [wSelf scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
            }
        }];
    }else {
        self.selectedUnderLine.frame = targetFrame;
    }
    
}

-(void)reloadData {

    [_selectedUnderLine removeFromSuperview];
    _selectedUnderLine = nil;

    if (_selectedIndex >= [self collectionView:self numberOfItemsInSection:0]) {
        _selectedIndex = 0;
    }
    [super reloadData];
}


-(void)setSelectedIndex:(NSUInteger)selectedIndex {
    if ([self.segDelegate respondsToSelector:@selector(qgg_scrollSegmentControl:didSelectedAtIndex: preSelectIndex:)]) {
        [self.segDelegate qgg_scrollSegmentControl:self
                                didSelectedAtIndex:selectedIndex
                                    preSelectIndex:_selectedIndex];
    }
    _selectedIndex = selectedIndex;
    [self updateSelectedUnderLine:YES animated:YES];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
