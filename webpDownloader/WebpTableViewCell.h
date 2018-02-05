//
//  CLAVRaterTableViewCell.h
//  Paopao8
//
//  Created by admin on 2016/11/8.
//
//

#import <UIKit/UIKit.h>
#import "YYImage.h"

@interface WebpTableViewCell : UITableViewCell
@property(nonatomic,weak) IBOutlet YYAnimatedImageView *webpImageView;
@property(nonatomic,weak) IBOutlet UILabel *webpNameLabel;

@end
