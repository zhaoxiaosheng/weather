//
//  Model.h
//  TextCollectionView
//
//  Created by Z_小圣 on 15/12/1.
//  Copyright © 2015年 Z_小圣. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Model : NSObject
@property(copy,nonatomic)NSString *day;//日期
@property(copy,nonatomic)NSString *day_air_temperature;//白天温度
@property(copy,nonatomic)NSString *day_weather;//白天天气
@property(copy,nonatomic)NSString *day_weather_pic;//白天图片
@property(copy,nonatomic)NSString *day_wind_direction;//白天风向
@property(copy,nonatomic)NSString *day_wind_power;//白天风力
@property(copy,nonatomic)NSString *night_air_temperature;//夜晚温度
@property(copy,nonatomic)NSString *night_weather;//夜晚天气
@property(copy,nonatomic)NSString *night_weather_pic;//夜晚图片
@property(copy,nonatomic)NSString *night_wind_direction;//夜晚风向
@property(copy,nonatomic)NSString *night_wind_power;//夜晚风力
@property(copy,nonatomic)NSString *sun_begin_end;//日出日落
@property(copy,nonatomic)NSString *weekday;//星期几（返回的数字）
@end
