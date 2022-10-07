#import "MIOPronosticoMareasViewController.h"
#import "MIOPestanaDePronosticoDeMareaUIView.h"
#import "MIOAdministradorDeDatos.h"
#import "MIOTablaDePronosticosMareas.h"
#import "MIOZonaDePronosticoTableViewCell.h"
#define ANCHO_TAB 175
#define ALTO_TAB 80

static MIOZonaDePronostico primerZonaSeleccionada;

@interface MIOPronosticoMareasViewController () <ViewPagerDataSource, ViewPagerDelegate, UITableViewDataSource, UITableViewDelegate> {
}
@property (nonatomic, strong) UITableView *tablaDePronosticosActual;
@property (nonatomic, strong) UITableView *tablaListaDeZonas;
@property (nonatomic, strong) NSMutableArray *arregloDePestanas;
@property MIOZonaDePronostico zonaSeleccionada;
@end

@implementation MIOPronosticoMareasViewController

#pragma mark Métodos del ciclo de vida del controlador
- (MIOPronosticoMareasViewController *)init
{
    self = [super init];
    if (self) {
        _arregloDePestanas = [NSMutableArray array];
        _zonaSeleccionada = MIOZonaDePronosticoNortePacificoNorte;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self iniciarControlador];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self mostrarListaDeZonas];
}

#pragma mark Misceláneos
- (void)iniciarControlador{
    self.navigationController.navigationBar.translucent = NO;
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.view.backgroundColor = COLOR_BLANCO;
    self.dataSource = self;
    self.delegate = self;
}

- (void)mostrarListaDeZonas{
    [self.view addSubview:[self tablaListaDeZonasDePronosticos]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[lista]|" options:0 metrics:nil views:@{@"lista":self.tablaListaDeZonas}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[lista]|" options:0 metrics:nil views:@{@"lista":self.tablaListaDeZonas}]];
}

- (void)ocultarListaDeZonasConIndice:(MIOZonaDePronostico)indice{
    [self selectTabAtIndex:indice];

    //Desvanece la lista de zonas y la remueve del padre
    [UIView animateWithDuration:0.25 animations:^{
        self.tablaListaDeZonas.alpha = 0;
    }completion:^(BOOL finished) {
        [self.tablaListaDeZonas removeFromSuperview];
    }];
    //Espera hasta que la lista de zonas desaparezca
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:1
                         animations:^{//Corre la tabla hacia abajo para mostrar el mapa escondido
                             self.tablaDePronosticosActual.contentOffset = CGPointMake(0, -100);
                         }
                         completion:^(BOOL finished) {
                             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{//Al terminar, vueve la tabla al estado original
                                 [UIView animateWithDuration:0.75 animations:^{
                                     self.tablaDePronosticosActual.contentOffset = CGPointZero;
                                 }];
                             });
                         }];
    });
}

- (NSString *)nombreDeZonaConIdentificador:(MIOZonaDePronostico)zona{
    NSString *nombreDeZona;
    switch (zona) {
        case 0: nombreDeZona = @"Norte Pacífico Norte"; break;
        case 1: nombreDeZona = @"Centro Pacífico Norte"; break;
        case 2: nombreDeZona = @"Sur Pacífico Norte"; break;
        case 3: nombreDeZona = @"Puntarenas"; break;
        case 4: nombreDeZona = @"Pacífico Central"; break;
        case 5: nombreDeZona = @"Pacífico Sur"; break;
        case 6: nombreDeZona = @"Caribe"; break;
        case 7: nombreDeZona = @"Isla del Coco"; break;
        default: nombreDeZona = @""; break;
    }
    return nombreDeZona;
}

#pragma mark Métodos del Delegate y del Data Source para el View Pager
//Cantidad de Pronósticos a mostrar
- (NSUInteger)numberOfTabsForViewPager:(ViewPagerController *)viewPager {
    return MIOZonaDePronosticoCantidadDeZonas;
}

