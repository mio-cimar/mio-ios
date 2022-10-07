#import "MIOMenuPrincipalSecundariaTableViewCell.h"

@interface MIOMenuPrincipalSecundariaTableViewCell ()
@property (nonatomic, strong) UILabel *etiquetaDeCelda;
@property (nonatomic, strong) UIImageView *iconoDeCelda;
@property (nonatomic, strong) UIView *indicadorDeSeleccionDeCelda;
@end

@implementation MIOMenuPrincipalSecundariaTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self dibujarInterfaz];
    }
    return self;
}

- (void)prepareForReuse{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark Métodos de Interfaz
- (void)dibujarInterfaz{
    self.backgroundColor = COLOR_FONDO_GRIS;
    self.separatorInset = UIEdgeInsetsMake(0, 100, 0, 0);
    
    [self.contentView addSubview:self.etiquetaDeCelda];
    [self.contentView addSubview:self.iconoDeCelda];
    NSDictionary *vistas = @{@"etiquetaDeCelda":self.etiquetaDeCelda, @"iconoDeCelda":self.iconoDeCelda};
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[etiquetaDeCelda(90)]-(>=8)-[iconoDeCelda(22)]-|" options:0 metrics:nil views:vistas]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[etiquetaDeCelda]|" options:0 metrics:nil views:vistas]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[iconoDeCelda(22)]" options:0 metrics:nil views:vistas]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.iconoDeCelda attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
}

- (UILabel *)etiquetaDeCelda{
    if(!_etiquetaDeCelda){
        _etiquetaDeCelda = [UILabel new];
        _etiquetaDeCelda.font = [UIFont systemFontOfSize:16];
        _etiquetaDeCelda.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _etiquetaDeCelda;
}

- (UIImageView *)iconoDeCelda{
    if(!_iconoDeCelda){
        _iconoDeCelda = [UIImageView new];
        _iconoDeCelda.translatesAutoresizingMaskIntoConstraints = NO;
        _iconoDeCelda.image = [UIImage imageNamed:@"icono_menu_secundario"];
    }
    return _iconoDeCelda;
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

@end