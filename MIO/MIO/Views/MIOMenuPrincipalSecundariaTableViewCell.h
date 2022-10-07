#import <UIKit/UIKit.h>

static NSString *MIOIdentificadorDeCeldaSecundariaDeMenuPrincipal = @"MIOIdentificadorDeCeldaSecundariaDeMenuPrincipal";

@interface MIOMenuPrincipalSecundariaTableViewCell : UITableViewCell
- (void)textoDeCelda:(NSString *)texto;
- (void)establecerSeleccionDeCelda:(BOOL)estado;
@end