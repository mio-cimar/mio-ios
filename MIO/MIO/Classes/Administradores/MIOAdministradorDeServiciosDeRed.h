#import <Foundation/Foundation.h>

@interface MIOAdministradorDeServiciosDeRed : NSObject
+ (MIOAdministradorDeServiciosDeRed *)instanciaCompartida;

- (void)obtenerDatosDePronosticoLocalParaZona:(MIOZonaDePronostico)zona bloqueExito:(void (^)())exito bloqueFallo:(void (^)())fallo;
@end