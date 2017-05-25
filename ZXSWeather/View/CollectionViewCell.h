//
//  CollectionViewCell.h
//  TextCollectionView
//
//  Created by Z_小圣 on 15/11/30.
//  Copyright © 2015年 Z_小圣. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionViewCell : UICollectionViewCell
@property(strong,nonatomic)UILabel *addressLabel;//地区
@property(strong,nonatomic)UILabel *dateLabel;//日期
@property(strong,nonatomic)UIImageView *dayImageView;//白天图片
@property(strong,nonatomic)UIImageView *nightImageView;//夜晚图片
@property(strong,nonatomic)UILabel *dayTemperatureLabel;//白天气温
@property(strong,nonatomic)UILabel *nightTemperatureLabel;//夜晚气温
@property(strong,nonatomic)UILabel *dayWeatherLabel;//白天天气
@property(strong,nonatomic)UILabel *nightWeatherLabel;//夜晚天气
@property(strong,nonatomic)UILabel *day_wind_direction;//白天风向
@property(strong,nonatomic)UILabel *night_wind_direction;//夜晚风向
@property(strong,nonatomic)UILabel *day_wind_power;//白天风力
@property(strong,nonatomic)UILabel *night_wind_power;//夜晚风力
@property(strong,nonatomic)UILabel *sun_begin_end;//日出日落


@end
