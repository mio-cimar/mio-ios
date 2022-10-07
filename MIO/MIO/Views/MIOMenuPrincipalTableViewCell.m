#import "MIOMenuPrincipalTableViewCell.h"

@interface MIOMenuPrincipalTableViewCell (){
    BOOL tieneSubOpciones;
}
@property (nonatomic, strong) UILabel *etiquetaDeCelda;
@property (nonatomic, strong) UIImageView *iconoDeCelda;
@property (nonatomic, strong) UIImageView *iconoFlecha;
@property (nonatomic, strong) UIView *indicadorDeSeleccionDeCelda;
@end

@implementation MIOMenuPrincipalTableViewCell
@synthesize tieneSubOpciones;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self dibujarInterfaz];
        tieneSubOpciones = NO;
        self.opcionesAbiertas = NO;
    }
    return self;
}

- (void)prepareForReuse{
    tieneSubOpciones = NO;
    self.opcionesAbiertas = NO;
    self.etiquetaDeCelda.text = @"";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark Métodos de Interfaz
- (void)dibujarInterfaz{
    self.backgroundColor = COLOR_FONDO_GRIS_SUAVE;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.contentView addSubview:self.etiquetaDeCelda];
    [self.contentView addSubview:self.iconoDeCelda];
    [self.contentView addSubview:self.indicadorDeSeleccionDeCelda];
    [self.contentView addSubview:self.iconoFlecha];
    NSDictionary *vistas = @{@"etiquetaDeCelda":self.etiquetaDeCelda, @"iconoDeCelda":self.iconoDeCelda, @"indicadorDeSeleccionDeCelda":self.indicadorDeSeleccionDeCelda, @"iconoFlecha":self.iconoFlecha};
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[indicadorDeSeleccionDeCelda(4)]-[iconoDeCelda(30)]-[etiquetaDeCelda]|" options:0 metrics:nil views:vistas]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[etiquetaDeCelda]|" options:0 metrics:nil views:vistas]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[iconoDeCelda(30)]" options:0 metrics:nil views:vistas]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[indicadorDeSeleccionDeCelda]|" options:0 metrics:nil views:vistas]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.iconoDeCelda attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    //Ícono de flecha
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[iconoFlecha(22)]" options:0 metrics:nil views:vistas]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[iconoFlecha(22)]-|" options:0 metrics:nil views:vistas]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.iconoFlecha attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
}

- (UILabel *)etiquetaDeCelda{
    if(!_etiquetaDeCelda){
        _etiquetaDeCelda = [UILabel new];
        _etiquetaDeCelda.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _etiquetaDeCelda;
}

- (UIImageView *)iconoDeCelda{
    if(!_iconoDeCelda){
        _iconoDeCelda = [UIImageView new];
        _iconoDeCelda.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _iconoDeCelda;
}

- (UIImageView *)iconoFlecha{
    if(!_iconoFlecha){
        _iconoFlecha = [UIImageView new];
        _iconoFlecha.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _iconoFlecha;
}

- (UIView *)indicadorDeSeleccionDeCelda{
    if(!_indicadorDeSeleccionDeCelda){
        _indicadorDeSeleccionDeCelda = [UIView new];
        _indicadorDeSeleccionDeCelda.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _indicadorDeSeleccionDeCelda;
}

- (void)textoDeCelda:(NSString *)texto{
    [self.etiquetaDeCelda setText:texto];
}

- (void)iconoDeCeldaConNombreDeImagen:(NSString *)nombre{
    [self.iconoDeCelda setImage:[UIImage imageNamed:nombre]];
}

- (void)cambiarIndicadorDeFlechaAbierto:(BOOL)estado{
    if(tieneSubOpciones){
        [self.iconoFlecha setImage:[UIImage imageNamed:estado ? @"icono_menu_abierto" :  @"icono_menu_cerrado"]];
    }
}

- (void)establecerSeleccionDeCelda:(BOOL)estado{
    if(estado){
        self.indicadorDeSeleccionDeCelda.backgroundColor = COLOR_AZUL_SUAVE;
        if(tieneSubOpciones){
            [self.iconoFlecha setImage:[UIImage imageNamed: self.opcionesAbiertas ? @"icono_menu_abierto" : @"icono_menu_cerrado"]];
        }
        else{
            [self.iconoFlecha setImage:nil];
        }
    }
    else {
        self.indicadorDeSeleccionDeCelda.backgroundColor = COLOR_FONDO_GRIS_SUAVE;
        if(tieneSubOpciones){
            [self.iconoFlecha setImage:[UIImage imageNamed: @"icono_menu_cerrado"]];
        }
        else{
            [self.iconoFlecha setImage:nil];
        }
    }
}
@end