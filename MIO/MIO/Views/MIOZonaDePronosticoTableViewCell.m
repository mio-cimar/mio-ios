#import "MIOZonaDePronosticoTableViewCell.h"

@interface MIOZonaDePronosticoTableViewCell()
@property (nonatomic, strong) UILabel *nombreDeZona;
@property (nonatomic, strong) UIImageView *iconoDeZona;
@end

@implementation MIOZonaDePronosticoTableViewCell

- (MIOZonaDePronosticoTableViewCell *)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self dibujarInterfaz];
    }
    return self;
}

- (void)prepareForReuse{
    self.nombreDeZona.text = @"";
    self.iconoDeZona.image = nil;
}

- (void)dibujarInterfaz{
    UILabel *nombreDeZona = [UILabel new];
    nombreDeZona.backgroundColor = COLOR_BLANCO;
    nombreDeZona.translatesAutoresizingMaskIntoConstraints = NO;
    nombreDeZona.textAlignment = NSTextAlignmentLeft;
    nombreDeZona.font = [UIFont boldSystemFontOfSize:18];
    self.nombreDeZona = nombreDeZona;
    
    UIImageView *iconoDeZona = [UIImageView new];
    iconoDeZona.backgroundColor = COLOR_SIN_COLOR;
    iconoDeZona.translatesAutoresizingMaskIntoConstraints = NO;
    iconoDeZona.contentMode = UIViewContentModeScaleAspectFit;
    self.iconoDeZona = iconoDeZona;
    
    UIView *separador = [UIView new];
    separador.backgroundColor = COLOR_FONDO_GRIS_SUAVE;
    separador.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary *vistas = NSDictionaryOfVariableBindings(nombreDeZona, iconoDeZona, separador);
    
    //Agrengando los campos a la celda
    [self.contentView addSubview:self.nombreDeZona];
    [self.contentView addSubview:self.iconoDeZona];
    [self.contentView addSubview:separador];
    
    //Añadiendo las reglas a la vista principal de la celda
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-4-[iconoDeZona(60)]-[nombreDeZona]|"
                                                                             options:NSLayoutFormatAlignAllTop | NSLayoutFormatAlignAllBottom
                                                                             metrics:nil views:vistas]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-4-[iconoDeZona]-4-|"
                                                                             options:0
                                                                             metrics:nil views:vistas]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[separador]|" options:0 metrics:nil views:vistas]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[separador(1)]|" options:0 metrics:nil views:vistas]];
}

- (void)establecerCeldaDeZonaConIndice:(MIOZonaDePronostico)indice{
    switch (indice) {
        case MIOZonaDePronosticoNortePacificoNorte:
            self.nombreDeZona.text = @"Norte Pacífico Norte";
            self.iconoDeZona.image = [UIImage imageNamed:@"mapa_mini_norte_pacifico"];
            break;
        case MIOZonaDePronosticoCentroPacificoNorte:
            self.nombreDeZona.text = @"Centro Pacífico Norte";
            self.iconoDeZona.image = [UIImage imageNamed:@"mapa_mini_centro_pacifico_norte"];
            break;
        case MIOZonaDePronosticoSurPacificoNorte:
            self.nombreDeZona.text = @"Sur Pacífico Norte";
            self.iconoDeZona.image = [UIImage imageNamed:@"mapa_mini_sur_pacifico_norte"];
            break;
        case MIOZonaDePronosticoPuntarenas:
            self.nombreDeZona.text = @"Puntarenas";
            self.iconoDeZona.image = [UIImage imageNamed:@"mapa_mini_puntarenas"];
            break;
        case MIOZonaDePronosticoPacificoCentral:
            self.nombreDeZona.text = @"Pacífico Central";
            self.iconoDeZona.image = [UIImage imageNamed:@"mapa_mini_pacifico_central"];
            break;
        case MIOZonaDePronosticoPacificoSur:
            self.nombreDeZona.text = @"Pacífico Sur";
            self.iconoDeZona.image = [UIImage imageNamed:@"mapa_mini_pacifico_sur"];
            break;
        case MIOZonaDePronosticoCaribe:
            self.nombreDeZona.text = @"Caribe";
            self.iconoDeZona.image = [UIImage imageNamed:@"mapa_mini_caribe"];
            break;
        case MIOZonaDePronosticoIslaDelCoco:
            self.nombreDeZona.text = @"Isla del Coco";
            self.iconoDeZona.image = [UIImage imageNamed:@"mapa_mini_isla_coco"];
            break;
        default:
            self.nombreDeZona.text = @"";
            break;
    }
}

@end