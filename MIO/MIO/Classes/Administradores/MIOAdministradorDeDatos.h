#import <Foundation/Foundation.h>

@interface MIOAdministradorDeDatos : NSObject
+ (MIOAdministradorDeDatos *)instanciaCompartida;
- (NSArray *)obtenerDatosDePronosticoConTipo:(MIOZonaDePronostico)zona;
- (void) procesarPronosticosLocales;
@end
