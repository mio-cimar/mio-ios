#import "MIOPronosticoTableViewCell.h"
#import "YLMoment.h"

@interface MIOPronosticoTableViewCell(){

}
@property (nonatomic, strong) UILabel *etiquetaHora;
@property (nonatomic, strong) UIImageView *imagenIconoViento;
@property (nonatomic, strong) UIImageView *imagenOrientacionViento;
@property (nonatomic, strong) UILabel *etiquetaVelocidad;
@property (nonatomic, strong) UILabel *etiquetaRafaga;
@property (nonatomic, strong) UIImageView *imagenIconoOla;
@property (nonatomic, strong) UIImageView *imagenOrientacionOla;
@property (nonatomic, strong) UILabel *etiquetaAlturaSignificativaOla;
@property (nonatomic, strong) UILabel *etiquetaAlturaMaximaOla;
@property (nonatomic, strong) UILabel *etiquetaPeriodo;
@end

@implementation MIOPronosticoTableViewCell
- (MIOPronosticoTableViewCell *)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self dibujarInterfaz];
    }
    return self;
}

-(void)prepareForReuse{
    

}

#pragma mark Métodos de Interfaz
- (void)dibujarInterfaz{
    NSDictionary *vistas = @{@"etiquetaHora":self.etiquetaHora, @"imagenIconoViento":self.imagenIconoViento, @"imagenOrientacionOla":self.imagenOrientacionOla,
                             @"etiquetaVelocidad":self.etiquetaVelocidad, @"etiquetaRafaga":self.etiquetaRafaga, @"imagenIconoOla":self.imagenIconoOla,
                             @"imagenOrientacionViento":self.imagenOrientacionViento, @"etiquetaAlturaSignificativaOla":self.etiquetaAlturaSignificativaOla,
                             @"etiquetaAlturaMaximaOla":self.etiquetaAlturaMaximaOla, @"etiquetaPeriodo":self.etiquetaPeriodo};

    //Agrengando los campos del pronóstico a la vista principal
    [self.contentView addSubview:self.etiquetaHora];
    [self.contentView addSubview:self.imagenIconoViento];
    [self.contentView addSubview:self.imagenOrientacionViento];
    [self.contentView addSubview:self.etiquetaVelocidad];
    [self.contentView addSubview:self.etiquetaRafaga];
    [self.contentView addSubview:self.imagenIconoOla];
    [self.contentView addSubview:self.imagenOrientacionOla];
    [self.contentView addSubview:self.etiquetaAlturaSignificativaOla];
    [self.contentView addSubview:self.etiquetaAlturaMaximaOla];
    [self.contentView addSubview:self.etiquetaPeriodo];
    
    //Añadiendo las reglas a la vista principal de la celda con sólo la etiqueta de hora de tamaño fijo
    NSDictionary *metricas = @{@"rell":@4};
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[etiquetaHora(30)]-rell-[imagenIconoViento(imagenOrientacionViento)]-rell-[imagenOrientacionViento(etiquetaVelocidad)]-rell-[etiquetaVelocidad(etiquetaRafaga)]-rell-[etiquetaRafaga(imagenIconoOla)]-rell-[imagenIconoOla(imagenOrientacionOla)]-rell-[imagenOrientacionOla(etiquetaAlturaSignificativaOla)]-rell-[etiquetaAlturaSignificativaOla(etiquetaAlturaMaximaOla)]-rell-[etiquetaAlturaMaximaOla(etiquetaPeriodo)]-rell-[etiquetaPeriodo]|"
                                                                             options:NSLayoutFormatAlignAllTop | NSLayoutFormatAlignAllBottom
                                                                             metrics:metricas views:vistas]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[etiquetaHora]|"
                                                                             options:0
                                                                             metrics:metricas views:vistas]];
}

- (UILabel *)etiquetaHora{
    if(!_etiquetaHora){
        _etiquetaHora = [UILabel new];
        _etiquetaHora.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1];
        _etiquetaHora.translatesAutoresizingMaskIntoConstraints = NO;
        _etiquetaHora.text = @"HH";
        _etiquetaHora.textAlignment = NSTextAlignmentCenter;
        _etiquetaHora.font = [UIFont systemFontOfSize:12];
    }
    return _etiquetaHora;
}

