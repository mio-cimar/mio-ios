#import "MIOTablaDePronosticosMareas.h"
#import "MIOPronosticoTableViewCell.h"
#import "YLMoment.h"

#define ALTURA_PIE_DE_VISTA_DE_PRONOSTICOS 25
#define DURACION_DE_ANIMACION 0.25

@interface MIOTablaDePronosticosMareas() <UITableViewDelegate, UITableViewDataSource> {
    BOOL usuarioInteractuandoConVista;
}
@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) NSMutableDictionary *datosPorDiaParaPronostico;
@property (nonatomic, strong) UIView *encabezadoDeVista;
@property MIOZonaDePronostico tablaDeTipoZona;
@end

@implementation MIOTablaDePronosticosMareas
- (MIOTablaDePronosticosMareas *)initWithData:(NSArray *)data tipo:(MIOZonaDePronostico)tipo{
    self = [super init];
    if (self) {
        self.data = data;
        self.tablaDeTipoZona = tipo;
        self.datosPorDiaParaPronostico = [NSMutableDictionary dictionary];
        [self dibujarVistaDeTablaDePronosticos];
        [self inicializarCantidadesParaSeccionesEnTabla];
        usuarioInteractuandoConVista = NO;
    }
    return self;
}

- (void)dibujarVistaDeTablaDePronosticos{
    UIView *vistaDePronostico = (UIView *)self;
    
    UIView *encabezadoDePronosticos = [self encabezadoPronosticos];
    [vistaDePronostico addSubview:encabezadoDePronosticos];
    UIImageView *vistaPrevia = [self vistaPreviaDeZona];
    [vistaDePronostico addSubview:vistaPrevia];
    UITableView *tablaDePronosticosActual = [self crearTablaDePronosticos];
    [vistaDePronostico addSubview:tablaDePronosticosActual];
    UIView *pieDeVistaDePronosticos = [self pieDeVistaDePronosticos];
    [vistaDePronostico addSubview:pieDeVistaDePronosticos];
    
    NSDictionary *vistas = NSDictionaryOfVariableBindings(tablaDePronosticosActual, encabezadoDePronosticos, vistaPrevia, pieDeVistaDePronosticos);
    [vistaDePronostico addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[tablaDePronosticosActual]|" options:0 metrics:nil views:vistas]];
    [vistaDePronostico addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[encabezadoDePronosticos(25)][tablaDePronosticosActual]|" options:NSLayoutFormatAlignAllLeft | NSLayoutFormatAlignAllRight metrics:nil views:vistas]];
    [vistaDePronostico addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[vistaPrevia]|" options:0 metrics:nil views:vistas]];
    [vistaDePronostico addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-25-[vistaPrevia]" options:0 metrics:nil views:vistas]];
    [vistaDePronostico addConstraint:[NSLayoutConstraint constraintWithItem:vistaPrevia attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:vistaDePronostico attribute:NSLayoutAttributeHeight multiplier:0.25 constant:0]];
    
    [vistaDePronostico setBackgroundColor:[UIColor colorWithRed:236.0/255.0 green:240.0/255.0 blue:241.0/255.0 alpha:1]];
    
    [vistaDePronostico addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[pieDeVistaDePronosticos]|" options:0 metrics:nil views:vistas]];
    [vistaDePronostico addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[pieDeVistaDePronosticos(pieDeVistaDePronosticos)]|" options:0 metrics:@{@"pieDeVistaDePronosticos":@ALTURA_PIE_DE_VISTA_DE_PRONOSTICOS} views:vistas]];
}

- (UIView *)encabezadoPronosticos{
    UIView *contenedor = [self vistaDeClase:NSStringFromClass([UIView class]) enContenedor:nil];
    UIView *etiquetaIconoViento = [self vistaDeClase:NSStringFromClass([UIView class]) enContenedor:contenedor];
    UILabel *etiquetaOrientacionViento = [self vistaDeClase:NSStringFromClass([UILabel class]) enContenedor:contenedor];
    UILabel *etiquetaVelocidad = [self vistaDeClase:NSStringFromClass([UILabel class]) enContenedor:contenedor];
    UILabel *etiquetaRafaga = [self vistaDeClase:NSStringFromClass([UILabel class]) enContenedor:contenedor];
    UIView *etiquetaIconoOla = [self vistaDeClase:NSStringFromClass([UIView class]) enContenedor:contenedor];
    UILabel *etiquetaOrientacionOla = [self vistaDeClase:NSStringFromClass([UILabel class]) enContenedor:contenedor];
    UILabel *etiquetaAlturaSignificativa = [self vistaDeClase:NSStringFromClass([UILabel class]) enContenedor:contenedor];
    UILabel *etiquetaAlturaMaxima = [self vistaDeClase:NSStringFromClass([UILabel class]) enContenedor:contenedor];
    UILabel *etiquetaPeriodo = [self vistaDeClase:NSStringFromClass([UILabel class]) enContenedor:contenedor];
    etiquetaOrientacionViento.attributedText = [self hilera:[[NSMutableAttributedString alloc] initWithString:@"O"] conSubindice:@"W" tamano:9];
    etiquetaVelocidad.attributedText = [self hilera:[[NSMutableAttributedString alloc] initWithString:@"V"] conSubindice:@" " tamano:9];
    etiquetaRafaga.attributedText = [self hilera:[[NSMutableAttributedString alloc] initWithString:@"Ráfaga"] conSubindice:@" " tamano:1];
    etiquetaRafaga.font = [UIFont systemFontOfSize:10];
    etiquetaOrientacionOla.attributedText = [self hilera:[[NSMutableAttributedString alloc] initWithString:@"O"] conSubindice:@"H" tamano:9];
    etiquetaAlturaSignificativa.attributedText = [self hilera:[[NSMutableAttributedString alloc] initWithString:@"H"] conSubindice:@"sig" tamano:9];
    etiquetaAlturaMaxima.attributedText = [self hilera:[[NSMutableAttributedString alloc] initWithString:@"H"] conSubindice:@"máx" tamano:9];
    etiquetaPeriodo.attributedText = [self hilera:[[NSMutableAttributedString alloc] initWithString:@"T"] conSubindice:@"p" tamano:9];
    
    UIView *contenedorIconoHora = [self vistaDeClase:NSStringFromClass([UIView class]) enContenedor:contenedor];
    UIImageView *iconoHora = [self vistaDeClase:NSStringFromClass([UIImageView class]) enContenedor:contenedorIconoHora];
    [iconoHora setImage:[UIImage imageNamed:@"Reloj_Mareas"]];
    [iconoHora setContentMode:UIViewContentModeScaleAspectFit];
    [contenedorIconoHora addConstraint:[NSLayoutConstraint constraintWithItem:iconoHora attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:contenedorIconoHora attribute:NSLayoutAttributeHeight multiplier:0.60 constant:0]];
    [contenedorIconoHora addConstraint:[NSLayoutConstraint constraintWithItem:iconoHora attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:contenedorIconoHora attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [contenedorIconoHora addConstraint:[NSLayoutConstraint constraintWithItem:iconoHora attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:contenedorIconoHora attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    NSDictionary *vistas = NSDictionaryOfVariableBindings(contenedorIconoHora, etiquetaIconoViento, etiquetaOrientacionViento, etiquetaVelocidad, etiquetaRafaga, etiquetaIconoOla, etiquetaOrientacionOla, etiquetaAlturaSignificativa, etiquetaAlturaMaxima, etiquetaPeriodo);
    //Añadiendo las reglas al contenedor
    NSDictionary *metricas = @{@"rell":@4};
    [contenedor addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[contenedorIconoHora(30)]-rell-[etiquetaIconoViento(etiquetaOrientacionViento)]-rell-[etiquetaOrientacionViento(etiquetaVelocidad)]-rell-[etiquetaVelocidad(etiquetaRafaga)]-rell-[etiquetaRafaga(etiquetaIconoOla)][etiquetaIconoOla(etiquetaOrientacionOla)]-rell-[etiquetaOrientacionOla(etiquetaAlturaSignificativa)]-rell-[etiquetaAlturaSignificativa(etiquetaAlturaMaxima)]-rell-[etiquetaAlturaMaxima(etiquetaPeriodo)]-rell-[etiquetaPeriodo]|" options:NSLayoutFormatAlignAllTop | NSLayoutFormatAlignAllBottom metrics:metricas views:vistas]];
    [contenedor addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[contenedorIconoHora]|" options:0 metrics:metricas views:vistas]];
    
    return self.encabezadoDeVista = contenedor;
}

- (UIImageView *)vistaPreviaDeZona{
    NSString *nombreDeImagen = @"";
    switch (self.tablaDeTipoZona) {
        case MIOZonaDePronosticoNortePacificoNorte:
            nombreDeImagen = @"mapa_escondido_norte_pacifico_norte";
            break;
        case MIOZonaDePronosticoCentroPacificoNorte:
            nombreDeImagen = @"mapa_escondido_centro_pacifico_norte";
            break;
        case MIOZonaDePronosticoSurPacificoNorte:
            nombreDeImagen = @"mapa_escondido_sur_pacifico_norte";
            break;
        case MIOZonaDePronosticoPuntarenas:
            nombreDeImagen = @"mapa_escondido_puntarenas";
            break;
        case MIOZonaDePronosticoPacificoCentral:
            nombreDeImagen = @"mapa_escondido_pacifico_central";
            break;
        case MIOZonaDePronosticoPacificoSur:
            nombreDeImagen = @"mapa_escondido_pacifico_sur";
            break;
        case MIOZonaDePronosticoCaribe:
            nombreDeImagen = @"mapa_escondido_caribe";
            break;
        case MIOZonaDePronosticoIslaDelCoco:
            nombreDeImagen = @"mapa_escondido_isla_coco";
            break;
        default:
            break;
    }
    UIImageView *prevista = [[UIImageView alloc] initWithImage:[UIImage imageNamed:nombreDeImagen]];
    prevista.translatesAutoresizingMaskIntoConstraints = NO;
    prevista.contentMode = UIViewContentModeScaleAspectFit;
    return prevista;
}

- (UITableView *)crearTablaDePronosticos{
    UITableView *tablaDePronosticos;
    tablaDePronosticos = [UITableView new];
    tablaDePronosticos.translatesAutoresizingMaskIntoConstraints = NO;
    tablaDePronosticos.dataSource = self;
    tablaDePronosticos.delegate = self;
    tablaDePronosticos.backgroundColor = [UIColor clearColor];
    [tablaDePronosticos setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [tablaDePronosticos setContentInset:UIEdgeInsetsMake(0, 0, ALTURA_PIE_DE_VISTA_DE_PRONOSTICOS, 0)];
    [tablaDePronosticos registerClass:[MIOPronosticoTableViewCell class] forCellReuseIdentifier:MIOIdentificadorDeCeldaDePronostico];
    return self.tablaDePronosticos = tablaDePronosticos;
}

- (UIView *)pieDeVistaDePronosticos{
    //Estableciendo primer y último día de pronósticos
    YLMoment *primerDiaDePronostico = [YLMoment momentWithDateAsString:[[self.data firstObject] objectForKey:PRONOSTICO_HORA]];
    [primerDiaDePronostico setTimeZone:[NSTimeZone timeZoneWithName:@"CST"]];
    [primerDiaDePronostico setLocale:[NSLocale localeWithLocaleIdentifier:@"es_ES"]];
    YLMoment *ultimoDiaDePronostico = [YLMoment momentWithDateAsString:[[self.data lastObject] objectForKey:PRONOSTICO_HORA]];
    [ultimoDiaDePronostico setTimeZone:[NSTimeZone timeZoneWithName:@"CST"]];
    [ultimoDiaDePronostico setLocale:[NSLocale localeWithLocaleIdentifier:@"es_ES"]];
    
    //Estableciendo datos de fecha de pronóstico
    UILabel *fechaDePronostico = [UILabel new];
    fechaDePronostico.translatesAutoresizingMaskIntoConstraints = NO;
    fechaDePronostico.font = [UIFont boldSystemFontOfSize:13];
    fechaDePronostico.text = [NSString stringWithFormat:@"%@%@%@%@", @"Válido del ", [primerDiaDePronostico format:@"EEEE d 'de' MMMM"], @" al ", [ultimoDiaDePronostico format:@"EEEE d 'de' MMMM"]];
    
    //Estableciendo efecto de transparencia a la etiqueta
    UIBlurEffect *efectoBlur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    UIVisualEffectView *pieDeVistaDePronosticos = [[UIVisualEffectView alloc] initWithEffect:efectoBlur];
    pieDeVistaDePronosticos.translatesAutoresizingMaskIntoConstraints = NO;
    
    UIVibrancyEffect *efectoVibrancy = [UIVibrancyEffect effectForBlurEffect:efectoBlur];
    UIVisualEffectView *vistaEfectoVibrancy = [[UIVisualEffectView alloc] initWithEffect:efectoVibrancy];
    pieDeVistaDePronosticos.translatesAutoresizingMaskIntoConstraints = NO;
    
    [[vistaEfectoVibrancy contentView] addSubview:fechaDePronostico];
    [[pieDeVistaDePronosticos contentView] addSubview:vistaEfectoVibrancy];
    
    //Añadir reglas de Autolayout al pie de table
    pieDeVistaDePronosticos.translatesAutoresizingMaskIntoConstraints = NO;
    [pieDeVistaDePronosticos addSubview:fechaDePronostico];
    [pieDeVistaDePronosticos addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[fechaDePronostico]|" options:0 metrics:nil views:@{@"fechaDePronostico":fechaDePronostico}]];
    [pieDeVistaDePronosticos addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-30-[fechaDePronostico]|" options:0 metrics:nil views:@{@"fechaDePronostico":fechaDePronostico}]];
    return pieDeVistaDePronosticos;
}

#pragma mark Misceláneos
- (id)vistaDeClase:(NSString *)class enContenedor:(UIView *)contenedor{
    id vista = [NSClassFromString(class) new];
    [(UIView *)vista setTranslatesAutoresizingMaskIntoConstraints:NO];
    [vista setBackgroundColor:COLOR_BLANCO];
    [contenedor addSubview:vista];
    if([class isEqual:NSStringFromClass([UILabel class])]){
        [(UILabel *)vista setFont:[UIFont systemFontOfSize:12]];
        [(UILabel *)vista setTextAlignment:NSTextAlignmentCenter];
    }
    return vista;
}

- (NSMutableAttributedString *)hilera:(NSMutableAttributedString *)hilera conSubindice:(NSString *)subindice tamano:(NSInteger)tamano{
    NSDictionary *atributosParaExponente =  @{NSBaselineOffsetAttributeName: @(-6),
                                              NSFontAttributeName:[UIFont systemFontOfSize:tamano]};
    NSAttributedString *subindiceConAtributos = [[NSAttributedString alloc] initWithString:subindice attributes:atributosParaExponente];
    [hilera appendAttributedString:subindiceConAtributos];
    return hilera;
}

- (void)inicializarCantidadesParaSeccionesEnTabla{
    //Iniciar el diccionario cuyas llaves son fechas y valores son la cantidad de pronósticos para esa fecha
    [self.data enumerateObjectsUsingBlock:^(NSDictionary *pronostico, NSUInteger indice, BOOL *stop) {
        YLMoment *momentoDelPronostico;
        momentoDelPronostico = [YLMoment momentWithDateAsString:[pronostico objectForKey:PRONOSTICO_HORA]];
        momentoDelPronostico.timeZone = [NSTimeZone timeZoneWithName:@"CST"];
        //Este formato de fecha permite ordenarlo alfabéticamente
        NSString *llaveDiaMesAnno = [momentoDelPronostico format:@"YYYY/MM/dd"];
        NSString *cantidadDeDatosParaDia = [self.datosPorDiaParaPronostico objectForKey:llaveDiaMesAnno];
        [self.datosPorDiaParaPronostico setObject:@([cantidadDeDatosParaDia integerValue] + 1) forKey:llaveDiaMesAnno];
        
        momentoDelPronostico = nil;
    }];
}

#pragma mark Métodos del Delegate y Data Source para Table View
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.datosPorDiaParaPronostico count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    //Obtener llaves del diccionario y ordenarlas
    NSArray *fechas = [[self.datosPorDiaParaPronostico allKeys] mutableCopy];
    fechas = [fechas sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    NSString *fecha = fechas[section]; //Obtener la fecha que corresponde a la sección
    
    YLMoment *momentoDelPronostico = [YLMoment momentWithDateAsString:fecha];
    momentoDelPronostico.timeZone = [NSTimeZone timeZoneWithName:@"CST"];
    momentoDelPronostico.locale = [NSLocale localeWithLocaleIdentifier:@"es_ES"];
    
    //Establecer una etiqueta con la fecha de la agrupación de los pronósticos
    UILabel *fechaDePronostico = [UILabel new];
    [fechaDePronostico setTranslatesAutoresizingMaskIntoConstraints:NO];
    [fechaDePronostico setFont:[UIFont boldSystemFontOfSize:13]];
    [fechaDePronostico setTextColor:[UIColor whiteColor]];
    fechaDePronostico.text = [NSString stringWithFormat:@"%@", [momentoDelPronostico format:@"EEEE d, MMMM"]];
    
    //Dibujar encabezado de sección
    UIView *encabezadoDeSeccion = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 20)];
    [encabezadoDeSeccion addSubview:fechaDePronostico];
    [encabezadoDeSeccion addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[fechaDePronostico]|" options:0 metrics:nil views:@{@"fechaDePronostico":fechaDePronostico}]];
    [encabezadoDeSeccion addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-30-[fechaDePronostico]|" options:0 metrics:nil views:@{@"fechaDePronostico":fechaDePronostico}]];
    [encabezadoDeSeccion setBackgroundColor:[UIColor blackColor]];
    
    return encabezadoDeSeccion;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 24;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //Obtener llaves del diccionario y ordenarlas
    NSArray *fechas = [[self.datosPorDiaParaPronostico allKeys] mutableCopy];
    fechas = [fechas sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    NSString *fecha = fechas[section]; //Obtener la fecha que corresponde a la sección
    
    return [[self.datosPorDiaParaPronostico objectForKey:fecha] integerValue];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MIOPronosticoTableViewCell *celdaPronostico = [tableView dequeueReusableCellWithIdentifier:MIOIdentificadorDeCeldaDePronostico];
    
    //Obtener llaves del diccionario y ordenarlas
    NSArray *fechas = [[self.datosPorDiaParaPronostico allKeys] mutableCopy];
    fechas = [fechas sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    //Contar la cantidad de pronósticos hasta la sección actual
    int cantidadDeRegistrosHastaSeccionActual = 0;
    for (int i = 0; i < indexPath.section; ++i) {
        cantidadDeRegistrosHastaSeccionActual += [[self.datosPorDiaParaPronostico objectForKey:fechas[i]] integerValue];
    }
    
    //Sumar a la cantidad de pronósticos la posición de la fila requerida y establecer sus datos
    [celdaPronostico establecerPronosticoConDatos:[self.data objectAtIndex:cantidadDeRegistrosHastaSeccionActual + indexPath.row]];
    return celdaPronostico;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:NO];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (usuarioInteractuandoConVista) {
        int umbral = 50;
        //Si el desplazamiento del contenido de la vista arrastrable sobrepasa el umbral comenzar a desaparecer el encabezado
        if (scrollView.contentOffset.y < -umbral) {
            //Se toma un décimo del tamaño de la tabla como la distancia para desvanecer completamente el encabezado
            float proporcionDeLaAlturaDeLaVistaDesplazable = CGRectGetHeight(scrollView.frame) * 0.1;
            self.encabezadoDeVista.alpha = (proporcionDeLaAlturaDeLaVistaDesplazable + (scrollView.contentOffset.y + umbral)) / proporcionDeLaAlturaDeLaVistaDesplazable;
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (!usuarioInteractuandoConVista) {
        [UIView animateWithDuration:DURACION_DE_ANIMACION animations:^{
            self.encabezadoDeVista.alpha = 1;
        }];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    usuarioInteractuandoConVista = YES;
}

@end