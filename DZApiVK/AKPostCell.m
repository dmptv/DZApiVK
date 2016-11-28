//
//  AKPostCell.m
//  DZApiVK
//
//  Created by Kanat A on 20/10/16.
//  Copyright © 2016 ak. All rights reserved.
//

#import "AKPostCell.h"

@implementation AKPostCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
//    self.postAuthorImageView.layer.cornerRadius = self.postAuthorImageView.frame.size.height/2;
//    self.postAuthorImageView.clipsToBounds = YES;
    
    
}

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
    }
    
    return self;
}


+ (CGFloat) heightForText:(NSString*) text {
    
    CGFloat offset = 5.0;
    // из сториборда
    
    // если изменится высота то фонт тоже. поэтому мы его пересчитаем
    UIFont* font = [UIFont systemFontOfSize:15.f];
    
    NSShadow* shadow = [[NSShadow alloc] init];
    shadow.shadowOffset = CGSizeMake(0, -1); // как в сториборде
    shadow.shadowBlurRadius = 0.5f;
    
    // перенос и выравнивание
    NSMutableParagraphStyle* paragraph = [[NSMutableParagraphStyle alloc] init];
    [paragraph setLineBreakMode:NSLineBreakByWordWrapping];
    [paragraph setAlignment:NSTextAlignmentCenter];
    
    NSDictionary* attributes =
    [NSDictionary dictionaryWithObjectsAndKeys:
     font,      NSFontAttributeName,
     paragraph, NSParagraphStyleAttributeName,
     shadow,    NSShadowAttributeName, nil];
    // запомнить NSFontAttributeName чтобы находить остальные атрибуты
    
    // NSStringDrawing - ключевой игрок
    CGRect rect =
    [text boundingRectWithSize:CGSizeMake(320 - 2 * offset, CGFLOAT_MAX)
                       options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                    attributes:attributes
                       context:nil];
    // (320 - 2 * offset) это ширине лэйбла из сториборд
    // CGFLOAT_MAX - высота любая.
    // boundingRectWithSize - вернет нам прмоугольник ограниченный этим сайз.
    
    
    // вернем высоту
    return CGRectGetHeight(rect) + 2 * offset;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
