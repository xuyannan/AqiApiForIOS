//
//  AqiAPI.h
//  PM25
//
//  Created by xu yannan on 13-3-11.
//  Copyright (c) 2013年 BlueTiger. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AqiAPI : NSObject {
    NSArray *fileds;
}
@property (strong, nonatomic) NSString *appkey;

/*
 * 初始化
 * appkey:pm25.in分配的appkey
 */
-(AqiAPI *) initWithAppkey:(NSString *)appkey;

/*
 * 获取某城市美使馆/领事馆数据
 * city:城市名，如"北京"
 * return:一个数组，包含最近一组每小时更新一次的监测数据。
 */
-(NSArray *) getUsemAqiDataForCity:(NSString *)city;

/*
 * 获取某城市所有监测点的最新数据，不包括美使馆数据
 * city:城市名，可以是"北京"或"beijing"
 * return:一个数组，包含所有监测点的数据 。最后一项为平均值。
 */
-(NSArray *) getChineseAqiDataForCity:(NSString *)city;

/*
 * 判断一个城市是否有美国大使馆/领事馆数据
 */
-(bool) isUsemDataSupportedForCity:(NSString *)city;

/*
 * 获取所有美国大使馆/领事馆数据支持的城市
 */
-(NSArray *) usemDataSupportedCities;

/*
 * 获取城市列表
 */
-(NSArray *) supportedCities;
@end

