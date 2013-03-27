//
//  AqiAPI.m
//  PM25
//
//  Created by xu yannan on 13-3-11.
//  Copyright (c) 2013年 BlueTiger. All rights reserved.
//

#import "AqiAPI.h"
#import "DDXMLDocument.h"

@implementation AqiAPI {
    NSDictionary *apiUrls;
    NSDictionary *usemUrls; // 美使馆/领事馆api地址
    NSArray *suppertedCities;
}


-(AqiAPI *) initWithAppkey:(NSString *)appkey{
    if (self = [super init]) {
        fileds = @[@"aqi"
                      , @"area"
                      , @"co"
                      , @"co_24h"
                      , @"no2"
                      , @"no2_24h"
                      , @"o3"
                      , @"o3_24h"
                      , @"o3_8h"
                      , @"o3_8h_24h"
                      , @"pm10"
                      , @"pm10_24h"
                      , @"pm2_5"
                      , @"pm2_5_24h"
                      , @"position_name"
                      , @"primary_pollutant"
                      , @"quality"
                      , @"so2"
                      , @"so2_24h"
                      , @"station_code"
                      , @"time_point"];
        
        
        suppertedCities = @[@"保定",@"北京",@"沧州",@"常州",@"长春",@"长沙",@"成都",@"承德",@"大连",@"东莞",@"佛山",@"福州",@"广州",@"贵阳",@"哈尔滨",@"海口",@"邯郸",@"杭州",@"合肥",@"衡水",@"呼和浩特",@"湖州",@"淮安",@"惠州",@"济南",@"嘉兴",@"江门",@"金华",@"昆明",@"拉萨",@"兰州",@"廊坊",@"丽水",@"连云港",@"南昌",@"南京",@"南宁",@"南通",@"宁波",@"秦皇岛",@"青岛",@"衢州",@"厦门",@"上海",@"绍兴",@"沈阳",@"深圳",@"石家庄",@"苏州",@"宿迁",@"台州",@"太原",@"泰州",@"唐山",@"天津",@"温州",@"乌鲁木齐",@"无锡",@"武汉",@"西安",@"西宁",@"邢台",@"徐州",@"盐城",@"扬州",@"银川",@"张家口",@"肇庆",@"镇江",@"郑州",@"中山",@"重庆",@"舟山",@"珠海"];
        /*
        NSArray *a = [suppertedCities sortedArrayUsingComparator:^(id a, id b){
            NSString *u1 = (NSString *)a;
            NSString *u2 = (NSString *)b;
            return [u1 localizedCompare:u2];
        }];
        NSLog(@"%@", [a componentsJoinedByString:@","]);
        */
        NSLog(@"%d", [suppertedCities count]);
        apiUrls = [[NSDictionary alloc]initWithObjectsAndKeys:
            [NSURL URLWithString:@"http://pm25.in/api/querys.json"], @"supported_cities",
            @"http://pm25.in/api/querys/pm2_5.json", @"pm25",
            @"http://pm25.in/api/querys/aqi_details.json", @"aqi",
            nil];
        
        NSURL *beijingUrl = [NSURL URLWithString:@"http://aqi.cutefool.net/beijing"];
        NSURL *guangzhouUrl = [NSURL URLWithString:@"http://aqi.cutefool.net/guangzhou"];
        NSURL *shanghaiUrl = [NSURL URLWithString:@"http://aqi.cutefool.net/shanghai"];
        NSURL *chengduUrl = [NSURL URLWithString:@"http://aqi.cutefool.net/chengdu"];
        
        usemUrls = [[NSDictionary alloc]initWithObjectsAndKeys:beijingUrl, @"北京",guangzhouUrl, @"广州", shanghaiUrl, @"上海", chengduUrl, @"成都", nil];
        
        self.appkey = appkey;
    }
    return self;
}


