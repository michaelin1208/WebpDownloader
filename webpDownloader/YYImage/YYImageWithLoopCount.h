//
//  YYImageWithLoopCount.h
//  Paopao8_AppStore
//
//  Created by Michaelin on 2017/9/22.
//

#import "YYImage.h"
@interface YYImageWithLoopCount : YYImage
@property (nonatomic, assign) NSUInteger animatedImageLoopCount;

- (NSUInteger)animatedImageFrameCount;

@end


