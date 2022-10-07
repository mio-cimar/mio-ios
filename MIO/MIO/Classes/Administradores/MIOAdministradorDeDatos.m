#import "MIOAdministradorDeDatos.h"
#import "MIOAdministradorDeServiciosDeRed.h"

typedef enum {
    MIOLLaveDePronostico_Time,
    MIOLLaveDePronostico_sig_wav_ht_surface,
    MIOLLaveDePronostico_max_wav_ht_surface,
    MIOLLaveDePronostico_peak_wav_dir_surface,
    MIOLLaveDePronostico_peak_wav_per_surface,
    MIOLLaveDePronostico_wnd_ucmp_height_above_ground,
    MIOLLaveDePronostico_wnd_vcmp_height_above_ground
} MIOLLaveDePronostico;

@interface MIOAdministradorDeDatos ()
@property (nonatomic, strong) NSMutableArray *lineasDelDocumento;
@property (nonatomic, strong) NSMutableArray *lineaActual;
@property MIOZonaDePronostico zonaEnProceso;
@property (nonatomic, strong) NSMutableDictionary *arregloDePronosticosPorZona;
@end

@implementation MIOAdministradorDeDatos

+ (MIOAdministradorDeDatos *)instanciaCompartida {
    static dispatch_once_t pred;
    static id instanciaCompartida = nil;
    dispatch_once(&pred, ^{
        instanciaCompartida = [[MIOAdministradorDeDatos alloc] init];
        [instanciaCompartida inicializarInstancia];
    });
    return instanciaCompartida;
}

- (void)inicializarInstancia {
	self.arregloDePronosticosPorZona = [NSMutableDictionary dictionaryWithObjects:@[@[], @[], @[], @[], @[], @[], @[], @[]]
                                                                          forKeys:@[@(MIOZonaDePronosticoNortePacificoNorte), @(MIOZonaDePronosticoCentroPacificoNorte), @(MIOZonaDePronosticoSurPacificoNorte), @(MIOZonaDePronosticoPuntarenas), @(MIOZonaDePronosticoPacificoCentral), @(MIOZonaDePronosticoPacificoSur), @(MIOZonaDePronosticoCaribe), @(MIOZonaDePronosticoIslaDelCoco)]];
}


#pragma mark Métodos Para el Manejo de Red de Pronosticos Locales
- (void) procesarPronosticosLocales{
    self.zonaEnProceso = MIOZonaDePronosticoNortePacificoNorte;
    
    //Bloque de éxito al pedir pronósticos locales
    void (^exito)(NSDictionary *) = ^void(NSDictionary * contexto) {
        [self guardarPronosticosConContexto:contexto];
    };
    //Bloque de fallo al pedir pronósticos locales
    void (^fallo)() = ^void() {
        NSLog(@"Fallo");
    };
    
    for (int zona = 0; zona < MIOZonaDePronosticoCantidadDeZonas; ++zona) {
        [[MIOAdministradorDeServiciosDeRed instanciaCompartida] obtenerDatosDePronosticoLocalParaZona:zona bloqueExito:exito bloqueFallo:fallo];
    }
}

- (void)guardarPronosticosConContexto:(NSDictionary *)contexto{
    [self.arregloDePronosticosPorZona setObject:[contexto objectForKey:@"datosDePronostico"] forKey:[contexto objectForKey:@"zonaDePronostico"]];
}