- (UIImageView *)imagenIconoViento{
    if(!_imagenIconoViento){
        _imagenIconoViento = [UIImageView new];
        _imagenIconoViento.translatesAutoresizingMaskIntoConstraints = NO;
        _imagenIconoViento.image = [UIImage imageNamed:[NSString stringWithFormat:@"Viento_Grado_No_Grado"]];
        _imagenIconoViento.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imagenIconoViento;
}

- (UIImageView *)imagenOrientacionOla{
    if(!_imagenOrientacionOla){
        _imagenOrientacionOla = [UIImageView new];
        _imagenOrientacionOla.translatesAutoresizingMaskIntoConstraints = NO;
        _imagenOrientacionOla.image = [UIImage imageNamed:@"Vector_Direccion.png"];
        _imagenOrientacionOla.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imagenOrientacionOla;
}

- (UILabel *)etiquetaVelocidad{
    if(!_etiquetaVelocidad){
        _etiquetaVelocidad = [UILabel new];
        _etiquetaVelocidad.font = [UIFont systemFontOfSize:13];
        _etiquetaVelocidad.translatesAutoresizingMaskIntoConstraints = NO;
        _etiquetaVelocidad.text = @"99.9";
        _etiquetaVelocidad.textAlignment = NSTextAlignmentCenter;
    }
    return _etiquetaVelocidad;
}

- (UILabel *)etiquetaRafaga{
    if(!_etiquetaRafaga){
        _etiquetaRafaga = [UILabel new];
        _etiquetaRafaga.font = [UIFont systemFontOfSize:13];
        _etiquetaRafaga.translatesAutoresizingMaskIntoConstraints = NO;
        _etiquetaRafaga.text = @"99.9";
        _etiquetaRafaga.textAlignment = NSTextAlignmentCenter;
    }
    return _etiquetaRafaga;
}

- (UIImageView *)imagenIconoOla{
    if(!_imagenIconoOla){
        _imagenIconoOla = [UIImageView new];
        _imagenIconoOla.translatesAutoresizingMaskIntoConstraints = NO;
        _imagenIconoOla.image = [UIImage imageNamed:@"Ola_Grado_No_Grado.png"];
        _imagenIconoOla.image = [UIImage imageNamed:[NSString stringWithFormat:@"Ola_Grado_%ld",(random()%3+1)]];
        _imagenIconoOla.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imagenIconoOla;
}

- (UIImageView *)imagenOrientacionViento{
    if(!_imagenOrientacionViento){
        _imagenOrientacionViento = [UIImageView new];
        _imagenOrientacionViento.translatesAutoresizingMaskIntoConstraints = NO;
        _imagenOrientacionViento.image = [UIImage imageNamed:@"Vector_Direccion.png"];
        _imagenOrientacionViento.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imagenOrientacionViento;
}

- (UILabel *)etiquetaAlturaSignificativaOla{
    if(!_etiquetaAlturaSignificativaOla){
        _etiquetaAlturaSignificativaOla = [UILabel new];
        _etiquetaAlturaSignificativaOla.font = [UIFont systemFontOfSize:13];
        _etiquetaAlturaSignificativaOla.translatesAutoresizingMaskIntoConstraints = NO;
        _etiquetaAlturaSignificativaOla.text = @"99.9";
        _etiquetaAlturaSignificativaOla.textAlignment = NSTextAlignmentCenter;
    }
    return _etiquetaAlturaSignificativaOla;
}

- (UILabel *)etiquetaAlturaMaximaOla{
    if(!_etiquetaAlturaMaximaOla){
        _etiquetaAlturaMaximaOla = [UILabel new];
        _etiquetaAlturaMaximaOla.font = [UIFont systemFontOfSize:13];
        _etiquetaAlturaMaximaOla.translatesAutoresizingMaskIntoConstraints = NO;
        _etiquetaAlturaMaximaOla.text = @"99.9";
        _etiquetaAlturaMaximaOla.textAlignment = NSTextAlignmentCenter;
    }
    return _etiquetaAlturaMaximaOla;
}

- (UILabel *)etiquetaPeriodo{
    if(!_etiquetaPeriodo){
        _etiquetaPeriodo = [UILabel new];
        _etiquetaPeriodo.font = [UIFont systemFontOfSize:13];
        _etiquetaPeriodo.translatesAutoresizingMaskIntoConstraints = NO;
        _etiquetaPeriodo.text = @"99.9";
        _etiquetaPeriodo.textAlignment = NSTextAlignmentCenter;
    }
    return _etiquetaPeriodo;
}

#pragma mark Métodos para actualizar celdas
- (void)establecerPronosticoConDatos:(NSDictionary *)datos{
    [self establecerCeldaConHora:[datos objectForKey:PRONOSTICO_HORA]];
    [self establecerCeldaConVientoPromedio:[[datos objectForKey:PRONOSTICO_VALOR_VIENTO] floatValue]];
    [self establecerCeldaConDireccionDeViento:[[datos objectForKey:PRONOSTICO_DIRECCION_VIENTO] floatValue]];
    [self establecerCeldaConAlturaDeOla:[[datos objectForKey:PRONOSTICO_ALTURA_OLA] floatValue]];
    [self establecerCeldaConAlturaMaximaDeOla:[[datos objectForKey:PRONOSTICO_ALTURA_MAXIMA_OLA] floatValue]];
    [self establecerCeldaConDireccionOla:[[datos objectForKey:PRONOSTICO_DIRECCION_OLA] floatValue]];
    [self establecerCeldaConPeriodoDeOla:[[datos objectForKey:PRONOSTICO_PERIODO_OLA] floatValue]];
}

- (void)establecerCeldaConHora:(NSString *)hora{
    YLMoment *horaDePronostico = [YLMoment momentWithDateAsString:hora];
    [horaDePronostico setTimeZone:[NSTimeZone timeZoneWithName:@"CST"]];
    [horaDePronostico setLocale:[NSLocale localeWithLocaleIdentifier:@"es_ES"]];
    
    //Velocidad del viento
    self.etiquetaHora.text = [horaDePronostico format:@"HH"];
}

- (void)establecerCeldaConVientoPromedio:(float)vientoPromedio{
    //Velocidad del viento
    self.etiquetaVelocidad.text = [NSString stringWithFormat:@"%.01f", vientoPromedio];
    //Máxima velocidad del viento - Ráfaga
    self.etiquetaRafaga.text = [NSString stringWithFormat:@"%.01f", vientoPromedio * 1.3];
    //Ícono de velocidad del viento
    if(vientoPromedio < 22){
        self.imagenIconoViento.image = [UIImage imageNamed:[NSString stringWithFormat:@"Viento_Grado_1"]];
    }
    if(vientoPromedio > 22){
        self.imagenIconoViento.image = [UIImage imageNamed:[NSString stringWithFormat:@"Viento_Grado_2"]];
    }
    if(vientoPromedio > 30){
        self.imagenIconoViento.image = [UIImage imageNamed:[NSString stringWithFormat:@"Viento_Grado_3"]];
    }
    if(vientoPromedio > 40){
        self.imagenIconoViento.image = [UIImage imageNamed:[NSString stringWithFormat:@"Viento_Grado_4"]];
    }
}

- (void)establecerCeldaConDireccionDeViento:(float)direccion{
    _imagenOrientacionViento.transform = CGAffineTransformMakeRotation(direccion);
}

- (void)establecerCeldaConAlturaDeOla:(float)altura{
    //Altura significativa de Ola
    self.etiquetaAlturaSignificativaOla.text = [NSString stringWithFormat:@"%.01f", altura];
    //Ícono de altura significativa de ola
    if(altura < 1){
        self.imagenIconoOla.image = [UIImage imageNamed:[NSString stringWithFormat:@"Ola_Grado_1"]];
    }
    if(altura > 1){
        self.imagenIconoOla.image = [UIImage imageNamed:[NSString stringWithFormat:@"Ola_Grado_2"]];
    }
    if(altura > 2){
        self.imagenIconoOla.image = [UIImage imageNamed:[NSString stringWithFormat:@"Ola_Grado_3"]];
    }
    if(altura > 3){
        self.imagenIconoOla.image = [UIImage imageNamed:[NSString stringWithFormat:@"Ola_Grado_4"]];
    }
}

- (void)establecerCeldaConAlturaMaximaDeOla:(float)alturaMaxima{
    self.etiquetaAlturaMaximaOla.text = [NSString stringWithFormat:@"%.01f", alturaMaxima];
}

- (void)establecerCeldaConDireccionOla:(float)direccion{
    self.imagenOrientacionOla.transform = CGAffineTransformMakeRotation(direccion);
}

- (void)establecerCeldaConPeriodoDeOla:(float)periodo{
    self.etiquetaPeriodo.text = [NSString stringWithFormat:@"%.01f", periodo];
}
@end
