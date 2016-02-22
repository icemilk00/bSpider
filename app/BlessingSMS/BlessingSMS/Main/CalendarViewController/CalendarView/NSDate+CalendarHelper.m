//
//  NSDate+CalendarHelper.m
//  CalendarDemo
//
//  Created by hp on 16/2/6.
//  Copyright © 2016年 hxp. All rights reserved.
//

#import "NSDate+CalendarHelper.h"

#define Weekdays @[@"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六"]
#define ChineseMonths @[@"正月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月",@"九月", @"十月", @"冬月", @"腊月"]
#define ChineseDays @[@"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八", @"初九", @"初十",@"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"二十", @"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十"]

@implementation NSDate (CalendarHelper)

/*
 *  获取日期所在月有多少天
 */
- (NSUInteger)numberOfDaysInCurrentMonth
{
    return [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:self].length;
}


/*
 *  获取日期所在月的第一天
 */
-(NSDate *)firstDayInCurrentMonth
{
    NSDate *startDate = nil;
    BOOL ok = [[NSCalendar currentCalendar] rangeOfUnit:NSMonthCalendarUnit startDate:&startDate interval:nil forDate:self];
    NSAssert1(ok, @"Failed to calculate the first day of the month based on %@", self);
    return startDate;
}

/*
 *  获取日期所在月的最后一天
 */
- (NSDate *)lastDayOfCurrentMonth
{
    NSCalendarUnit calendarUnit = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:calendarUnit fromDate:self];
    dateComponents.day = [self numberOfDaysInCurrentMonth];
    return [[NSCalendar currentCalendar] dateFromComponents:dateComponents];
}

/*
 *  获取日期在所在月是周几
 */
- (NSUInteger)weeklyOrdinality
{
    return [[NSCalendar currentCalendar] ordinalityOfUnit:NSDayCalendarUnit inUnit:NSWeekCalendarUnit forDate:self];
}

/*
 *  获取日期在所在月是周几的字符串
 */
- (NSString *)weeklyOrdinalityStr
{
    return Weekdays[[[NSCalendar currentCalendar] ordinalityOfUnit:NSDayCalendarUnit inUnit:NSWeekCalendarUnit forDate:self] - 1];
}

/*
 *  获取日期在所在月是几号
 */
- (NSUInteger)monthlyOrdinality
{
    return [[NSCalendar currentCalendar] ordinalityOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:self];
}

/*
 *  获取日期所在月有几周
 */
- (NSUInteger)numberOfWeeksInCurrentMonth
{
    NSUInteger weekday = [[self firstDayInCurrentMonth] weeklyOrdinality];
    
    NSUInteger days = [self numberOfDaysInCurrentMonth];
    NSUInteger weeks = 0;
    
    if (weekday > 1) {
        weeks += 1, days -= (7 - weekday + 1);
    }
    
    weeks += days / 7;
    weeks += (days % 7 > 0) ? 1 : 0;
    
    return weeks;
}

/*
 *  获取日ccccccc个月有几天
 */
- (NSDate *)dayInThePreviousMonth
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = -1;
    return [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
}

/*
 *  获取日期所在月的下一个月有几天
 */
- (NSDate *)dayInTheFollowingMonth
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = 1;
    return [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
}

- (NSDateComponents *)YMDComponents
{
    return [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:self];
}

/*
 *  获取日期在所在月的哪一个周内
 */
- (NSUInteger)weekNumberInCurrentMonth
{
    NSUInteger firstDay = [[self firstDayInCurrentMonth] weeklyOrdinality];
    NSUInteger weeksCount = [self numberOfWeeksInCurrentMonth];
    NSUInteger weekNumber = 0;
    
    NSDateComponents *c = [self YMDComponents];
    NSUInteger startIndex = [[self firstDayInCurrentMonth] monthlyOrdinality];
    NSUInteger endIndex = startIndex + (7 - firstDay);
    for (int i = 0; i < weeksCount; ++i) {
        if (c.day >= startIndex && c.day <= endIndex) {
            weekNumber = i;
            break;
        }
        startIndex = endIndex + 1;
        endIndex = startIndex + 6;
    }
    
    return weekNumber;
}

/*
 *  获取date当天的农历
 */
- (NSString *)chineseCalendar{
    NSString *day;
    NSCalendar *chineseCalendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierChinese];
    NSDateComponents *components = [chineseCalendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:self];
    if (components.day == 1) {
        day = ChineseMonths[components.month - 1];
    } else {
        day = ChineseDays[components.day - 1];
    }
    
    return day;
}

