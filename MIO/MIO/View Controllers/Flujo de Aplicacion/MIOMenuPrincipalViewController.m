#import "MIOMenuPrincipalViewController.h"
#import "MIOMenuPrincipalTableViewCell.h"
#import "MIOMenuPrincipalSecundariaTableViewCell.h"
#import "MIOContactoViewController.h"

//Controladores de vistas para el menú principal
#import "MIOPronosticoMareasViewController.h"

typedef enum {
    MIOMenuPrincipalOpcionPronosticos,
    MIOMenuPrincipalOpcionSecundariaPronosticosLocales,
    MIOMenuPrincipalOpcionSecundariaPronosticosRegionales,
    MIOMenuPrincipalOpcionAdvertencias,
    MIOMenuPrincipalOpcionMareas,
    MIOMenuPrincipalOpcionCalendario,
    MIOMenuPrincipalOpcionTransmision,
    MIOMenuPrincipalOpcionContacto,
    MIOMenuPrincipalOpcionCantidadDeOpciones
} MIOMenuPrincipalOpcion;

@interface MIOMenuPrincipalViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UIImageView *encabezadoDeMenu;
@property (nonatomic, strong) UITableView *tablaDeMenu;
@property (nonatomic, strong) NSMutableDictionary *mostrandoOpcionesDeSubmenu;
@property (nonatomic)  BOOL primeraVezEnLaAplicacion;
@property (nonatomic)  MIOMenuPrincipalOpcion celdaSeleccionada;
@property BOOL isShowingMenu;
@end

@implementation MIOMenuPrincipalViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self inicializarControladorDeVistaDeslizante];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self dibujarInterfazDeMenu];
    [self anchorRight];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loadView{
    UIView *vistaPrincipal = [UIView new];
    vistaPrincipal.frame = CGRectMake(0, 0, MENU_PRINCIPAL_ANCHO, 1000);
    self.view = vistaPrincipal;
}

#pragma mark Métodos de Interfaz
- (void)inicializarControladorDeVistaDeslizante{
    //Estableciendo los bordes extendidos
    self.edgesForExtendedLayout = UIRectEdgeBottom | UIRectEdgeLeft;

    //Inicializar arreglo de subopciones
    [self inicializarOpcionesEspecialesDeMenu];
    
    //Estableciendo el primer controlador de vista a la hora de lanzar la aplicación
    UIViewController *primerControladorDeVista;
    if(self.primeraVezEnLaAplicacion){
        primerControladorDeVista = [[MIOPronosticoMareasViewController alloc] init];
        primerControladorDeVista.navigationItem.title = @"Pronósticos";
    }
    else {
        primerControladorDeVista = [[MIOContactoViewController alloc] init];
        primerControladorDeVista.navigationItem.title = @"Contacto";
    }
    UIBarButtonItem *anchorRightButton = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"anchor_right"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                                          style:UIBarButtonItemStylePlain
                                                                         target:self
                                                                         action:@selector(anchorRight)];
    
    
    primerControladorDeVista.navigationItem.leftBarButtonItem = anchorRightButton;

    //Inicializando el controlador de navegación para el menú
    UINavigationController *controladorDeNavegacion = [[UINavigationController alloc] initWithRootViewController:primerControladorDeVista];
    controladorDeNavegacion.navigationBar.translucent = NO;
    [controladorDeNavegacion.navigationBar setShadowImage:[[UIImage alloc] init]];

    //Iinicializando el menú deslizante
    self.slidingViewController = [ECSlidingViewController slidingWithTopViewController:controladorDeNavegacion];
    self.slidingViewController.anchorRightRevealAmount  = MENU_PRINCIPAL_ANCHO;
    [self.slidingViewController setUnderLeftViewController:self];
    self.isShowingMenu = NO;
}

- (void)dibujarInterfazDeMenu{
    [self.view setBackgroundColor:COLOR_FONDO_GRIS];
    [self.view addSubview:self.encabezadoDeMenu];
    [self.view addSubview:self.tablaDeMenu];
    
    NSDictionary *vistas = @{@"encabezadoDeMenu":self.encabezadoDeMenu, @"tablaDeMenu":self.tablaDeMenu};
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[encabezadoDeMenu][tablaDeMenu]|"
                                                                      options:NSLayoutFormatAlignAllLeft | NSLayoutFormatAlignAllRight
                                                                      metrics:nil
                                                                        views:vistas]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[encabezadoDeMenu]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:vistas]];
}

- (UIImageView *)encabezadoDeMenu{
    if(!_encabezadoDeMenu){
        _encabezadoDeMenu = [UIImageView new];
        _encabezadoDeMenu.translatesAutoresizingMaskIntoConstraints = NO;
        _encabezadoDeMenu.image = [UIImage imageNamed:@"Menu_Principal_Encabezado"];
        _encabezadoDeMenu.backgroundColor = COLOR_BLANCO;
    }
    return _encabezadoDeMenu;
}

