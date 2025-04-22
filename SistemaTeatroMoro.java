package duoc.sistemateatromoro;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Scanner;

class Entrada {
    static int contador = 1;
    int id;
    String cliente;
    String funcion;
    int cantidad;
    int[] asientos; 
    boolean pagado;
    double precio;

    public Entrada(String cliente, String funcion, int cantidad, int[] asientos, boolean pagado, double precio) {
        this.id = contador++;
        this.cliente = cliente;
        this.funcion = funcion;
        this.cantidad = cantidad;
        this.asientos = asientos;
        this.pagado = pagado;
        this.precio = precio;
    }

    public void imprimirBoleta() {
        System.out.println("----- BOLETA -----");
        System.out.println("ID: " + id);
        System.out.println("Cliente: " + cliente);
        System.out.println("Función: " + funcion);
        System.out.println("Cantidad: " + cantidad);
        System.out.println("Asientos: " + Arrays.toString(asientos));
        System.out.println("Estado: " + (pagado ? "Comprado" : "Reservado"));
        System.out.println("Precio total: $" + precio);
        System.out.println("------------------");
    }
}

class SistemaTeatro {
    Scanner scanner = new Scanner(System.in);
    List<Entrada> entradas = new ArrayList<>();

    // Método para seleccionar los asientos
    private int[] seleccionarAsientos(int cantidad) {
        int[] asientosSeleccionados = new int[cantidad];
        int[] asientosPlatea = {1,2,3,4,5,6,7,8,9,10};
        int[] asientosPlateaAlta = {11,12,13,14,15,16,17,18,19,20};
        int[] asientosPalcos = {21,22,23,24,25,26,27,28,29,30};

        System.out.println("Asientos disponibles por zona:");
        System.out.println("Platea: " + Arrays.toString(asientosPlatea));
        System.out.println("Platea Alta: " + Arrays.toString(asientosPlateaAlta));
        System.out.println("Palcos: " + Arrays.toString(asientosPalcos));
        System.out.print("Por favor, seleccione " + cantidad + " asiento(s) (ingresar los números de los asientos separados por espacio): ");
       
        String input = scanner.nextLine();
        String[] asientosStr = input.split(" "); // Separar los números por espacios

        
        for (int i = 0; i < cantidad; i++) {
            try {
                asientosSeleccionados[i] = Integer.parseInt(asientosStr[i]);
            } catch (NumberFormatException e) {
                System.out.println("Error al ingresar el número del asiento. Asegúrese de ingresar números válidos.");
                return new int[0]; // Retornar un arreglo vacío en caso de error
            }
        }

        return asientosSeleccionados;
    }

    public void reservarEntrada() {
        System.out.print("Nombre del cliente: ");
        String cliente = scanner.nextLine();
        System.out.print("Nombre de la función: ");
        String funcion = scanner.nextLine();
        System.out.print("Cantidad de entradas: ");
        int cantidad = Integer.parseInt(scanner.nextLine());

        int[] asientosSeleccionados = seleccionarAsientos(cantidad);

        if (asientosSeleccionados.length == 0) {
            System.out.println("Hubo un error al seleccionar los asientos.");
            return;
        }

        double precio = calcularPrecio(asientosSeleccionados);
        Entrada entrada = new Entrada(cliente, funcion, cantidad, asientosSeleccionados, false, precio);
        entradas.add(entrada);
        System.out.println("Entrada reservada con ID: " + entrada.id);
    }

    public void comprarEntrada() {
        System.out.print("Nombre del cliente: ");
        String cliente = scanner.nextLine();
        System.out.print("Nombre de la función: ");
        String funcion = scanner.nextLine();
        System.out.print("Cantidad de entradas: ");
        int cantidad = Integer.parseInt(scanner.nextLine());

        int[] asientosSeleccionados = seleccionarAsientos(cantidad);

        if (asientosSeleccionados.length == 0) {
            System.out.println("Hubo un error al seleccionar los asientos.");
            return;
        }

        double precio = calcularPrecio(asientosSeleccionados);
        Entrada entrada = new Entrada(cliente, funcion, cantidad, asientosSeleccionados, true, precio);
        entradas.add(entrada);
        System.out.println("Compra realizada con ID: " + entrada.id);
    }

    public void modificarVenta() {
        System.out.print("Ingrese ID de la entrada a modificar: ");
        int id = Integer.parseInt(scanner.nextLine());

        for (Entrada e : entradas) {
            if (e.id == id) {
                System.out.print("Nuevo nombre del cliente: ");
                e.cliente = scanner.nextLine();
                System.out.print("Nueva función: ");
                e.funcion = scanner.nextLine();
                System.out.print("Nueva cantidad de entradas: ");
                e.cantidad = Integer.parseInt(scanner.nextLine());

                int[] asientosSeleccionados = seleccionarAsientos(e.cantidad);
                e.asientos = asientosSeleccionados;
                e.precio = calcularPrecio(asientosSeleccionados);

                System.out.print("¿Está pagado? (s/n): ");
                String pagado = scanner.nextLine();
                e.pagado = pagado.equalsIgnoreCase("s");

                System.out.println("Entrada modificada.");
                return;
            }
        }
        System.out.println("No se encontró una entrada con ese ID.");
    }

    public void imprimirBoleta() {
        System.out.print("Ingrese ID de la entrada: ");
        int id = Integer.parseInt(scanner.nextLine());

        for (Entrada e : entradas) {
            if (e.id == id) {
                e.imprimirBoleta();
                return;
            }
        }
        System.out.println("No se encontró una entrada con ese ID.");
    }

    
    private double calcularPrecio(int[] asientos) {
        double precioTotal = 0;
        for (int asiento : asientos) {
            if (asiento <= 10) {
                precioTotal += 20000; // Platea baja
            } else if (asiento <= 20) {
                precioTotal += 15000; // Platea alta
            } else {
                precioTotal += 8000; // Palcos
            }
        }
        return precioTotal;
    }
}

public class SistemaTeatroMoro {
    public static void main(String[] args) {
        SistemaTeatro sistema = new SistemaTeatro();
        Scanner scanner = new Scanner(System.in);
        int opcion;

        do {
            System.out.println("===== MENÚ TEATRO =====");
            System.out.println("1. Reservar entrada");
            System.out.println("2. Comprar entrada");
            System.out.println("3. Modificar venta");
            System.out.println("4. Imprimir boleta");
            System.out.println("0. Salir");
            System.out.print("Seleccione una opción: ");
            opcion = Integer.parseInt(scanner.nextLine());

            switch (opcion) {
                case 1 -> sistema.reservarEntrada();
                case 2 -> sistema.comprarEntrada();
                case 3 -> sistema.modificarVenta();
                case 4 -> sistema.imprimirBoleta();
                case 0 -> System.out.println("Gracias por usar el sistema de compras de Teatro Moro.");
                default -> System.out.println("Opción inválida.");
            }
        } while (opcion != 0);

        
    }
}