-(NSString *)getChineseHoliday
{
    NSDictionary *chineseHolidayDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                        @"春节", @"1|1",
                                        @"元宵节", @"1|15",
                                        @"端午节", @"5|5",
                                        @"七夕", @"7|7",
                                        @"中元节", @"7|15",
                                        @"中秋节", @"8|15",
                                        @"重阳节", @"9|9",
                                        @"腊八节", @"12|8",
                                        @"小年", @"12|24",
                                        @"除夕", @"12|30",
                                        nil];
    
    NSCalendar *chineseCalendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierChinese];
    NSDateComponents *components = [chineseCalendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:self];
    
    return [chineseHolidayDict objectForKey:[NSString stringWithFormat:@"%ld|%ld",(long)components.month,(long)components.day]];
}

-(NSString *)getWorldHoliday
{
    NSCalendarUnit calendarUnit = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSDateComponents *components = [[NSCalendar currentCalendar] components:calendarUnit fromDate:self];
    
    NSString *monthDay;
    NSUInteger aMonth = components.month;
    NSUInteger aDay = components.day;
    if(aMonth<10 && aDay<10)
    {
        monthDay=[NSString stringWithFormat:@"0%lu0%lu",(unsigned long)aMonth,(unsigned long)aDay] ;
    }
    else if(aMonth<10 && aDay>9)
    {
        monthDay=[NSString stringWithFormat:@"0%lu%lu",(unsigned long)aMonth,(unsigned long)aDay] ;
    }
    else if(aMonth>9 && aDay<10)
    {
        monthDay=[NSString stringWithFormat:@"%lu0%lu",(unsigned long)aMonth,(unsigned long)aDay] ;
    }
    else
    {
        monthDay=[NSString stringWithFormat:@"%lu%lu",(unsigned long)aMonth,(unsigned long)aDay] ;
    }
    
    NSMutableDictionary *dict= [[NSMutableDictionary alloc] init];
    [dict setObject:@"元旦" forKey:@"0101"];
//    [dict setObject:@"中国第13亿人口日" forKey:@"0106"];
//    [dict setObject:@"周恩来逝世纪念日" forKey:@"0108"];
//    [dict setObject:@"释迦如来成道日" forKey:@"0115"];
//    [dict setObject:@"列宁逝世纪念日 国际声援南非日 弥勒佛诞辰" forKey:@"0121"];
    [dict setObject:@"世界湿地日" forKey:@"0202"];
//    [dict setObject:@"二七大罢工纪念日" forKey:@"0207"];
    [dict setObject:@"国际气象节" forKey:@"0210"];
    [dict setObject:@"情人节" forKey:@"0214"];
//    [dict setObject:@"中国12亿人口日" forKey:@"0215"];
//    [dict setObject:@"邓小平逝世纪念日" forKey:@"0219"];
//    [dict setObject:@"国际母语日 反对殖民制度斗争日" forKey:@"0221"];
//    [dict setObject:@"苗族芦笙节" forKey:@"0222"];
//    [dict setObject:@"第三世界青年日" forKey:@"0224"];
//    [dict setObject:@"世界居住条件调查日" forKey:@"0228"];
    [dict setObject:@"国际海豹日" forKey:@"0301"];
    [dict setObject:@"全国爱耳日" forKey:@"0303"];
//    [dict setObject:@"学雷锋纪念日 中国青年志愿者服务日" forKey:@"0305"];
    [dict setObject:@"妇女节" forKey:@"0308"];
//    [dict setObject:@"保护母亲河日" forKey:@"0309"];
//    [dict setObject:@"国际尊严尊敬日" forKey:@"0311"];
    [dict setObject:@"白色情人节" forKey:@"0314"];
    [dict setObject:@"消费者权益日" forKey:@"0315"];
//    [dict setObject:@"手拉手情系贫困小伙伴全国统一行动日" forKey:@"0316"];
//    [dict setObject:@"中国国医节 国际航海日 爱尔兰圣帕特里克节" forKey:@"0317"];
//    [dict setObject:@"全国科技人才活动日" forKey:@"0318"];
//    [dict setObject:@"世界森林日 消除种族歧视国际日 世界儿歌日 世界睡眠日" forKey:@"0321"];
//    [dict setObject:@"世界水日" forKey:@"0322"];
    [dict setObject:@"世界气象日" forKey:@"0323"];
//    [dict setObject:@"世界防治结核病日" forKey:@"0324"];
//    [dict setObject:@"全国中小学生安全教育日" forKey:@"0325"];
//    [dict setObject:@"中国黄花岗七十二烈士殉难纪念" forKey:@"0329"];
//    [dict setObject:@"巴勒斯坦国土日" forKey:@"0330"];
    [dict setObject:@"愚人节" forKey:@"0401"];
//    [dict setObject:@"国际儿童图书日" forKey:@"0402"];
    [dict setObject:@"世界卫生日" forKey:@"0407"];
//    [dict setObject:@"世界帕金森病日" forKey:@"0411"];
//    [dict setObject:@"全国企业家活动日" forKey:@"0421"];
//    [dict setObject:@"世界地球日 世界法律日" forKey:@"0422"];
//    [dict setObject:@"世界图书和版权日" forKey:@"0423"];
//    [dict setObject:@"亚非新闻工作者日 世界青年反对殖民主义日" forKey:@"0424"];
//    [dict setObject:@"全国预防接种宣传日" forKey:@"0425"];
//    [dict setObject:@"世界知识产权日" forKey:@"0426"];
//    [dict setObject:@"世界交通安全反思日" forKey:@"0430"];
    [dict setObject:@"国际劳动节" forKey:@"0501"];
//    [dict setObject:@"世界哮喘日 世界新闻自由日" forKey:@"0503"];
    [dict setObject:@"五四青年节" forKey:@"0504"];
//    [dict setObject:@"碘缺乏病防治日 日本男孩节" forKey:@"0505"];
//    [dict setObject:@"世界红十字日" forKey:@"0508"];
    [dict setObject:@"国际护士节" forKey:@"0512"];
//    [dict setObject:@"国际家庭日" forKey:@"0515"];
//    [dict setObject:@"国际电信日" forKey:@"0517"];
//    [dict setObject:@"国际博物馆日" forKey:@"0518"];
//    [dict setObject:@"全国学生营养日 全国母乳喂养宣传日" forKey:@"0520"];
//    [dict setObject:@"国际牛奶日" forKey:@"0523"];
//    [dict setObject:@"世界向人体条件挑战日" forKey:@"0526"];
//    [dict setObject:@"中国“五卅”运动纪念日" forKey:@"0530"];
    [dict setObject:@"世界无烟日" forKey:@"0531"];
    [dict setObject:@"国际儿童节" forKey:@"0601"];
//    [dict setObject:@"世界环境保护日" forKey:@"0605"];
//    [dict setObject:@"世界献血者日" forKey:@"0614"];
//    [dict setObject:@"防治荒漠化和干旱日" forKey:@"0617"];
//    [dict setObject:@"世界难民日" forKey:@"0620"];
//    [dict setObject:@"中国儿童慈善活动日" forKey:@"0622"];
//    [dict setObject:@"国际奥林匹克日" forKey:@"0623"];
//    [dict setObject:@"全国土地日" forKey:@"0625"];
//    [dict setObject:@"国际禁毒日 国际宪章日 禁止药物滥用和非法贩运国际日 支援酷刑受害者国际日" forKey:@"0626"];
//    [dict setObject:@"世界青年联欢节" forKey:@"0630"];
    [dict setObject:@"建党节" forKey:@"0701"];
//    [dict setObject:@"国际体育记者日" forKey:@"0702"];
//    [dict setObject:@"朱德逝世纪念日" forKey:@"0706"];
//    [dict setObject:@"抗日战争纪念日" forKey:@"0707"];
//    [dict setObject:@"世界人口日 中国航海日" forKey:@"0711"];
//    [dict setObject:@"世界语创立日" forKey:@"0726"];
//    [dict setObject:@"第一次世界大战爆发" forKey:@"0728"];
//    [dict setObject:@"非洲妇女日" forKey:@"0730"];
    [dict setObject:@"建军节" forKey:@"0801"];
//    [dict setObject:@"恩格斯逝世纪念日" forKey:@"0805"];
//    [dict setObject:@"国际电影节" forKey:@"0806"];
//    [dict setObject:@"中国男子节" forKey:@"0808"];
    [dict setObject:@"国际青年节" forKey:@"0812"];
//    [dict setObject:@"国际左撇子日" forKey:@"0813"];
//    [dict setObject:@"抗日战争胜利纪念" forKey:@"0815"];
//    [dict setObject:@"全国律师咨询日" forKey:@"0826"];
//    [dict setObject:@"日本签署无条件投降书日" forKey:@"0902"];
//    [dict setObject:@"中国抗日战争胜利纪念日" forKey:@"0903"];
//    [dict setObject:@"瑞士萨永中世纪节" forKey:@"0905"];
//    [dict setObject:@"帕瓦罗蒂去世" forKey:@"0906"];
//    [dict setObject:@"国际扫盲日 国际新闻工作者日" forKey:@"0908"];
//    [dict setObject:@"毛泽东逝世纪念日" forKey:@"0909"];
    [dict setObject:@"中国教师节" forKey:@"0910"];
//    [dict setObject:@"世界清洁地球日" forKey:@"0914"];
//    [dict setObject:@"国际臭氧层保护日 中国脑健康日" forKey:@"0916"];
//    [dict setObject:@"九·一八事变纪念日" forKey:@"0918"];
//    [dict setObject:@"国际爱牙日" forKey:@"0920"];
//    [dict setObject:@"世界停火日 预防世界老年性痴呆宣传日" forKey:@"0921"];
//    [dict setObject:@"世界旅游日" forKey:@"0927"];
//    [dict setObject:@"孔子诞辰" forKey:@"0928"];
//    [dict setObject:@"国际翻译日" forKey:@"0930"];
    [dict setObject:@"国庆节" forKey:@"1001"];
//    [dict setObject:@"国际和平与民主自由斗争日" forKey:@"1002"];
//    [dict setObject:@"世界动物日" forKey:@"1004"];
//    [dict setObject:@"国际教师节" forKey:@"1005"];
//    [dict setObject:@"中国老年节" forKey:@"1006"];
//    [dict setObject:@"全国高血压日 世界视觉日" forKey:@"1008"];
//    [dict setObject:@"世界邮政日 万国邮联日" forKey:@"1009"];
//    [dict setObject:@"辛亥革命纪念日 世界精神卫生日 世界居室卫生日" forKey:@"1010"];
//    [dict setObject:@"世界保健日 国际教师节 中国少年先锋队诞辰日 世界保健日" forKey:@"1013"];
//    [dict setObject:@"世界标准日" forKey:@"1014"];
//    [dict setObject:@"国际盲人节(白手杖节)" forKey:@"1015"];
//    [dict setObject:@"世界粮食日" forKey:@"1016"];
//    [dict setObject:@"世界消除贫困日" forKey:@"1017"];
//    [dict setObject:@"世界骨质疏松日" forKey:@"1020"];
//    [dict setObject:@"世界传统医药日" forKey:@"1022"];
//    [dict setObject:@"联合国日 世界发展新闻日" forKey:@"1024"];
//    [dict setObject:@"中国男性健康日" forKey:@"1028"];
    [dict setObject:@"万圣节" forKey:@"1031"];
//    [dict setObject:@"达摩祖师圣诞" forKey:@"1102"];
//    [dict setObject:@"柴科夫斯基逝世悼念日" forKey:@"1106"];
//    [dict setObject:@"十月社会主义革命纪念日" forKey:@"1107"];
    [dict setObject:@"中国记者日" forKey:@"1108"];
//    [dict setObject:@"全国消防安全宣传教育日" forKey:@"1109"];
//    [dict setObject:@"世界青年节" forKey:@"1110"];
    [dict setObject:@"光棍节" forKey:@"1111"];
//    [dict setObject:@"孙中山诞辰纪念日" forKey:@"1112"];
//    [dict setObject:@"世界糖尿病日" forKey:@"1114"];
//    [dict setObject:@"泰国大象节" forKey:@"1115"];
//    [dict setObject:@"国际大学生节 世界学生节 世界戒烟日" forKey:@"1117"];
    [dict setObject:@"世界儿童日" forKey:@"1120"];
//    [dict setObject:@"世界问候日 世界电视日" forKey:@"1121"];
//    [dict setObject:@"国际声援巴勒斯坦人民国际日" forKey:@"1129"];
//    [dict setObject:@"世界艾滋病日" forKey:@"1201"];
//    [dict setObject:@"废除一切形式奴役世界日" forKey:@"1202"];
//    [dict setObject:@"世界残疾人日" forKey:@"1203"];
//    [dict setObject:@"全国法制宣传日" forKey:@"1204"];
//    [dict setObject:@"国际经济和社会发展志愿人员日 世界弱能人士日" forKey:@"1205"];
//    [dict setObject:@"国际民航日" forKey:@"1207"];
//    [dict setObject:@"国际儿童电视日" forKey:@"1208"];
//    [dict setObject:@"世界足球日 一二·九运动纪念日" forKey:@"1209"];
//    [dict setObject:@"世界人权日" forKey:@"1210"];
//    [dict setObject:@"世界防止哮喘日" forKey:@"1211"];
//    [dict setObject:@"西安事变纪念日" forKey:@"1212"];
//    [dict setObject:@"南京大屠杀纪念日" forKey:@"1213"];
//    [dict setObject:@"国际儿童广播电视节" forKey:@"1214"];
//    [dict setObject:@"世界强化免疫日" forKey:@"1215"];
//    [dict setObject:@"澳门回归纪念" forKey:@"1220"];
//    [dict setObject:@"国际篮球日" forKey:@"1221"];
    [dict setObject:@"平安夜" forKey:@"1224"];
    [dict setObject:@"圣诞节" forKey:@"1225"];
//    [dict setObject:@"毛泽东诞辰纪念日 节礼日" forKey:@"1226"];
//    [dict setObject:@"国际生物多样性日" forKey:@"1229"];
    
    return [dict objectForKey:monthDay];
}

@end
