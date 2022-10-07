#import <Foundation/Foundation.h>
#import "UIKit/UIKit.h"

@interface MIOTablaDePronosticosMareas : UIView
- (MIOTablaDePronosticosMareas *)initWithData:(NSArray *)data tipo:(MIOZonaDePronostico)tipo;
@property (nonatomic, strong) UITableView *tablaDePronosticos;
@end