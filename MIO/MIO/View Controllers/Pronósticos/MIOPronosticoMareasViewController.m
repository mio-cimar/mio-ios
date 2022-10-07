#import "MIOPronosticoMareasViewController.h"
#import "MIOPestanaDePronosticoDeMareaUIView.h"
#import "MIOAdministradorDeDatos.h"
#import "MIOTablaDePronosticosMareas.h"
#import "MIOZonaDePronosticoTableViewCell.h"
#define ANCHO_TAB 175
#define ALTO_TAB 80

static MIOZonaDePronostico primerZonaSeleccionada;

@interface MIOPronosticoMareasViewController () <ViewPagerDataSource, ViewPagerDelegate, UITableViewDataSource, UITableViewDelegate> {
    MIOZonaDePronostico zonaSeleccionada;
}
@property (nonatomic, strong) UITableView *tablaDePronosticosActual;
@property (nonatomic, strong) UITableView *tablaListaDeZonas;
@property (nonatomic, strong) NSMutableArray *arregloDePestanas;
@end

@implementation MIOPronosticoMareasViewController

#pragma mark Métodos del ciclo de vida del controlador
- (MIOPronosticoMareasViewController *)init
{
    self = [super init];
    if (self) {
        _arregloDePestanas = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self iniciarControlador];
    [self iniciarInformacionDePronosticos];
    [self mostrarListaDeZonas];
}

#pragma mark Misceláneos
- (void)iniciarControlador{
    self.navigationController.navigationBar.translucent = NO;
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.dataSource = self;
    self.delegate = self;
}

- (void)iniciarInformacionDePronosticos{
    zonaSeleccionada = MIOZonaDePronosticoCaribe;
    [[MIOAdministradorDeDatos instanciaCompartida] procesarDocumentosParaZona:zonaSeleccionada];
}

- (void)mostrarListaDeZonas{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self.view addSubview:[self tablaListaDeZonasDePronosticos]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[lista]|" options:0 metrics:nil views:@{@"lista":self.tablaListaDeZonas}]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[lista]|" options:0 metrics:nil views:@{@"lista":self.tablaListaDeZonas}]];
    });
}

- (void)ocultarListaDeZonasConIndice:(MIOZonaDePronostico)indice{
    [self selectTabAtIndex:indice];
    primerZonaSeleccionada = indice;
    //Desvanece la lista de zonas y la remueve del padre
    [UIView animateWithDuration:0.25 animations:^{
        self.tablaListaDeZonas.alpha = 0;
    }completion:^(BOOL finished) {
        [self.tablaListaDeZonas removeFromSuperview];
    }];
    //Espera hasta que la lista de zonas desaparezca
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:1
                         animations:^{//Corre la tabla hacia para mostrar el mapa escondido
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

#pragma mark Métodos del Delegate y del Data Source para el View Pager
//Cantidad de Pronósticos a mostrar
- (NSUInteger)numberOfTabsForViewPager:(ViewPagerController *)viewPager {
    return MIOZonaDePronosticoCantidadDeZonas;
}

- (UIView *)viewPager:(ViewPagerController *)viewPager contentViewForTabAtIndex:(NSUInteger)index {
    NSArray *datos = [[MIOAdministradorDeDatos instanciaCompartida] obtenerDatosDePronosticoConTipo:zonaSeleccionada numero:1];
    MIOTablaDePronosticosMareas *vistaDePronosticos = [[MIOTablaDePronosticosMareas alloc] initWithData:datos tipo:(MIOZonaDePronostico)index];
    self.tablaDePronosticosActual = vistaDePronosticos.tablaDePronosticos;
    return vistaDePronosticos;
}

- (UIView *)viewPager:(ViewPagerController *)viewPager viewForTabAtIndex:(NSUInteger)index {
    MIOPestanaDePronosticoDeMareaUIView *vistaDePestana = [[MIOPestanaDePronosticoDeMareaUIView alloc] initWithFrame:CGRectMake(0, 0, ANCHO_TAB, ALTO_TAB)];
    switch (index) {
        case 0:
            [vistaDePestana establecerNombreDePestana:@"Norte Pacífico Norte"];
            vistaDePestana.tag = zonaSeleccionada = MIOZonaDePronosticoNortePacificoNorte;
            break;
        case 1:
            [vistaDePestana establecerNombreDePestana:@"Centro Pacífico Norte"];
            vistaDePestana.tag = zonaSeleccionada = MIOZonaDePronosticoCentroPacificoNorte;
            break;
        case 2:
            [vistaDePestana establecerNombreDePestana:@"Sur Pacífico Norte"];
            vistaDePestana.tag = zonaSeleccionada = MIOZonaDePronosticoSurPacificoNorte;
            break;
        case 3:
            [vistaDePestana establecerNombreDePestana:@"Puntarenas"];
            vistaDePestana.tag = zonaSeleccionada = MIOZonaDePronosticoPuntarenas;
            break;
        case 4:
            [vistaDePestana establecerNombreDePestana:@"Pacífico Central"];
            vistaDePestana.tag = zonaSeleccionada = MIOZonaDePronosticoPacificoCentral;
            break;
        case 5:
            [vistaDePestana establecerNombreDePestana:@"Pacífico Sur"];
            vistaDePestana.tag = zonaSeleccionada = MIOZonaDePronosticoPacificoSur;
            break;
        case 6:
            [vistaDePestana establecerNombreDePestana:@"Caribe"];
            vistaDePestana.tag = zonaSeleccionada = MIOZonaDePronosticoCaribe;
            break;
        case 7:
            [vistaDePestana establecerNombreDePestana:@"Isla del Coco"];
            vistaDePestana.tag = zonaSeleccionada = MIOZonaDePronosticoIslaDelCoco;
            break;
        default:
            break;
    }
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
            zonaSeleccionada = MIOZonaDePronosticoNortePacificoNorte;
            break;
        case 1:
            zonaSeleccionada = MIOZonaDePronosticoCentroPacificoNorte;
            break;
        case 2:
            zonaSeleccionada = MIOZonaDePronosticoSurPacificoNorte;
            break;
        case 3:
            zonaSeleccionada = MIOZonaDePronosticoPuntarenas;
            break;
        case 4:
            zonaSeleccionada = MIOZonaDePronosticoPacificoCentral;
            break;
        case 5:
            zonaSeleccionada = MIOZonaDePronosticoPacificoSur;
            break;
        case 6:
            zonaSeleccionada = MIOZonaDePronosticoCaribe;
            break;
        case 7:
            zonaSeleccionada = MIOZonaDePronosticoIslaDelCoco;
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
            return 0.0;
        case ViewPagerOptionTabLocation:
            return 1.0;
        case ViewPagerOptionTabOffset:
            return CGRectGetWidth(self.view.frame)/2;
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
    [self ocultarListaDeZonasConIndice:(MIOZonaDePronostico)indexPath.row];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MIOZonaDePronosticoTableViewCell *celdaPronostico = [tableView dequeueReusableCellWithIdentifier:MIOIdentificadorDeCeldaDeZonaDePronostico];
    [celdaPronostico establecerCeldaDeZonaConIndice:(MIOZonaDePronostico)indexPath.row];
    return celdaPronostico;
}

@end