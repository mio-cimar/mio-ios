#import "MIOPestanaDePronosticoDeMareaUIView.h"
#define DURACION_DE_ANIMACION 0.2

@interface MIOPestanaDePronosticoDeMareaUIView (){
    BOOL pestanaSeleccionada;
}
@property (nonatomic, strong) UILabel *etiquetaDePestana;
@property (nonatomic, strong) UIImageView *indicadorPestanaSeleccionada;
@property (nonatomic, strong) UIImageView *indicadorPestanaDeseleccionada;
@end

@implementation MIOPestanaDePronosticoDeMareaUIView

- (MIOPestanaDePronosticoDeMareaUIView *)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        pestanaSeleccionada = NO;
        [self dibujarPestana];
    }
    return self;
}

- (void)dibujarPestana{
    self.backgroundColor = [UIColor whiteColor];
    //Añadir vistas a la pestaña
    [self addSubview:self.etiquetaDePestana];
    [self addSubview:self.indicadorPestanaDeseleccionada];
    [self addSubview:self.indicadorPestanaSeleccionada];
    
    NSDictionary *vistas = @{@"etiqueta":self.etiquetaDePestana, @"indicadorPestanaDeseleccionada":self.indicadorPestanaDeseleccionada, @"indicadorPestanaSeleccionada":self.indicadorPestanaSeleccionada};
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[etiqueta]|" options:0 metrics:nil views:vistas]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-15-[etiqueta(20)]-[indicadorPestanaDeseleccionada(20)]" options:NSLayoutFormatAlignAllLeft | NSLayoutFormatAlignAllRight metrics:nil views:vistas]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[etiqueta]|" options:0 metrics:nil views:vistas]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-15-[etiqueta(20)]-[indicadorPestanaSeleccionada(20)]" options:NSLayoutFormatAlignAllLeft | NSLayoutFormatAlignAllRight metrics:nil views:vistas]];
}

//Etiqueta con nombre de la pestaña
- (UILabel *)etiquetaDePestana{
    if(!_etiquetaDePestana){
        _etiquetaDePestana = [UILabel new];
        _etiquetaDePestana.translatesAutoresizingMaskIntoConstraints = NO;
        _etiquetaDePestana.textColor = [UIColor orangeColor];
        _etiquetaDePestana.textAlignment = NSTextAlignmentCenter;
    }
    return _etiquetaDePestana;
}

//Indicador de selección en pestaña
- (UIImageView *)indicadorPestanaDeseleccionada{
    if(!_indicadorPestanaDeseleccionada){
        _indicadorPestanaDeseleccionada = [UIImageView new];
        _indicadorPestanaDeseleccionada.image = [UIImage imageNamed:@"Ola_Delgada"];
        _indicadorPestanaDeseleccionada.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _indicadorPestanaDeseleccionada;
}

- (UIImageView *)indicadorPestanaSeleccionada{
    if(!_indicadorPestanaSeleccionada){
        _indicadorPestanaSeleccionada = [UIImageView new];
        _indicadorPestanaSeleccionada.image = [UIImage imageNamed:@"Ola_Gruesa"];
        _indicadorPestanaSeleccionada.translatesAutoresizingMaskIntoConstraints = NO;
        _indicadorPestanaSeleccionada.alpha = 0;
    }
    return _indicadorPestanaSeleccionada;
}

- (void)seleccionarPestana{
    if (!pestanaSeleccionada) {
        [UIView animateWithDuration:DURACION_DE_ANIMACION
                         animations:^{
                             self.indicadorPestanaDeseleccionada.alpha = 0.0;
                             self.indicadorPestanaSeleccionada.alpha = 1.0;
                             self.etiquetaDePestana.font = [UIFont boldSystemFontOfSize:17];
                         }];
    }
    pestanaSeleccionada = YES;
}

- (void)deseleccionarPestana{
    if (pestanaSeleccionada) {
        [UIView animateWithDuration:DURACION_DE_ANIMACION
                         animations:^{
                             self.indicadorPestanaDeseleccionada.alpha = 1.0;
                             self.indicadorPestanaSeleccionada.alpha = 0.0;
                             self.etiquetaDePestana.font = [UIFont systemFontOfSize:17];
                         }];
    }
    pestanaSeleccionada = NO;
}

- (void)establecerNombreDePestana:(NSString *)etiqueta{
    self.etiquetaDePestana.text = etiqueta;
}

@end
