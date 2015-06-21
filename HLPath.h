//
//  HLPath.h
//  highest
//
//  Created by Giorgio Nobile on 09/06/11.
//  Copyright 2011 ZeroNetAPP. All rights reserved.
//

#import <Foundation/Foundation.h>


//proprietà per interagire con l'interfaccia

//shared metod per l'accesso a questo oggetto



@interface HLPath : NSObject {
    
}

//oggetto singleton
+ (HLPath *)shared;

- (NSString *)dataFilePath;
- (NSString *)dataGpxFilePath;
- (NSString *)dataCsvFilePath;
- (NSString *)meterFilePath;
- (NSString *)kmlFilePath;
- (NSString *)csvFilePath;
- (NSString *)kmlExport;
- (NSString *)gpxExport;
- (NSString *)csvExport;
- (NSString *)gpxFilePath;
- (NSString *)lockFilePath;
- (NSString *)emptyFilePath;

//one shoot
- (NSString *)logArray;

- (NSString *)dataFilePath_1;
- (NSString *)dataGpxFilePath_1;
- (NSString *)dataCsvFilePath_1;
- (NSString *)meterFilePath_1;
- (NSString *)kmlFilePath_1;
- (NSString *)csvFilePath_1;
- (NSString *)kmlExport_1;
- (NSString *)gpxExport_1;
- (NSString *)csvExport_1;
- (NSString *)gpxFilePath_1;
//fine one shoot
- (NSString *)moveKmlPath;
- (NSString *)moveGpxPath;
- (NSString *)moveCsvPath;
- (NSString *)moveTrackPath;
- (NSString *)moveAltPath;

-(void)generateKmlToShare;
-(void)generateGpxToShare;
-(void)generateCsvToShare;




@end
