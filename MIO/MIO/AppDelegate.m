#import "AppDelegate.h"
#import "MIOMenuPrincipalViewController.h"
#import "UIImage+Methods.h"
#import "MIOAdministradorDeServiciosDeRed.h"
#import "MIOAdministradorDeDatos.h"

#import <Parse/Parse.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //Configuración de Parse y Push Notifications
    [self configurarAplicacionParaPushNotifications:application];
    if(launchOptions && [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey] && [[launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey] objectForKey:@"aps"]){
        NSDictionary *notificationPayload = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    }

    //Declarando menú principal de la aplicación
    MIOMenuPrincipalViewController *mioMenu = [[MIOMenuPrincipalViewController alloc] init];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window setRootViewController:mioMenu.slidingViewController];
    [self.window makeKeyAndVisible];
    
    //Ajustes iniciales
    [self inizializarAjustesBasicosDeAplicacion];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark Configuración Inicial
- (void)inizializarAjustesBasicosDeAplicacion{
    //Color de la barra de navegación
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageWithColor:COLOR_FONDO_GRIS_SUAVE] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[UIImage imageWithColor:COLOR_FONDO_GRIS_SUAVE]];
    
    //Fondo de la barra superior de estado
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    CGRect marcoDeLaPantallaPrincipal = [[UIScreen mainScreen] bounds];
    UIView *fondoDeLaBarraDeStatus = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(marcoDeLaPantallaPrincipal), 20)];
    fondoDeLaBarraDeStatus.backgroundColor = COLOR_AZUL_BARRA_DE_ESTADO;
    [self.window.rootViewController.view addSubview:fondoDeLaBarraDeStatus];
    
    //Comenzar procesamiento de datos desde el servidor
    [[MIOAdministradorDeDatos instanciaCompartida] procesarPronosticosLocales];
}

#pragma mark Congiguración de Notificaciones Remotas (Push Notifications)
- (void)configurarAplicacionParaPushNotifications:(UIApplication *)aplicacion {
    //Configuración de Parse
    [Parse setApplicationId:@"RBAdaMQa61JPS31ptEpapIQyCFMzrpgqjRjZYUeA" clientKey:@"OlaFgNrc4h4yAJuvqOBKXJ6uNGPleDqakuh046HS"];
    
    //Hacer que el app registre notificaciones remotas
    UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound);
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes categories:nil];
    [aplicacion registerUserNotificationSettings:settings];
    [aplicacion registerForRemoteNotifications];
    
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Guardar el token del dispositivo en la instalación actual y guardarlo en Parse
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
}

//Cuando la aplicación recibe una push notification y se encuentra abierta se maneja en este método
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
}

@end
