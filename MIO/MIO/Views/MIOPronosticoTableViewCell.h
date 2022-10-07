#import <UIKit/UIKit.h>

static NSString *MIOIdentificadorDeCeldaDePronostico = @"MIOIdentificadorDeCeldaDePronostico";

@interface MIOPronosticoTableViewCell : UITableViewCell
- (void)establecerPronosticoConDatos:(NSArray *)datos;
@end