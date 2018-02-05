//
//  YYImageWithLoopCount.m
//  Paopao8_AppStore
//
//  Created by Michaelin on 2017/9/22.
//

#import "YYImageWithLoopCount.h"
@implementation YYImageWithLoopCount {
    BOOL _loopCountChanged;
    NSUInteger _animatedImageLoopCount;
}

- (NSUInteger)animatedImageLoopCount {
    return _loopCountChanged ? _animatedImageLoopCount : [super animatedImageLoopCount];
}

- (void)setAnimatedImageLoopCount:(NSUInteger)animatedImageLoopCount {
    _loopCountChanged = YES;
    _animatedImageLoopCount = animatedImageLoopCount;
}

@end
