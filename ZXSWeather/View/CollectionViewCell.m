//
//  CollectionViewCell.m
//  TextCollectionView
//
//  Created by Z_小圣 on 15/11/30.
//  Copyright © 2015年 Z_小圣. All rights reserved.
//

#import "CollectionViewCell.h"
#define kWidth100 CGRectGetWidth(self.contentView.frame)/3.45
#define kWidth30  CGRectGetWidth(self.contentView.frame)/11.5
#define kFont15   CGRectGetWidth(self.contentView.frame)/23
#define kFont13   CGRectGetWidth(self.contentView.frame)/26.538
@implementation CollectionViewCell
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self z_setupViews];
    }
    return self;
}
-(void)z_setupViews
{
    self.layer.cornerRadius=10;
    UILabel * midline=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMidX(self.contentView.frame), (CGRectGetHeight(self.contentView.frame)/5), 1, (CGRectGetHeight(self.contentView.frame)/9)*5)];
    midline.backgroundColor=[UIColor grayColor];
    [self.contentView addSubview:midline];
    UIImageView *day=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.contentView.frame)/8, CGRectGetHeight(self.contentView.frame)/9, kWidth30, kWidth30)];
   // day.backgroundColor=[UIColor redColor];
    day.image=[UIImage imageNamed:@"baitiantianqi.png"];
    [self.contentView addSubview:day];
    UIImageView *night=[[UIImageView alloc]initWithFrame:CGRectMake((CGRectGetWidth(self.contentView.frame)/8)*7-kWidth30, (CGRectGetHeight(self.contentView.frame)/9), kWidth30, kWidth30)];
   // night.backgroundColor=[UIColor redColor];
    night.image=[UIImage imageNamed:@"yewantianqi.png"];
    [self.contentView addSubview:night];
    self.dateLabel=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMidX(self.contentView.frame)-70, CGRectGetHeight(self.contentView.frame)/35, 140, kWidth30)];
    //self.dateLabel.backgroundColor=[UIColor greenColor];
    self.dateLabel.textAlignment=NSTextAlignmentCenter;
    [self.contentView addSubview:self.dateLabel];
    UILabel *daylabel=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(day.frame), CGRectGetMinY(day.frame), 35, CGRectGetHeight(day.frame))];
   // daylabel.backgroundColor=[UIColor grayColor];
    daylabel.font=[UIFont systemFontOfSize:kFont15];
    daylabel.text=@"白天";
    [self.contentView addSubview:daylabel];
    UILabel *nightlabel=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(night.frame)-35, CGRectGetMinY(night.frame), 35, CGRectGetHeight(night.frame))];
   // nightlabel.backgroundColor=[UIColor grayColor];
    nightlabel.textAlignment=NSTextAlignmentRight;
    nightlabel.font=[UIFont systemFontOfSize:kFont15];
    nightlabel.text=@"夜晚";
    [self.contentView addSubview:nightlabel];
    
    self.addressLabel=[[UILabel alloc]init];
   // self.addressLabel.backgroundColor=[UIColor redColor];
    self.addressLabel.frame=CGRectMake(CGRectGetWidth(self.contentView.frame)/2-(kWidth100/2), CGRectGetMaxY(self.dateLabel.frame)+(CGRectGetWidth(self.contentView.frame)/69), kWidth100, kWidth30);
    self.addressLabel.font=[UIFont systemFontOfSize:kFont15];
    self.addressLabel.textAlignment=NSTextAlignmentCenter;
    [self.contentView addSubview:self.addressLabel];
    
    self.dayImageView=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMinX(day.frame)+5, CGRectGetMaxY(daylabel.frame)+10, kWidth100, kWidth100)];
    //self.dayImageView.backgroundColor=[UIColor blueColor];
    [self.contentView addSubview:self.dayImageView];
    
    self.nightImageView=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(night.frame)-(kWidth100+5), CGRectGetMinY(self.dayImageView.frame), kWidth100, kWidth100)];
    //self.nightImageView.backgroundColor=[UIColor blueColor];
    [self.contentView addSubview:self.nightImageView];
    
    self.dayWeatherLabel=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.dayImageView.frame)-20, CGRectGetMaxY(self.dayImageView.frame)+10, CGRectGetWidth(self.dayImageView.frame), kWidth30)];
    //self.dayWeatherLabel.backgroundColor=[UIColor redColor];
    self.dayWeatherLabel.textAlignment=NSTextAlignmentRight;
    self.dayWeatherLabel.font=[UIFont systemFontOfSize:kFont13];
    [self.contentView addSubview:self.dayWeatherLabel];
    
    self.nightWeatherLabel=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.nightImageView.frame)-CGRectGetWidth(self.nightImageView.frame)+20, CGRectGetMaxY(self.dayImageView.frame)+10, CGRectGetWidth(self.dayImageView.frame), kWidth30)];
    //self.nightWeatherLabel.backgroundColor=[UIColor redColor];
    self.nightWeatherLabel.font=[UIFont systemFontOfSize:kFont13];
    [self.contentView addSubview:self.nightWeatherLabel];
    
    self.dayTemperatureLabel=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.dayWeatherLabel.frame), CGRectGetMaxY(self.dayWeatherLabel.frame)+10, CGRectGetWidth(self.dayWeatherLabel.frame), CGRectGetHeight(self.dayWeatherLabel.frame))];
    //self.dayTemperatureLabel.backgroundColor=[UIColor yellowColor];
    self.dayTemperatureLabel.textAlignment=NSTextAlignmentRight;
    self.dayTemperatureLabel.font=[UIFont systemFontOfSize:kFont13];
    [self.contentView addSubview:self.dayTemperatureLabel];
    
    self.nightTemperatureLabel=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.nightWeatherLabel.frame), CGRectGetMaxY(self.nightWeatherLabel.frame)+10, CGRectGetWidth(self.nightWeatherLabel.frame), CGRectGetHeight(self.nightWeatherLabel.frame))];
    //self.nightTemperatureLabel.backgroundColor=[UIColor yellowColor];
    self.nightTemperatureLabel.font=[UIFont systemFontOfSize:kFont13];
    [self.contentView addSubview:self.nightTemperatureLabel];
    
    self.day_wind_direction=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.dayTemperatureLabel.frame), CGRectGetMaxY(self.dayTemperatureLabel.frame)+10, CGRectGetWidth(self.dayTemperatureLabel.frame), CGRectGetHeight(self.dayTemperatureLabel.frame))];
    //self.day_wind_direction.backgroundColor=[UIColor redColor];
    self.day_wind_direction.textAlignment=NSTextAlignmentRight;
    self.day_wind_direction.font=[UIFont systemFontOfSize:kFont13];
    [self.contentView addSubview:self.day_wind_direction];
    
    self.night_wind_direction=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.nightTemperatureLabel.frame), CGRectGetMaxY(self.nightTemperatureLabel.frame)+10, CGRectGetWidth(self.nightTemperatureLabel.frame), CGRectGetHeight(self.nightTemperatureLabel.frame))];
    //self.night_wind_direction.backgroundColor=[UIColor redColor];
    self.night_wind_direction.font=[UIFont systemFontOfSize:kFont13];
    [self.contentView addSubview:self.night_wind_direction];
    
    self.day_wind_power=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.day_wind_direction.frame), CGRectGetMaxY(self.day_wind_direction.frame)+10, CGRectGetWidth(self.day_wind_direction.frame), CGRectGetHeight(self.day_wind_direction.frame))];
    //self.day_wind_power.backgroundColor=[UIColor blueColor];
    self.day_wind_power.textAlignment=NSTextAlignmentRight;
    self.day_wind_power.font=[UIFont systemFontOfSize:kFont13];
    [self.contentView addSubview:self.day_wind_power];
    
    self.night_wind_power=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.night_wind_direction.frame), CGRectGetMaxY(self.night_wind_direction.frame)+10, CGRectGetWidth(self.night_wind_direction.frame), CGRectGetHeight(self.night_wind_direction.frame))];
    //self.night_wind_power.backgroundColor=[UIColor blueColor];
    self.night_wind_power.font=[UIFont systemFontOfSize:kFont13];
    [self.contentView addSubview:self.night_wind_power];
    
    self.sun_begin_end=[[UILabel alloc]initWithFrame:CGRectMake((CGRectGetWidth(self.contentView.frame)/2)-kWidth100, CGRectGetMaxY(self.night_wind_power.frame)+(CGRectGetWidth(self.contentView.frame)/15), (kWidth100*2), kWidth30)];
   // self.sun_begin_end.backgroundColor=[UIColor yellowColor];
    self.sun_begin_end.textAlignment=NSTextAlignmentCenter;
    self.sun_begin_end.font=[UIFont systemFontOfSize:kFont15];
    [self.contentView addSubview:self.sun_begin_end];
    
    
    UIImageView *dayweather=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.dayWeatherLabel.frame)+(CGRectGetWidth(self.contentView.frame)/69), CGRectGetMinY(self.dayWeatherLabel.frame), kWidth30, kWidth30)];
    //dayweather.backgroundColor=[UIColor orangeColor];
    dayweather.image=[UIImage imageNamed:@"baitiantianqi"];
    [self.contentView addSubview:dayweather];
    
    UIImageView *nightweather=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.nightWeatherLabel.frame)-(CGRectGetWidth(self.contentView.frame)/9.8571), CGRectGetMinY(self.nightWeatherLabel.frame), kWidth30, kWidth30)];
    //nightweather.backgroundColor=[UIColor orangeColor];
    nightweather.image=[UIImage imageNamed:@"yewantianqi.png"];
    [self.contentView addSubview:nightweather];
    
    UIImageView *dayTemperature=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.dayTemperatureLabel.frame)+(CGRectGetWidth(self.contentView.frame)/69), CGRectGetMinY(self.dayTemperatureLabel.frame), kWidth30, kWidth30)];
    //dayTemperature.backgroundColor=[UIColor orangeColor];
    dayTemperature.image=[UIImage imageNamed:@"wendu.png"];
    [self.contentView addSubview:dayTemperature];
    
    UIImageView *nightTemperature=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.nightTemperatureLabel.frame)-(CGRectGetWidth(self.contentView.frame)/9.8571), CGRectGetMinY(self.nightTemperatureLabel.frame), kWidth30, kWidth30)];
    //nightTemperature.backgroundColor=[UIColor orangeColor];
    nightTemperature.image=[UIImage imageNamed:@"wendu.png"];
    [self.contentView addSubview:nightTemperature];
    
    UIImageView *dayfengxiang=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.day_wind_direction.frame)+(CGRectGetWidth(self.contentView.frame)/69), CGRectGetMinY(self.day_wind_direction.frame), kWidth30, kWidth30)];
   // dayfengxiang.backgroundColor=[UIColor orangeColor];
    dayfengxiang.image=[UIImage imageNamed:@"fengxiang.png"];
    [self.contentView addSubview:dayfengxiang];
    
    UIImageView *nightfengxiang=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.night_wind_direction.frame)-(CGRectGetWidth(self.contentView.frame)/9.8571), CGRectGetMinY(self.night_wind_direction.frame), kWidth30, kWidth30)];
   // nightfengxiang.backgroundColor=[UIColor orangeColor];
    nightfengxiang.image=[UIImage imageNamed:@"fengxiang.png"];
    [self.contentView addSubview:nightfengxiang];
    
    UIImageView *dayfengli=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.day_wind_power.frame)+(CGRectGetWidth(self.contentView.frame)/69), CGRectGetMinY(self.day_wind_power.frame), kWidth30, kWidth30)];
    //dayfengli.backgroundColor=[UIColor orangeColor];
    dayfengli.image=[UIImage imageNamed:@"fengli.png"];
    [self.contentView addSubview:dayfengli];
    
    UIImageView *nightfengli=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.night_wind_power.frame)-(CGRectGetWidth(self.contentView.frame)/9.8571), CGRectGetMinY(self.night_wind_power.frame), kWidth30, kWidth30)];
    //nightfengli.backgroundColor=[UIColor orangeColor];
    nightfengli.image=[UIImage imageNamed:@"fengli.png"];
    [self.contentView addSubview:nightfengli];
    
    
    
    
}
@end
