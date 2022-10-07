#import <UIKit/UIKit.h>

static NSString *MIOIdentificadorDeCeldaDeMenuPrincipal = @"MIOIdentificadorDeCeldaDeMenuPrincipal";

@interface MIOMenuPrincipalTableViewCell : UITableViewCell
- (void)textoDeCelda:(NSString *)texto;
- (void)iconoDeCeldaConNombreDeImagen:(NSString *)nombre;
- (void)establecerSeleccionDeCelda:(BOOL)estado;
@property BOOL opcionesAbiertas;
@property BOOL tieneSubOpciones;
@end