#pragma mark Métodos Para el Procesamiento de Datos Para Los Pronosticos Locales
- (NSArray *)obtenerDatosDePronosticoConTipo:(MIOZonaDePronostico)zona{
    self.lineasDelDocumento = [self.arregloDePronosticosPorZona objectForKey:@(zona)];
    if(![self.lineasDelDocumento count])
        return nil;
         
    NSMutableArray *pronosticos = [NSMutableArray array];
    [[self.arregloDePronosticosPorZona objectForKey:@(zona)] enumerateObjectsUsingBlock:^(id dato, NSUInteger indiceDePronostico, BOOL *stop) {
        NSMutableDictionary *pronostico = [NSMutableDictionary dictionary];
        [pronostico setObject:@([self obtenerValorVientoConIndice:indiceDePronostico]) forKey:PRONOSTICO_VALOR_VIENTO];
        [pronostico setObject:@([self obtenerDireccionDelVientoConIndice:indiceDePronostico]) forKey:PRONOSTICO_DIRECCION_VIENTO];
        [pronostico setObject:@([self obtenerAlturaDeOlaConIndice:indiceDePronostico]) forKey:PRONOSTICO_ALTURA_OLA];
        [pronostico setObject:@([self obtenerAlturaMaximaDeOlaConIndice:indiceDePronostico]) forKey:PRONOSTICO_ALTURA_MAXIMA_OLA];
        [pronostico setObject:@([self obtenerDireccionDeOlaConIndice:indiceDePronostico]) forKey:PRONOSTICO_DIRECCION_OLA];
        [pronostico setObject:@([self obtenerPeriodoDeOlaConIndice:indiceDePronostico]) forKey:PRONOSTICO_PERIODO_OLA];
        [pronostico setObject:[self obtenerHoraDePronosticoConIndice:indiceDePronostico] forKey:PRONOSTICO_HORA];
        [pronosticos addObject:pronostico];
    }];
    return pronosticos;
}

- (NSString *)obtenerHoraDePronosticoConIndice:(NSUInteger)indice{
    NSArray *pronostico = [self.lineasDelDocumento objectAtIndex:indice];
    NSString *horaYFecha = [pronostico objectAtIndex:MIOLLaveDePronostico_Time];
    return horaYFecha;
}

- (float)obtenerValorVientoConIndice:(NSUInteger)indice{
    //sqrt(pow(u,2) + Math.pow(v,2)) * 3.6;
    NSArray *pronostico = [self.lineasDelDocumento objectAtIndex:indice];
    float u = [[pronostico objectAtIndex:MIOLLaveDePronostico_wnd_ucmp_height_above_ground] floatValue];
    float v = [[pronostico objectAtIndex:MIOLLaveDePronostico_wnd_vcmp_height_above_ground] floatValue];
    float velocidadDelViento =  sqrt(pow(u, 2.0) + pow(v, 2.0)) * 3.6;
    return velocidadDelViento;
}

- (float)obtenerDireccionDelVientoConIndice:(NSUInteger)indice{
    //abs(atan2(v,u) * (180 / PI) - 90)
    NSArray *pronostico = [self.lineasDelDocumento objectAtIndex:indice];
    float u = [[pronostico objectAtIndex:MIOLLaveDePronostico_wnd_ucmp_height_above_ground] floatValue];
    float v = [[pronostico objectAtIndex:MIOLLaveDePronostico_wnd_vcmp_height_above_ground] floatValue];
    float direccion = atan2f(u,v);
    return direccion;
}

- (float)obtenerAlturaDeOlaConIndice:(NSUInteger)indice{
    //'LatLon_14X16-11p0N-87p00W/sig_wav_ht_surface'
    NSArray *pronostico = [self.lineasDelDocumento objectAtIndex:indice];
    float altura = [[pronostico objectAtIndex:MIOLLaveDePronostico_sig_wav_ht_surface] floatValue];
    return altura;
}

- (float)obtenerAlturaMaximaDeOlaConIndice:(NSUInteger)indice{
    //'LatLon_14X16-11p0N-87p00W/max_wav_ht_surface'
    NSArray *pronostico = [self.lineasDelDocumento objectAtIndex:indice];
    float alturaMaxima = [[pronostico objectAtIndex:MIOLLaveDePronostico_max_wav_ht_surface] floatValue];
    return alturaMaxima;
}

- (float)obtenerDireccionDeOlaConIndice:(NSUInteger)indice{
    //'LatLon_14X16-11p0N-87p00W/peak_wav_dir_surface' - 180
    NSArray *pronostico = [self.lineasDelDocumento objectAtIndex:indice];
    float altura = M_PI * [[pronostico objectAtIndex:MIOLLaveDePronostico_peak_wav_dir_surface] floatValue] / 180 - M_PI;
    return altura;
}

- (float)obtenerPeriodoDeOlaConIndice:(NSUInteger)indice{
    //'LatLon_14X16-11p0N-87p00W/peak_wav_per_surface'
    NSArray *pronostico = [self.lineasDelDocumento objectAtIndex:indice];
    float periodo = [[pronostico objectAtIndex:MIOLLaveDePronostico_peak_wav_per_surface] floatValue];
    return periodo;
}

@end
