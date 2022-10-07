#import "MIOAdministradorDeServiciosDeRed.h"
#import "NSDictionary+Methods.h"
#import "NSData+Methods.h"
#import "AFHTTPRequestOperationManager.h"

@implementation MIOAdministradorDeServiciosDeRed

+ (MIOAdministradorDeServiciosDeRed *)instanciaCompartida{
    static dispatch_once_t pred;
    static id instanciaCompartida = nil;
    dispatch_once(&pred, ^{
            instanciaCompartida = [[MIOAdministradorDeServiciosDeRed alloc] init];
        });
    return instanciaCompartida;
}

//Método para obtener de un nodo el nombre del documento del pronóstico local correspondiente
//Parámetros:
//- Zona del pronóstico local
//- Bloque de éxito/fallo del Administrador de Datos para utilizar en un método subsecuente una vez que se
//  obtiene en este método el nombre del documento de la zona
- (void)obtenerDatosDePronosticoLocalParaZona:(MIOZonaDePronostico)zona
                                  bloqueExito:(void (^)())exito
                                  bloqueFallo:(void (^)())fallo
{
    //Bloques de Éxito
    void (^exitoConNodo)(AFHTTPRequestOperation*, id) = ^void(AFHTTPRequestOperation *operation, id response) {
        NSLog(@"Éxito de zona %d", zona);
        NSDictionary *contexto = @{@"nombreDeArhivo":[[[[[response firstObject] objectForKey:@"field_csv"] objectForKey:@"und"] firstObject] objectForKey:@"filename"],
                                   @"zonaDePronostico":@(zona)};
        [[MIOAdministradorDeServiciosDeRed instanciaCompartida] obtenerPronosticoLocalConContexto:contexto bloqueExito:exito bloqueFallo:fallo];
    };
    //Bloque de fallo para el llamado al nodo
    void (^falloConNodo)(AFHTTPRequestOperation*, NSError*) = ^void(AFHTTPRequestOperation* operation, NSError* error) {
        NSLog(@"Fallo %d",zona); //TODO
    };
    
    NSLog(@"Llamado de zona %d", zona);
    //Ajuste de 1 entre el enum de Zona de Pronosticos y los números de nodos
    [[MIOAdministradorDeServiciosDeRed instanciaCompartida] obtenerNodoConId:(zona + 1) bloqueExito:exitoConNodo bloqueFallo:falloConNodo];
}

//Método para obtener la información de un documento de un pronóstico local
//Parámetros:
//- Contexto recibe {nombreDelArchivo:___, zonaDePronostico:___}
//- Bloque de éxito/fallo del Administrador de Datos
- (void)obtenerPronosticoLocalConContexto:(NSDictionary *)contexto
                              bloqueExito:(void (^)(NSDictionary *))exito
                              bloqueFallo:(void (^)())fallo
{
    //Formar la URL del archivo
    NSString *direccionDelArchivo = [NSString stringWithFormat:@"%@%@%@", API_ROOT, API_CSV_LOCATION, [contexto objectForKey:@"nombreDeArhivo"]];
    NSURL *URL = [NSURL URLWithString:direccionDelArchivo];
    NSLog(@"Archivo: %@", URL);

    //Crear la solicitud y la operación con la URL del archivo
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    //Establecer los serializadores de la respuesta en la operación
    AFHTTPResponseSerializer *responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/csv", @"text/csv", nil];
    operation.responseSerializer = responseSerializer;
    
    //Si la operación es exitosa, enviar los datos al Administrador de Datos mediante su bloque de ´
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray *arregloDeRespuesta = [NSMutableArray arrayWithArray:[operation.responseString componentsSeparatedByString:@"\n"]];
        [arregloDeRespuesta removeObject:arregloDeRespuesta.firstObject];
        [arregloDeRespuesta removeObject:arregloDeRespuesta.lastObject];
        [arregloDeRespuesta enumerateObjectsUsingBlock:^(id hileraDePronostico, NSUInteger idx, BOOL *stop) {
            [arregloDeRespuesta setObject:[hileraDePronostico componentsSeparatedByString:@","] atIndexedSubscript:idx];
        }];
        //Enviar los datos al Administrador de Datos mediante su bloque de éxito
        exito(@{@"datosDePronostico":arregloDeRespuesta, @"zonaDePronostico":[contexto objectForKey:@"zonaDePronostico"]});
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error); //TODO
    }];
    
    //Añadir la operación a la cola principal de ejecución
    [[NSOperationQueue mainQueue] addOperation:operation];
}


//Método para obtener información de un nodo
//Parámetros:
//- Nodo identificador en la taxonomía
//- Bloque de éxito/fallo del llamado
- (void)obtenerNodoConId:(NSInteger)nodo
             bloqueExito:(void (^)(AFHTTPRequestOperation *operation, id responseObject))exito
             bloqueFallo:(void (^)(AFHTTPRequestOperation *operation, NSError *error))fallo
{
    // Crear Dirección a llamar
    NSString *url = API_ROOT API_GET_NODE;

    //Generar cuerpo del POST (NSData) con el diccionario que lleva la llave del nodo a solicitar
    NSDictionary *diccionarioDeSolicitud = @{@"tid":@(nodo)};
    NSString *hileraJsonDeSolicitud = [diccionarioDeSolicitud jsonStringWithPrettyPrint:NO];
    NSData *cuerpoDelPost = [hileraJsonDeSolicitud dataUsingEncoding:NSASCIIStringEncoding];

    //Añadiendo al encabezado el largo del contenido (Content-Length)
    unsigned long long postLength = cuerpoDelPost.length;
    NSString *largoDelContenido = [NSString stringWithFormat:@"%llu", postLength];

    // Crear solicitud (request) e inicializarla
    NSMutableURLRequest *solicitud = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [solicitud setHTTPMethod:@"POST"];
    [solicitud setValue: @"application/json" forHTTPHeaderField:@"Content-Type"];
    [solicitud addValue:largoDelContenido forHTTPHeaderField:@"Content-Length"];
    [solicitud setHTTPBody:cuerpoDelPost];

    //Configurar una operación AFHTTPRequestOperation y realizar el llamado al servidor con la misma
    AFHTTPRequestOperation *operacion = [[AFHTTPRequestOperation alloc] initWithRequest:solicitud];
    operacion.responseSerializer = [AFJSONResponseSerializer serializer];
    [operacion setCompletionBlockWithSuccess:exito failure:fallo];
    [operacion start];
}

@end
