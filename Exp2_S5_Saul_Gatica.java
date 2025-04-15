
package com.mycompany.exp2_s5_saul_gatica;

import java.util.Arrays;
import java.util.Scanner;

/**
 *
 * @author saulg
 */
public class Exp2_S5_Saul_Gatica {

    static int totalEntradas = 0;
    
public static void main(String[] args) {
      Scanner scanner = new Scanner(System.in);
      String input = "";
      compra: while (true) {
           System.out.println("Ingresa una opción: ");
           System.out.println("1. Comprar entrada");
           
           System.out.println("2. Salir");
           input = scanner.next().toLowerCase();
           
           switch(input) {
               case "1":
                   int[] asientosPlatea = {1,2,3,4,5,6,7,8,9,10};
                   System.out.println("Asientos Platea");
                   System.out.println(Arrays.toString(asientosPlatea));
                   int[] asientosPlateaAlta = {11,12,13,14,15,16,17,18,19,20};
                   System.out.println("Asientos Platea alta");
                   System.out.println(Arrays.toString(asientosPlateaAlta));
                   int[] asientosPalcos = {21,22,23,24,25,26,27,28,29,30};
                   System.out.println("Asientos Palcos");
                   System.out.println(Arrays.toString(asientosPalcos));
                   System.out.println("Por favor seleccione un asiento");
                   
                   int tipoEntrada = scanner.nextInt();
                   System.out.println(" Por favor indique su edad ");
                   int edad = scanner.nextInt();
                   
                   System.out.println("indique el numero de entradas. Por compras superiores a 5 entradas obtienes un 20% de descuento");
                   int numeroDeEntradas = scanner.nextInt();
                   
                   int plateaBaja = 20000;
                   int plateaAlta = 18000;
                   int palcos = 13000;
                   int asientosDisponibles = 30 - numeroDeEntradas;
                   double descuentoAm = 0.8;
                   double descuentoEst = 0.85;        
                   if(tipoEntrada <11 && edad<18){
                     double precioEntrada = (plateaBaja * descuentoEst);    
                                          System.out.println("Has comprado Asiento Platea baja estudiante. Precio: $ " + plateaBaja*0.85 );   
 
                   }else if(tipoEntrada<11 && edad>64) {
                                        System.out.println("Has comprado Asiento Platea baja adulto mayor. Precio: $"  + plateaBaja*0.8);
                                          double precioEntrada = (plateaBaja * descuentoAm);

                    
                    }else if(tipoEntrada<11 && edad>17 && edad<65) {
                                             System.out.println("Has comprado Asiento Platea baja general. Precio:" + plateaBaja);
                                             double precioEntrada = (plateaBaja);
                    } else if(tipoEntrada<21 && edad<18) {
                                             System.out.println("Has comprado Asiento Platea alta Estudiante. Precio: $" + plateaAlta*0.85 );

                                             double precioEntrada = (plateaAlta * descuentoEst);
                   
                    }else if(tipoEntrada<21 && edad>64) {
                                             System.out.println("Has comprado Asiento Platea alta adulto mayor. Precio: $" + plateaAlta*0.8);  

                                             double precioEntrada = (plateaAlta * descuentoAm);
                     
                    }else if(tipoEntrada<21 && edad<65 && edad>17) {
                                              System.out.println("Has comprado Asiento Platea alta General. Precio: $" + plateaAlta);                 

                                              double precioEntrada = (plateaAlta);
                                   
                      }   else if(tipoEntrada>20 && edad>64) {
                                              System.out.println("Has comprado Asiento Palcos adulto mayor. Precio: $" + palcos*0.8);  

                                               double precioEntrada = (palcos * descuentoAm);
                    
                      }   else if(tipoEntrada>20 && edad<64 && edad>17) {
                                              System.out.println("Has comprado Asiento Palcos  Publico General. Precio: $" + palcos);

                                              double precioEntrada = (palcos);
                    
                      }   else if(tipoEntrada>20 && edad<18) {
                                              System.out.println("Has comprado Asiento Palcos Estudiante. Precio: $" + palcos*0.85 ); {
                          

                          double precioEntrada = (palcos * descuentoAm);
                          
                          
                          if(numeroDeEntradas>5) { continue; 
                     
                          
                          
                      
                          
                      
                          }  System.out.println("Obtendrás un 20% de descuento en el total de tu compra"); }
                              System.out.println(("Entradas por un valor total de :$")+ (numeroDeEntradas * precioEntrada * 0.8)); {
                          if(numeroDeEntradas<6) {
                      
                          } else if(numeroDeEntradas>0) {
                                  
                          System.out.println(("Entradas por un valor total de :$")+ (numeroDeEntradas * precioEntrada)); 
                      
                          System.out.println( "Asientos disponibles: " + asientosDisponibles); {
                           }
                      }
                      }
                          }
                      }
                     
                      }         
                   
                  case "2":
               System.out.println("Gracias por preferir Teatro Moro");
                           
               break compra; 
                      
                      }
                         }
                  }
              
}
           
      



                          
                                  
                                  
                                  
                                          
                          
                                  
                    
                   
                   
     
                              