-(NSArray *)getChineseAqiDataForCity:(NSString *)city {
    if (![suppertedCities containsObject:city]) {
        NSLog(@"没有%@的数据", city);
        return nil;
    }
    
    NSMutableDictionary *dataCache = [[NSMutableDictionary alloc]init];
    NSMutableArray *result = [[NSMutableArray alloc]init];
    
    NSString *url_str = [[NSString alloc]initWithFormat:@"%@?token=%@&city=%@", [apiUrls objectForKey:@"pm25"], self.appkey, city ];
    
    NSURL *url = [NSURL URLWithString: [url_str stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
    [request setValue:@"text/json" forHTTPHeaderField:@"Content-Type"];
    NSHTTPURLResponse *response;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if(error != nil) {
        NSLog(@"net work error: %@", error);
        //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"sorry...无法加载气象站数据，请过会再试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        //[alert show];
        return nil;
    } else {
        NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        int count = 0;
        for (NSString *filed in fileds) {
            NSArray *data = [jsonData valueForKey:filed];
            [dataCache setValue:data forKey:filed];
            count = [data count];
        }
        for (int i = 0; i < count; i ++) {
            NSMutableDictionary *_res = [[NSMutableDictionary alloc]initWithCapacity:count];
            for ( NSString *key in dataCache) {
                NSArray *dataForKey = [dataCache objectForKey:key];
                NSString *s = [[NSString alloc]initWithFormat:@"%@", [dataForKey objectAtIndex:i]];
                [_res setValue:s forKey:key];
            }
            [result addObject:_res];
        }
        //~NSLog(@"%@", result);
    }
    return result;
}

//读取美领事馆数据
- (NSArray *)getUsemAqiDataForCity:(NSString *)city {
    if (!city) {
        return nil;
    }
    NSURL *url = [usemUrls objectForKey: city];
    
    if (!url) {
        NSLog(@"no USEM data for city: %@", city);
        return nil;
    }
    
    NSMutableArray *result = [[NSMutableArray alloc]init];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
    [request setValue:@"text/xml" forHTTPHeaderField:@"Content-Type"];
    NSHTTPURLResponse *response;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if(error != nil) {
        NSLog(@"net work error: %@", error);
        return nil;
    } else {
        DDXMLDocument *xmlDoc = [[DDXMLDocument alloc] initWithData:data options:0 error: &error];
        if (error) {
            NSLog(@"parse xml error: %@", [error localizedDescription]);
        }
        
        NSArray *resultNodes = [xmlDoc nodesForXPath:@"//Conc | //AQI | //Desc | //ReadingDateTime" error:&error];
        
        if ( ! resultNodes || [resultNodes count] == 0) {
            NSLog(@"%@ 无数据", city);
            return nil;
        }
        
        NSMutableArray *pmArray = [[NSMutableArray alloc] init];
        NSMutableArray *aqiArray = [[NSMutableArray alloc] init];
        NSMutableArray *descArray = [[NSMutableArray alloc] init];
        NSMutableArray *udpateArray = [[NSMutableArray alloc] init];
        //DDXMLElement *latestNode = resultNodes[0];
        
        for (DDXMLElement *resultElement in resultNodes) {
            NSString *name = [resultElement name];
            NSString *value = [resultElement stringValue];
            
            if ([name isEqualToString:@"Conc"]) {
                [pmArray addObject: value];
            } else if ([name isEqualToString:@"AQI"]) {
                [aqiArray addObject: value];
            } else if ([name isEqualToString:@"Desc"]) {
                //NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\(.*\\)" options:NSRegularExpressionCaseInsensitive error:nil];
                //NSString *modifiedValue = [regex stringByReplacingMatchesInString:value options:0 range:NSMakeRange(0, [value length]) withTemplate:@""];
                [descArray addObject: value];
            } else if ([name isEqualToString:@"ReadingDateTime"]) {
                [udpateArray addObject: value];
            }
        }
        NSInteger zero = [[[NSNumber alloc]initWithInt:0] integerValue];
        // 排除未读表的情况
        while ([aqiArray objectAtIndex:zero ] && [[aqiArray objectAtIndex:zero ] isEqualToString:@"-1"]) {
            [pmArray removeObjectAtIndex: zero];
            [descArray removeObjectAtIndex: zero];
            [udpateArray removeObjectAtIndex: zero];
            [aqiArray removeObjectAtIndex: zero];
        }
        
        int count = [pmArray count];
        for (int i = 0; i < count; i ++) {
            NSMutableDictionary *_res = [[NSMutableDictionary alloc]init];
            [_res setValue:[pmArray objectAtIndex:i ] forKey:@"pm2_5"];
            [_res setValue:[aqiArray objectAtIndex:i ] forKey:@"aqi"];
            [_res setValue:[descArray objectAtIndex:i ] forKey:@"quality"];
            [_res setValue:[udpateArray objectAtIndex:i ] forKey:@"time_point"];
            [result addObject:_res];
        }
        
    }
    return result;
}


-(bool)isUsemDataSupportedForCity:(NSString *)city {
    NSURL *url = [usemUrls objectForKey:city];
    if (url) {
        return YES;
    } else {
        return NO;
    }
}

-(NSArray *)usemDataSupportedCities {
    return [usemUrls allKeys];
}

-(NSArray *)supportedCities {
    NSURL *url = [apiUrls objectForKey:@"supported_cities"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
    [request setValue:@"text/json" forHTTPHeaderField:@"Content-Type"];
    NSHTTPURLResponse *response;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if(error != nil) {
        NSLog(@"net work error: %@", error);
        return suppertedCities; // 如果有网络错误的话，直接返回预定义的城市列表
    } else {
        NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSArray *_cities = [jsonData valueForKey:@"cities"];
        suppertedCities = _cities;
    }
    
    return suppertedCities;
}
@end