- (UIView *)viewPager:(ViewPagerController *)viewPager contentViewForTabAtIndex:(NSUInteger)index {
    NSArray *datos = [[MIOAdministradorDeDatos instanciaCompartida] obtenerDatosDePronosticoConTipo:(MIOZonaDePronostico)index];
    _zonaSeleccionada = (MIOZonaDePronostico)index;
    if ([datos count]) {
        MIOTablaDePronosticosMareas *vistaDePronosticos = [[MIOTablaDePronosticosMareas alloc] initWithData:datos tipo:(MIOZonaDePronostico)index];
        self.tablaDePronosticosActual = vistaDePronosticos.tablaDePronosticos;
        return vistaDePronosticos;
    }
    else{
        UILabel *etiquetaNoDatos = [UILabel new];
        etiquetaNoDatos.translatesAutoresizingMaskIntoConstraints = NO;
        //etiquetaNoDatos.text = [NSString stringWithFormat:@"%@%@%@", @"Por el momento no hay pronósticos para la zona ", [self nombreDeZonaConIdentificador:(MIOZonaDePronostico)index], @"."];
        etiquetaNoDatos.text = [NSString stringWithFormat:@"Por el momento no hay pronósticos para esta zona."];
        etiquetaNoDatos.numberOfLines = 0;
        etiquetaNoDatos.font = [UIFont systemFontOfSize:16];
        etiquetaNoDatos.textColor = [UIColor colorWithRed:0.263 green:0.249 blue:0.268 alpha:1.000];
        etiquetaNoDatos.textAlignment = NSTextAlignmentCenter;
        
        UIView *vistaSinDatos = [UIView new];
        vistaSinDatos.backgroundColor = COLOR_BLANCO;
        [vistaSinDatos addSubview:etiquetaNoDatos];
        [vistaSinDatos addConstraint:[NSLayoutConstraint constraintWithItem:etiquetaNoDatos attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:vistaSinDatos attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        [vistaSinDatos addConstraint:[NSLayoutConstraint constraintWithItem:etiquetaNoDatos attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:vistaSinDatos attribute:NSLayoutAttributeCenterY multiplier:1 constant:-100]];
        [vistaSinDatos addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-16-[etiqueta]-16-|" options:0 metrics:nil views:@{@"etiqueta":etiquetaNoDatos}]];
        return vistaSinDatos;
    }
}

- (UIView *)viewPager:(ViewPagerController *)viewPager viewForTabAtIndex:(NSUInteger)index {
	MIOPestanaDePronosticoDeMareaUIView *vistaDePestana = [[MIOPestanaDePronosticoDeMareaUIView alloc] initWithFrame:CGRectMake(0, 0, ANCHO_TAB, ALTO_TAB)];
	switch (index) {
		case 0:
			vistaDePestana.tag = _zonaSeleccionada = MIOZonaDePronosticoNortePacificoNorte;
			break;
		case 1:
			vistaDePestana.tag = _zonaSeleccionada = MIOZonaDePronosticoCentroPacificoNorte;
			break;
		case 2:
			vistaDePestana.tag = _zonaSeleccionada = MIOZonaDePronosticoSurPacificoNorte;
			break;
		case 3:
			vistaDePestana.tag = _zonaSeleccionada = MIOZonaDePronosticoPuntarenas;
			break;
		case 4:
			vistaDePestana.tag = _zonaSeleccionada = MIOZonaDePronosticoPacificoCentral;
			break;
		case 5:
			vistaDePestana.tag = _zonaSeleccionada = MIOZonaDePronosticoPacificoSur;
			break;
		case 6:
			vistaDePestana.tag = _zonaSeleccionada = MIOZonaDePronosticoCaribe;
			break;
		case 7:
			vistaDePestana.tag = _zonaSeleccionada = MIOZonaDePronosticoIslaDelCoco;
			break;
		default:
			break;
	}
	[vistaDePestana establecerNombreDePestana:[self nombreDeZonaConIdentificador:(MIOZonaDePronostico)index]];
	[self.arregloDePestanas addObject:vistaDePestana];
	vistaDePestana.tag = index;
	return vistaDePestana;
}

- (void)viewPager:(ViewPagerController *)viewPager didChangeTabToIndex:(NSUInteger)index {
    for (MIOPestanaDePronosticoDeMareaUIView *pestana in self.arregloDePestanas) {
        [pestana deseleccionarPestana];
    }
    
    switch (index) {
        case 0:
            _zonaSeleccionada = MIOZonaDePronosticoNortePacificoNorte;
            break;
        case 1:
            _zonaSeleccionada = MIOZonaDePronosticoCentroPacificoNorte;
            break;
        case 2:
            _zonaSeleccionada = MIOZonaDePronosticoSurPacificoNorte;
            break;
        case 3:
            _zonaSeleccionada = MIOZonaDePronosticoPuntarenas;
            break;
        case 4:
            _zonaSeleccionada = MIOZonaDePronosticoPacificoCentral;
            break;
        case 5:
            _zonaSeleccionada = MIOZonaDePronosticoPacificoSur;
            break;
        case 6:
            _zonaSeleccionada = MIOZonaDePronosticoCaribe;
            break;
        case 7:
            _zonaSeleccionada = MIOZonaDePronosticoIslaDelCoco;
            break;
        default:
            break;
    }
    [[self.arregloDePestanas objectAtIndex:index] seleccionarPestana];
    NSLog(@"Changed");
}

- (CGFloat)viewPager:(ViewPagerController *)viewPager valueForOption:(ViewPagerOption)option withDefault:(CGFloat)value {
    switch (option) {
        case ViewPagerOptionStartFromSecondTab:
            return 0.0;
        case ViewPagerOptionCenterCurrentTab:
            return 1.0;
        case ViewPagerOptionTabLocation:
            return 1.0;
        //If it's not centered with ViewPagerOptionCenterCurrentTab, this centers the tab.
        //case ViewPagerOptionTabOffset:
        //      return CGRectGetWidth(self.view.frame)/2 - ANCHO_TAB/2;//Centrar pestañas a la hora de seleccionarlas según el ancho de pantalla y el ancho de la pestaña
        case ViewPagerOptionTabHeight:
            return ALTO_TAB;
        case ViewPagerOptionTabWidth:
            return ANCHO_TAB;
        default:
            return value;
    }
}

- (UIColor *)viewPager:(ViewPagerController *)viewPager colorForComponent:(ViewPagerComponent)component withDefault:(UIColor *)color {
    switch (component) {
        case ViewPagerIndicator:
            return [UIColor orangeColor];
        case ViewPagerTabsView:
            return [UIColor whiteColor];
        default:
            return color;
    }
}

#pragma mark Métodos del Table View y sus métodos para Delegate y Data Source
- (UITableView *)tablaListaDeZonasDePronosticos{
    UITableView *listaDeZonas;
    listaDeZonas = [UITableView new];
    listaDeZonas.translatesAutoresizingMaskIntoConstraints = NO;
    listaDeZonas.dataSource = self;
    listaDeZonas.delegate = self;
    listaDeZonas.backgroundColor = COLOR_FONDO_GRIS_SUAVE;
    [listaDeZonas setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [listaDeZonas setContentInset:UIEdgeInsetsMake(64, 0, 0, 0)];
    [listaDeZonas registerClass:[MIOZonaDePronosticoTableViewCell class] forCellReuseIdentifier:MIOIdentificadorDeCeldaDeZonaDePronostico];
    return self.tablaListaDeZonas = listaDeZonas;
}

- (BOOL)automaticallyAdjustsScrollViewInsets{
    return YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    //Establecer una etiqueta con la fecha de la agrupación de los pronósticos
    UILabel *tituloDeListaDeZonas = [UILabel new];
    [tituloDeListaDeZonas setTranslatesAutoresizingMaskIntoConstraints:NO];
    [tituloDeListaDeZonas setFont:[UIFont boldSystemFontOfSize:16]];
    [tituloDeListaDeZonas setTextColor:[UIColor whiteColor]];

    //Dibujar encabezado de sección
    UIView *encabezadoDeSeccion = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 50)];
    [encabezadoDeSeccion setBackgroundColor:[UIColor blackColor]];
    [encabezadoDeSeccion addSubview:tituloDeListaDeZonas];
    [encabezadoDeSeccion addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[tituloDeListaDeZonas]|" options:0 metrics:nil views:@{@"tituloDeListaDeZonas":tituloDeListaDeZonas}]];
    [encabezadoDeSeccion addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-30-[tituloDeListaDeZonas]|" options:0 metrics:nil views:@{@"tituloDeListaDeZonas":tituloDeListaDeZonas}]];

    return encabezadoDeSeccion;
}
   
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   return 8;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _zonaSeleccionada = (MIOZonaDePronostico)indexPath.row;
    [self ocultarListaDeZonasConIndice:_zonaSeleccionada];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MIOZonaDePronosticoTableViewCell *celdaPronostico = [tableView dequeueReusableCellWithIdentifier:MIOIdentificadorDeCeldaDeZonaDePronostico];
    [celdaPronostico establecerCeldaDeZonaConIndice:(MIOZonaDePronostico)indexPath.row];
    return celdaPronostico;
}

@end