- (UITableView *)tablaDeMenu{
    if(!_tablaDeMenu){
        _tablaDeMenu = [UITableView new];
        _tablaDeMenu.translatesAutoresizingMaskIntoConstraints = NO;
        _tablaDeMenu.backgroundColor = COLOR_SIN_COLOR;
        _tablaDeMenu.dataSource = self;
        _tablaDeMenu.delegate = self;
        _tablaDeMenu.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        [_tablaDeMenu registerClass:[MIOMenuPrincipalTableViewCell class] forCellReuseIdentifier:MIOIdentificadorDeCeldaDeMenuPrincipal];
        [_tablaDeMenu registerClass:[MIOMenuPrincipalSecundariaTableViewCell class] forCellReuseIdentifier:MIOIdentificadorDeCeldaSecundariaDeMenuPrincipal];
    }
    return _tablaDeMenu;
}

#pragma mark Métodos del Delegate y Data Source para Table View
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    MIOMenuPrincipalOpcion opcion = (MIOMenuPrincipalOpcion)indexPath.row;
    switch (opcion) {
        case MIOMenuPrincipalOpcionSecundariaPronosticosLocales:
        case MIOMenuPrincipalOpcionSecundariaPronosticosRegionales:{
            return [[self.mostrandoOpcionesDeSubmenu objectForKey:@(MIOMenuPrincipalOpcionPronosticos)] boolValue] ? 50 : 0;
            break;
        }
        default:
            return 60;
            break;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return MIOMenuPrincipalOpcionCantidadDeOpciones;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    switch (indexPath.row) {
        case MIOMenuPrincipalOpcionPronosticos:
            cell = [tableView dequeueReusableCellWithIdentifier:MIOIdentificadorDeCeldaDeMenuPrincipal];
            [(MIOMenuPrincipalTableViewCell*) cell textoDeCelda:@"Pronósticos"];
            [(MIOMenuPrincipalTableViewCell*) cell iconoDeCeldaConNombreDeImagen:@"Menu_Principal_Icono_Pronosticos"];
            ((MIOMenuPrincipalTableViewCell*) cell).tieneSubOpciones = YES;
            ((MIOMenuPrincipalTableViewCell*) cell).opcionesAbiertas = [[self.mostrandoOpcionesDeSubmenu objectForKey:@(MIOMenuPrincipalOpcionPronosticos)] boolValue];
            [(MIOMenuPrincipalTableViewCell *)cell establecerSeleccionDeCelda:NO];
            break;
        case MIOMenuPrincipalOpcionSecundariaPronosticosLocales:
            cell = [tableView dequeueReusableCellWithIdentifier:MIOIdentificadorDeCeldaSecundariaDeMenuPrincipal];
            cell.hidden = ![[self.mostrandoOpcionesDeSubmenu objectForKey:@(MIOMenuPrincipalOpcionPronosticos)] boolValue];
            [(MIOMenuPrincipalSecundariaTableViewCell *) cell textoDeCelda:@"Locales"];
            break;
        case MIOMenuPrincipalOpcionSecundariaPronosticosRegionales:
            cell = [tableView dequeueReusableCellWithIdentifier:MIOIdentificadorDeCeldaSecundariaDeMenuPrincipal];
            cell.hidden = ![[self.mostrandoOpcionesDeSubmenu objectForKey:@(MIOMenuPrincipalOpcionPronosticos)] boolValue];
            [(MIOMenuPrincipalSecundariaTableViewCell *) cell textoDeCelda:@"Regionales"];
            break;
        case MIOMenuPrincipalOpcionAdvertencias:
            cell = [tableView dequeueReusableCellWithIdentifier:MIOIdentificadorDeCeldaDeMenuPrincipal];
            [(MIOMenuPrincipalTableViewCell*) cell textoDeCelda:@"Advertencias"];
            [(MIOMenuPrincipalTableViewCell*) cell iconoDeCeldaConNombreDeImagen:@"Menu_Principal_Icono_Advertencias"];
            break;
        case MIOMenuPrincipalOpcionMareas:
            cell = [tableView dequeueReusableCellWithIdentifier:MIOIdentificadorDeCeldaDeMenuPrincipal];
            [(MIOMenuPrincipalTableViewCell*) cell textoDeCelda:@"Mareas"];
            [(MIOMenuPrincipalTableViewCell*) cell iconoDeCeldaConNombreDeImagen:@"Menu_Principal_Icono_Mareas"];
            break;
        case MIOMenuPrincipalOpcionCalendario:
            cell = [tableView dequeueReusableCellWithIdentifier:MIOIdentificadorDeCeldaDeMenuPrincipal];
            [(MIOMenuPrincipalTableViewCell*) cell textoDeCelda:@"Calendario"];
            [(MIOMenuPrincipalTableViewCell*) cell iconoDeCeldaConNombreDeImagen:@"Menu_Principal_Icono_Calendario"];
            break;
        case MIOMenuPrincipalOpcionTransmision:
            cell = [tableView dequeueReusableCellWithIdentifier:MIOIdentificadorDeCeldaDeMenuPrincipal];
            [(MIOMenuPrincipalTableViewCell*) cell textoDeCelda:@"Transmisión en vivo"];
            [(MIOMenuPrincipalTableViewCell*) cell iconoDeCeldaConNombreDeImagen:@"Menu_Principal_Icono_Transmision"];
            break;
        case MIOMenuPrincipalOpcionContacto:
            cell = [tableView dequeueReusableCellWithIdentifier:MIOIdentificadorDeCeldaDeMenuPrincipal];
            [(MIOMenuPrincipalTableViewCell*) cell textoDeCelda:@"Contacto"];
            [(MIOMenuPrincipalTableViewCell*) cell iconoDeCeldaConNombreDeImagen:@"Menu_Principal_Icono_Contacto"];
            break;
        default:
            break;
    }
    if(indexPath.row == self.celdaSeleccionada &&
       indexPath.row != MIOMenuPrincipalOpcionSecundariaPronosticosLocales && indexPath.row != MIOMenuPrincipalOpcionSecundariaPronosticosRegionales)
    {
        [(MIOMenuPrincipalTableViewCell *)cell establecerSeleccionDeCelda:YES];
        [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIViewController *primerControladorDeVista;
    BOOL accion = YES; //Continua la acción o no hace nada en caso de que sea una opción con hijos
    
    self.celdaSeleccionada = (MIOMenuPrincipalOpcion)indexPath.row;
    switch (indexPath.row) {
        case MIOMenuPrincipalOpcionPronosticos:{
            //Cambiar el valor de las opciones del submenu que se muestran
            BOOL mostrando = [[self.mostrandoOpcionesDeSubmenu objectForKey:@(MIOMenuPrincipalOpcionPronosticos)] boolValue];
            [self.mostrandoOpcionesDeSubmenu setObject:@(!mostrando) forKey:@(MIOMenuPrincipalOpcionPronosticos)];
            accion = NO;
            break;
        }
        case MIOMenuPrincipalOpcionSecundariaPronosticosLocales:{
            primerControladorDeVista = [[MIOPronosticoMareasViewController alloc] init];
            primerControladorDeVista.navigationItem.title = @"Pronósticos";
            break;
        }
        case MIOMenuPrincipalOpcionContacto:
            primerControladorDeVista = [[MIOContactoViewController alloc] init];
            primerControladorDeVista.navigationItem.title = @"Contacto";
            break;
        default:
            break;
    }
    [tableView reloadData];
    
    if (!accion) {
        return;
    }
    
    //Establecer botón de menú
    UIBarButtonItem *anchorRightButton = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"anchor_right"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                                          style:UIBarButtonItemStylePlain
                                                                         target:self
                                                                         action:@selector(anchorRight)];
    primerControladorDeVista.navigationItem.leftBarButtonItem = anchorRightButton;
    
    //Inicializando el controlador de navegación para el menú
    [((UINavigationController *)self.slidingViewController.topViewController) pushViewController:primerControladorDeVista animated:NO];
    [self anchorRight];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.mostrandoOpcionesDeSubmenu removeAllObjects];
    if(indexPath.row != MIOMenuPrincipalOpcionSecundariaPronosticosLocales && indexPath.row != MIOMenuPrincipalOpcionSecundariaPronosticosRegionales){
        UITableViewCell *celda = [tableView cellForRowAtIndexPath:indexPath];
        [(MIOMenuPrincipalTableViewCell *)celda establecerSeleccionDeCelda:NO];
    }
}

#pragma mark Misceláneos
- (BOOL)primeraVezEnLaAplicacion{
    return YES;
}

//Establecer las subopciones del menu
- (void)inicializarOpcionesEspecialesDeMenu{
    self.celdaSeleccionada = -1;
    self.mostrandoOpcionesDeSubmenu = [NSMutableDictionary new];
    [self.mostrandoOpcionesDeSubmenu setObject:@NO forKey:@(MIOMenuPrincipalOpcionPronosticos)];
}

- (void)anchorRight {
    if(!self.isShowingMenu){
        [self.slidingViewController anchorTopViewToRightAnimated:YES];
        self.isShowingMenu = YES;
    }
    else{
        [self.slidingViewController resetTopViewAnimated:YES];
        self.isShowingMenu = NO;
    }
}

@end


